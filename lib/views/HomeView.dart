import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:produccion_integradora/views/AbdomenView.dart';
import 'package:produccion_integradora/views/BrazoView.dart';
import 'package:produccion_integradora/views/DefineMusculoView.dart';
import 'package:produccion_integradora/views/GluteoView.dart';
import 'package:produccion_integradora/views/PerderPesoView.dart';
import 'package:produccion_integradora/views/PiernaView.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 40,
            ),
            SizedBox(
              height: 120,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  const SizedBox(
                    width: 15,
                  ),
                  AbdomenWidget(),
                  const SizedBox(
                    width: 30,
                  ),
                  BrazoWidget(),
                  const SizedBox(
                    width: 30,
                  ),
                  PiernaWidget(),
                  const SizedBox(
                    width: 30,
                  ),
                  GluteoWidget(),
                  const SizedBox(
                    width: 15,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 15),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Céntrate en el objetivo',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            SizedBox(
              height: 170,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  const SizedBox(
                    width: 15,
                  ),
                  PederPesoWidget(),
                  const SizedBox(
                    width: 20,
                  ),
                  AumentarMusculoWidget(),
                  const SizedBox(
                    width: 15,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 15),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Hoy',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Align(
                alignment: Alignment.centerLeft,
                child: FechaActualWidget(),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 250,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  const SizedBox(
                    width: 15,
                  ),
                  Pasos(),
                  const SizedBox(
                    width: 10,
                  ),
                  VasosDeAgua(),
                  const SizedBox(
                    width: 15,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AbdomenWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AbdomenView()),
        );
      },
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          CircleAvatar(
            radius: 40,
            backgroundImage: AssetImage('assets/img/abdomen.png'),
          ),
          SizedBox(height: 8),
          Text(
            'Abdomen',
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class BrazoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BrazoView()),
        );
      },
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          CircleAvatar(
            radius: 40,
            backgroundImage: AssetImage('assets/img/brazo.png'),
          ),
          SizedBox(height: 8),
          Text('Brazo', style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}

class PiernaWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PiernaView()),
        );
      },
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          CircleAvatar(
            radius: 40,
            backgroundImage: AssetImage('assets/img/pierna.png'),
          ),
          SizedBox(height: 8),
          Text('Pierna', style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}

class GluteoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => GluteoView()),
        );
      },
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          CircleAvatar(
            radius: 40,
            backgroundImage: AssetImage('assets/img/gluteo.png'),
          ),
          SizedBox(height: 8),
          Text('Gluteo', style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}

class PederPesoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PerderPesoView()),
        );
      },
      child: Container(
        width: 250,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: const DecorationImage(
            image: AssetImage('assets/img/perderpeso.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: const Align(
          alignment: Alignment.bottomLeft,
          child: Text(
            'PIERDE PESO',
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class AumentarMusculoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DefineMusculoView()),
        );
      },
      child: Container(
        width: 250,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: const DecorationImage(
            image: AssetImage('assets/img/definirmusculo.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: const Align(
          alignment: Alignment.bottomLeft,
          child: Text(
            'DEFINE MÚSCULOS',
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class FechaActualWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DateTime ahora = DateTime.now();

    String fechaFormateada = DateFormat('MMM dd, yyyy').format(ahora);

    return Text(
      fechaFormateada,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 10,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class Pasos extends StatelessWidget {
  final double progress;
  
  Pasos({this.progress = 0.7});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print("Pasos tocado");
      },
      child: Container(
        width: 175,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color(0xFF1f262e),
        ),
        child: Column(
          children: [
            const Row(
              children: [
                Icon(
                  Icons.directions_walk,
                  color: Color(0xFFcaee44),
                  size: 20,
                ),
                Text(
                  'Pasos',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 25,
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 100,
                  width: 100,
                  child: CircularProgressIndicator(
                    value: progress,
                    backgroundColor:
                        Color(0xFF282c35),
                    color: const Color(0xFFcaee44),
                    strokeWidth: 8,
                  ),
                ),
                const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.directions_walk,
                      color: Color(0xFFcaee44),
                      size: 30,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(width: 5),
                        Text(
                          '0',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '/2500',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class VasosDeAgua extends StatefulWidget {
  @override
  _VasosDeAguaState createState() => _VasosDeAguaState();
}

class _VasosDeAguaState extends State<VasosDeAgua> {
  int numeroDeVasos = 0;
  final int objetivoDeVasos = 8;

  @override
  Widget build(BuildContext context) {
    double porcentaje = numeroDeVasos / objetivoDeVasos;

    return Container(
      width: 175,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color(0xFF1f262e),
      ),
      child: Column(
        children: [
          const Row(
            children: [
              Icon(
                Icons.opacity,
                color: Color(0xFF45bdff),
                size: 20,
              ),
              SizedBox(width: 5),
              Text(
                'Vasos de agua',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 100,
                width: 100,
                child: CircularProgressIndicator(
                  value: porcentaje,
                  backgroundColor: Color(0xFF282c35),
                  color: const Color(0xFF45bdff),
                  strokeWidth: 8,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.opacity,
                    color: Color(0xFF45bdff),
                    size: 30,
                  ),
                  Text(
                    '$numeroDeVasos / $objetivoDeVasos',
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.remove, color: Colors.white),
                onPressed: () {
                  setState(() {
                    if (numeroDeVasos > 0) numeroDeVasos--;
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.add, color: Colors.white),
                onPressed: () {
                  setState(() {
                    if (numeroDeVasos < objetivoDeVasos) numeroDeVasos++;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
