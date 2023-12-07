import 'package:flutter/material.dart';
import 'package:produccion_integradora/views/EntrenadoresView.dart';
import 'package:produccion_integradora/views/HomeView.dart';
import 'package:produccion_integradora/views/HoyView.dart';
import 'package:produccion_integradora/views/NutricionView.dart';
import 'package:produccion_integradora/views/PerfilView.dart';
import 'package:produccion_integradora/views/QrTrainerView.dart';

class NavigatorView extends StatefulWidget {
  const NavigatorView({super.key});

  @override
  _NavigatorViewState createState() => _NavigatorViewState();
}

class _NavigatorViewState extends State<NavigatorView> {
  int _selectedIndex = 0;

  List<Widget> get _pages => [
        HomeView(),
        HoyView(),
        NutricionView(),
        EntrenadoresView(),
        QrTrainerView(),
        PerfilView(),
      ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Color(0xFF171d2b),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Hoy',
            backgroundColor: Color(0xFF171d2b),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant),
            label: 'Nutrición',
            backgroundColor: Color(0xFF171d2b),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Entrenadores',
            backgroundColor: Color(0xFF171d2b),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code),
            label: 'QR Trainer',
            backgroundColor: Color(0xFF171d2b),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
            backgroundColor: Color(0xFF171d2b),
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Color(0xFF00b668),
        unselectedItemColor: Color(0xFF868F9E),
      ),
    );
  }
}
