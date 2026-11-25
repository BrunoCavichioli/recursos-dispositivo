import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../services/location_service.dart';

class GeolocalizacaoScreen extends StatefulWidget {
  const GeolocalizacaoScreen({super.key});

  @override
  State<GeolocalizacaoScreen> createState() => _GeolocalizacaoScreenState();
}

class _GeolocalizacaoScreenState extends State<GeolocalizacaoScreen> {
  final _locationService = LocationService();
  Position? _posicaoAtual;
  bool _carregando = false;
  bool _rastreando = false;
  String? _mensagemErro;
  StreamSubscription<Position>? _positionStreamSub;

  Future<void> _buscarLocalizacao() async {
    setState(() {
      _carregando = true;
      _mensagemErro = null;
    });

    try {
      final posicao = await _locationService.obterPosicaoAtual();
      if (!mounted) return;
      setState(() => _posicaoAtual = posicao);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _mensagemErro = e.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  Future<void> _alternarRastreamento() async {
    if (_rastreando) {
      await _positionStreamSub?.cancel();
      if (mounted) setState(() => _rastreando = false);
      return;
    }

    try {
      // Valida serviço e permissões antes de iniciar o fluxo contínuo.
      await _locationService.obterPosicaoAtual();
      if (!mounted) return;

      setState(() {
        _rastreando = true;
        _mensagemErro = null;
      });

      _positionStreamSub = _locationService.monitorarPosicao().listen(
        (posicao) {
          if (mounted) setState(() => _posicaoAtual = posicao);
        },
        onError: (erro) {
          if (mounted) {
            setState(() {
              _mensagemErro = 'Não foi possível acompanhar a localização: $erro';
              _rastreando = false;
            });
          }
        },
      );
    } catch (e) {
      if (mounted) {
        setState(() {
          _mensagemErro = e.toString().replaceFirst('Exception: ', '');
        });
      }
    }
  }

  Color _corPrecisao(double precisao) {
    if (precisao < 15) return Colors.green;
    if (precisao <= 50) return Colors.orange;
    return Colors.red;
  }

  String _textoPrecisao(double precisao) {
    if (precisao < 15) return 'Boa precisão';
    if (precisao <= 50) return 'Precisão moderada';
    return 'Baixa precisão';
  }

  @override
  void dispose() {
    _positionStreamSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final posicao = _posicaoAtual;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Geolocalização e GPS',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF246BCE), Color(0xFF4A91E8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.location_searching, color: Colors.white, size: 34),
                SizedBox(height: 18),
                Text('Sua localização em tempo real',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    )),
                SizedBox(height: 6),
                Text(
                  'Capture suas coordenadas ou acompanhe os deslocamentos do dispositivo.',
                  style: TextStyle(color: Colors.white70, height: 1.4),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          if (_carregando)
            const Padding(
              padding: EdgeInsets.all(18),
              child: Center(child: CircularProgressIndicator()),
            ),
          if (_mensagemErro != null) ...[
            Card(
              color: const Color(0xFFFFEEEE),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(_mensagemErro!,
                          style: const TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
          if (posicao != null) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Coordenadas capturadas',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    _DadoLocalizacao(
                      icone: Icons.north,
                      titulo: 'Latitude',
                      valor: posicao.latitude.toStringAsFixed(6),
                    ),
                    const Divider(height: 22),
                    _DadoLocalizacao(
                      icone: Icons.east,
                      titulo: 'Longitude',
                      valor: posicao.longitude.toStringAsFixed(6),
                    ),
                    const Divider(height: 22),
                    _DadoLocalizacao(
                      icone: Icons.terrain,
                      titulo: 'Altitude',
                      valor: '${posicao.altitude.toStringAsFixed(1)} m',
                    ),
                    const Divider(height: 22),
                    _DadoLocalizacao(
                      icone: Icons.speed,
                      titulo: 'Precisão',
                      valor: '${posicao.accuracy.toStringAsFixed(1)} m',
                    ),
                    const SizedBox(height: 14),
                    Chip(
                      avatar: Icon(Icons.gps_fixed,
                          color: _corPrecisao(posicao.accuracy), size: 18),
                      label: Text(_textoPrecisao(posicao.accuracy)),
                      backgroundColor:
                          _corPrecisao(posicao.accuracy).withOpacity(0.12),
                      side: BorderSide(
                          color: _corPrecisao(posicao.accuracy)
                              .withOpacity(0.35)),
                    ),
                  ],
                ),
              ),
            ),
          ] else if (!_carregando && _mensagemErro == null) ...[
            const Card(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  children: [
                    Icon(Icons.map_outlined, size: 42, color: Colors.blueGrey),
                    SizedBox(height: 10),
                    Text('Nenhuma localização capturada',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    SizedBox(height: 4),
                    Text('Toque no botão abaixo para solicitar sua posição.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.blueGrey)),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: 18),
          FilledButton.icon(
            onPressed: _carregando ? null : _buscarLocalizacao,
            icon: const Icon(Icons.gps_fixed),
            label: const Text('Capturar localização atual'),
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: _carregando ? null : _alternarRastreamento,
            icon: Icon(_rastreando ? Icons.stop : Icons.play_arrow),
            label: Text(_rastreando
                ? 'Parar rastreamento contínuo'
                : 'Iniciar rastreamento contínuo'),
          ),
          if (_rastreando)
            const Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text('Rastreamento ativo • atualiza a cada deslocamento.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.green)),
            ),
        ],
      ),
    );
  }
}

class _DadoLocalizacao extends StatelessWidget {
  const _DadoLocalizacao({
    required this.icone,
    required this.titulo,
    required this.valor,
  });

  final IconData icone;
  final String titulo;
  final String valor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icone, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(titulo, style: const TextStyle(color: Colors.blueGrey)),
              const SizedBox(height: 2),
              Text(valor,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 16)),
            ],
          ),
        ),
      ],
    );
  }
}
