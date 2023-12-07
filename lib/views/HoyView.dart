import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:produccion_integradora/views/widgets/EjercicioListWidget.dart';
import 'package:produccion_integradora/views/widgets/calendarioWidget.dart';
import 'package:produccion_integradora/views/widgets/modalDetallesWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HoyView extends StatefulWidget {
  HoyView({super.key});

  @override
  State<HoyView> createState() => _HoyViewState();
}

class _HoyViewState extends State<HoyView> {
  List<DocumentSnapshot> ejercicios = [];
  int dayOfWeek = DateTime.now().weekday;
  String nivelUsuario = '';

  @override
  void initState() {
    super.initState();
    obtenerNivelUsuarioYcargarEjercicios();
  }

  void obtenerNivelUsuarioYcargarEjercicios() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    nivelUsuario = prefs.getString('userLevel') ?? '';

    if (nivelUsuario.isNotEmpty) {
      var collection = FirebaseFirestore.instance
          .collection('login')
          .doc('gym1')
          .collection('ejer_gym1');
      var querySnapshot = await collection
          .where('nivel', isEqualTo: nivelUsuario)
          .where('dia', isEqualTo: dayOfWeek)
          .get();

      setState(() {
        ejercicios = querySnapshot.docs;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          if (nivelUsuario.isNotEmpty)
            Stack(
              children: <Widget>[
                Image.asset('assets/img/$nivelUsuario.png'),
                Positioned.fill(
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Color(0xFF161d25)],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          IgnorePointer(child: CustomCalendar(nivelUsuario: nivelUsuario)),
          ejercicios.isEmpty
              ? const CircularProgressIndicator()
              : EjercicioList(
                  ejercicios: ejercicios,
                  onEjercicioTap: mostrarDetallesEjercicio,
                ),
        ],
      ),
    );
  }
}
