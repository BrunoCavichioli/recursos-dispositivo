import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/media_service.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  final _mediaService = MediaService();
  final _nomeController = TextEditingController();
  File? _imagemPerfil;
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarPerfil();
  }

  Future<void> _carregarPerfil() async {
    final prefs = await SharedPreferences.getInstance();
    final caminho = prefs.getString('caminho_foto_perfil');
    final nome = prefs.getString('nome_perfil') ?? '';
    File? imagem;

    if (caminho != null && await File(caminho).exists()) {
      imagem = File(caminho);
    }

    if (!mounted) return;
    setState(() {
      _nomeController.text = nome;
      _imagemPerfil = imagem;
      _carregando = false;
    });
  }

  Future<void> _salvarNome() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('nome_perfil', _nomeController.text.trim());
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Nome salvo com sucesso!')),
    );
  }

  Future<void> _capturarImagem(bool daCamera) async {
    Navigator.pop(context);
    try {
      final imagem = daCamera
          ? await _mediaService.tirarFoto()
          : await _mediaService.selecionarDaGaleria();

      if (imagem == null) return;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('caminho_foto_perfil', imagem.path);

      if (!mounted) return;
      setState(() => _imagemPerfil = imagem);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Não foi possível carregar a imagem: $e')),
      );
    }
  }

  Future<void> _removerFoto() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('caminho_foto_perfil');
    if (!mounted) return;
    setState(() => _imagemPerfil = null);
    Navigator.pop(context);
  }

  void _exibirOpcoesMidia() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.blue),
                title: const Text('Tirar foto com a câmera'),
                onTap: () => _capturarImagem(true),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: Colors.blue),
                title: const Text('Escolher da galeria'),
                onTap: () => _capturarImagem(false),
              ),
              if (_imagemPerfil != null)
                ListTile(
                  leading: const Icon(Icons.delete_outline, color: Colors.red),
                  title: const Text('Remover foto',
                      style: TextStyle(color: Colors.red)),
                  onTap: _removerFoto,
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _abrirFotoEmTelaCheia() {
    final imagem = _imagemPerfil;
    if (imagem == null) return;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _FotoTelaCheia(imagem: imagem),
      ),
    );
  }

  @override
  void dispose() {
    _nomeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_carregando) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil do usuário',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 26, horizontal: 18),
            decoration: BoxDecoration(
              color: const Color(0xFFEAF2FF),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              children: [
                Stack(
                  children: [
                    GestureDetector(
                      onTap: _abrirFotoEmTelaCheia,
                      child: Hero(
                        tag: 'foto-perfil',
                        child: CircleAvatar(
                          radius: 72,
                          backgroundColor: const Color(0xFFD3E3FF),
                          backgroundImage: _imagemPerfil != null
                              ? FileImage(_imagemPerfil!)
                              : null,
                          child: _imagemPerfil == null
                              ? const Icon(Icons.person,
                                  size: 72, color: Color(0xFF4776B8))
                              : null,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: FloatingActionButton.small(
                        heroTag: 'botao-camera-perfil',
                        onPressed: _exibirOpcoesMidia,
                        child: const Icon(Icons.camera_alt),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text('Sua foto de perfil',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                const Text(
                  'Toque na câmera para escolher uma imagem.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.blueGrey),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Informações pessoais',
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _nomeController,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      labelText: 'Nome completo',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.badge_outlined),
                    ),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: _salvarNome,
                      icon: const Icon(Icons.save_outlined),
                      label: const Text('Salvar nome'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'A foto é armazenada no dispositivo e seu caminho é salvo com SharedPreferences para ser recuperado ao abrir o aplicativo novamente.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.blueGrey, fontSize: 12, height: 1.4),
          ),
        ],
      ),
    );
  }
}

class _FotoTelaCheia extends StatelessWidget {
  const _FotoTelaCheia({required this.imagem});

  final File imagem;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text('Foto de perfil'),
      ),
      body: Center(
        child: Hero(
          tag: 'foto-perfil',
          child: InteractiveViewer(
            minScale: 0.8,
            maxScale: 4,
            child: Image.file(imagem, fit: BoxFit.contain),
          ),
        ),
      ),
    );
  }
}
