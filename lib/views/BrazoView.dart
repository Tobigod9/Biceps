import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:produccion_integradora/views/widgets/EjercicioListWidget.dart';
import 'package:produccion_integradora/views/widgets/calendarioWidget.dart';
import 'package:produccion_integradora/views/widgets/modalDetallesWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BrazoView extends StatefulWidget {
  BrazoView({super.key});

  @override
  State<BrazoView> createState() => _BrazoViewState();
}

class _BrazoViewState extends State<BrazoView> {
  List<DocumentSnapshot> ejercicios = [];
  int dayOfWeek = DateTime.now().weekday;
  String nivelUsuario = '';
  String categoria = 'brazo';

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
                Image.asset('assets/img/brazoBackground.png'),
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
                      alignment: Alignment.centerRight,
                      child: Text(
                        'BRAZO     ',
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
