import 'package:flutter/material.dart';
import 'geolocalizacao_screen.dart';
import 'perfil_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _indice = 0;

  final List<Widget> _telas = const [
    GeolocalizacaoScreen(),
    PerfilScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _telas[_indice]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _indice,
        onDestinationSelected: (index) => setState(() => _indice = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.my_location_outlined),
            selectedIcon: Icon(Icons.my_location),
            label: 'GPS',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
