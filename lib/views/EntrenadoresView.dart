import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EntrenadoresView extends StatefulWidget {
  const EntrenadoresView({super.key});

  @override
  State<EntrenadoresView> createState() => _EntrenadoresViewState();
}

Future<List<Map<String, dynamic>>> getTrainersData() async {
  try {
    var collectionRef = FirebaseFirestore.instance
        .collection('login')
        .doc('gym1')
        .collection('entrenadores');

    var querySnapshot = await collectionRef.get();

    return querySnapshot.docs
        .map((doc) => {
              'descripcion': doc.data()['descripcion'] ?? '',
              'imagen': doc.data()['imagen'] ?? '',
              'numero': doc.data()['numero'] ?? 0,
              'nombre': doc.data()['nombre'] ?? '',
              'especialidad':
                  List<String>.from(doc.data()['especialidad'] ?? [])
            })
        .toList();
  } catch (error) {
    print("Error al buscar en Firestore: $error");
    return [
      {'error': 'database_error'}
    ];
  }
}

class _EntrenadoresViewState extends State<EntrenadoresView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: SizedBox(
        height: 500,
        child: FutureBuilder(
          future: getTrainersData(),
          builder: (BuildContext context,
              AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: snapshot.data?.length ?? 0,
                itemBuilder: (context, index) {
                  var trainerData = snapshot.data![index];
                  return Row(
                    children: [
                      const SizedBox(width: 15),
                      CardCouchWidget(
                        descripcion: trainerData['descripcion'],
                        imagen: trainerData['imagen'],
                        numero: trainerData['numero'],
                        nombre: trainerData['nombre'],
                        especialidades: trainerData['especialidad'],
                      ),
                      const SizedBox(width: 15),
                    ],
                  );
                },
              );
            }
          },
        ),
      )),
    );
  }
}

class CardCouchWidget extends StatelessWidget {
  final String phoneNumber = "+529191359014";

  final String descripcion;
  final String imagen;
  final String numero;
  final String nombre;

  final List<String> especialidades;

  const CardCouchWidget({
    Key? key,
    required this.descripcion,
    required this.imagen,
    required this.numero,
    required this.nombre,
    required this.especialidades,
  }) : super(key: key);

  Future<void> _launchWhatsApp(String numero) async {
    // Formatea el número de teléfono
    var whatsappUrl = "https://wa.me/$numero";
    final Uri _url = Uri.parse(whatsappUrl);
    if (!await launchUrl(_url)) {
      throw 'No se pudo abrir WhatsApp para el número $numero';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 290,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color(0xFF1f262e),
      ),
      child: Center(
          child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(imagen),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              nombre,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
            const SizedBox(
              height: 15,
            ),
            SizedBox(
              height:
                  35,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: especialidades.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Container(
                      width: 100,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 48, 59, 73),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          especialidades[index],
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            SizedBox(
              height: 170,
              child: Text(
                descripcion,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15),
              ),
            ),
            ElevatedButton(
              onPressed: () => _launchWhatsApp('$numero'),
              style: TextButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 48, 59, 73)),
              child: const Text(
                'Contactar',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
