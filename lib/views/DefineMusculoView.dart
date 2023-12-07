import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:produccion_integradora/views/widgets/EjercicioListWidget.dart';
import 'package:produccion_integradora/views/widgets/calendarioWidget.dart';
import 'package:produccion_integradora/views/widgets/modalDetallesWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DefineMusculoView extends StatefulWidget {
  DefineMusculoView({super.key});

  @override
  State<DefineMusculoView> createState() => _DefineMusculoViewState();
}

class _DefineMusculoViewState extends State<DefineMusculoView> {
  List<DocumentSnapshot> ejercicios = [];
  int dayOfWeek = DateTime.now().weekday;
  String nivelUsuario = '';
  String categoria = 'define musculos';

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
          // .where('nivel', isEqualTo: nivelUsuario)
          .where('dia', isEqualTo: dayOfWeek)
          .where('categoria', isEqualTo: categoria)
          .get();

      setState(() {
        ejercicios = querySnapshot.docs;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF161d25),
        elevation: 0,
      ),
      body: Column(
        children: [
          if (nivelUsuario.isNotEmpty)
            Stack(
              children: <Widget>[
                Image.asset('assets/img/definemusculoBackground.png'),
                Positioned.fill(
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Color(0xFF161d25)],
                      ),
                    ),
                    child: const Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Define músculo  ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
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
