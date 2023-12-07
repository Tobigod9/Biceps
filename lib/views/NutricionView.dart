import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:produccion_integradora/controllers/loginController.dart';
import 'package:produccion_integradora/views/widgets/modalConsejoWidget.dart';
import 'package:produccion_integradora/views/widgets/modalIMCWidget.dart';
import 'package:produccion_integradora/views/widgets/modalRecetaWidget.dart';

class NutricionView extends StatefulWidget {
  const NutricionView({super.key});

  @override
  State<NutricionView> createState() => _NutricionViewState();
}

class _NutricionViewState extends State<NutricionView> {
  List<DocumentSnapshot> consejo = [];
  int dayOfWeek = DateTime.now().weekday;
  String tituloConsejo = '';
  String imagenConsejo = '';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late Future<List<DocumentSnapshot>> _futureAlimentos;

  @override
  void initState() {
    super.initState();
    obtenerDatosConsejoNutricional();
    _futureAlimentos = _obtenerAlimentosRecomendados();
  }

  void obtenerDatosConsejoNutricional() async {
    var collection = FirebaseFirestore.instance
        .collection('login')
        .doc('gym1')
        .collection('nutricion');
    var querySnapshot =
        await collection.where('dia', isEqualTo: dayOfWeek).get();

    setState(() {
      consejo = querySnapshot.docs;
    });
  }

  Future<List<Receta>> obtenerRecetas() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('login')
        .doc('gym1')
        .collection('recetas_gym1')
        .get();
    return querySnapshot.docs
        .map((doc) => Receta.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<double> _obtenerIMCUsuario() async {
    return await LoginController().obtenerIMCActual();
  }

  Future<List<DocumentSnapshot>> _obtenerAlimentosRecomendados() async {
    double imcUsuario = await _obtenerIMCUsuario();
    QuerySnapshot querySnapshot = await _firestore
        .collection('login')
        .doc('gym1')
        .collection('tips_gym1')
        .get();

    return querySnapshot.docs.where((doc) {
      var data = doc.data() as Map<String, dynamic>;
      if (data['minImc'] == null || data['maxImc'] == null) {
        return false;
      }

      double minIMC = (data['minImc'] as num).toDouble();
      double maxIMC = (data['maxImc'] as num).toDouble();
      return imcUsuario >= minIMC && imcUsuario <= maxIMC;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF161d25),
        actions: <Widget>[
          // IconButton(
          //   icon: const Icon(
          //     Icons.camera,
          //     color: Colors.white,
          //   ),
          //   onPressed: () {},
          // ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 15),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Consejo nutricional del día',
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
            if (consejo.isNotEmpty)
              SizedBox(
                height: 170,
                child: ConsejoNutricionalWidget(
                  titulo: consejo.first['titulo'],
                  imagen: consejo.first['imagen'],
                  descripcion: consejo.first['descripcion'],
                ),
              ),
            const SizedBox(
              height: 15,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 15),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Recetas saludables',
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
              height: 150,
              child: FutureBuilder<List<Receta>>(
                future: obtenerRecetas(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                        child: Text(
                      'No hay recetas disponibles',
                      style: TextStyle(color: Colors.white),
                    ));
                  }

                  List<Receta> recetas = snapshot.data!;

                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: recetas.length,
                    itemBuilder: (context, index) {
                      return Row(
                        children: <Widget>[
                          if (index == 0)
                            const SizedBox(width: 15), // Espacio inicial
                          Container(
                            width: 200,
                            child: RecetasWidget(receta: recetas[index]),
                          ),
                          const SizedBox(width: 15), // Espacio entre tarjetas
                        ],
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 15),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Alimentos recomendados para ti',
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
              height: 150,
              child: FutureBuilder<List<DocumentSnapshot>>(
                future: _futureAlimentos,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(
                        child: Text('Error al cargar los alimentos'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                        child: Text(
                      'No hay alimentos recomendados para tu IMC',
                      style: TextStyle(color: Colors.white),
                    ));
                  } else {
                    List<DocumentSnapshot> alimentos = snapshot.data!;
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: alimentos.length,
                      itemBuilder: (context, index) {
                        List<DocumentSnapshot> alimentos = snapshot.data!;
                        return Row(
                          children: <Widget>[
                            if (index == 0) const SizedBox(width: 15),
                            Container(
                              width: 200,
                              child: RecomendadosWidget(doc: alimentos[index],
                              ),
                            ),
                            const SizedBox(width: 15),
                          ],
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ConsejoNutricionalWidget extends StatelessWidget {
  final String titulo;
  final String imagen;
  final String descripcion;

  ConsejoNutricionalWidget(
      {Key? key,
      required this.titulo,
      required this.imagen,
      required this.descripcion})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () => mostrarDetallesConsejo(context, this),
      child: Container(
        width: screenWidth - 30,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            image: NetworkImage(imagen),
            fit: BoxFit.cover,
          ),
        ),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Text(
            titulo,
            style: const TextStyle(
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

class RecetasWidget extends StatelessWidget {
  final Receta receta;

  const RecetasWidget({Key? key, required this.receta}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => mostrarDetallesReceta(context, receta),
      child: Container(
        width: 200,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            image: NetworkImage(receta.imagenPath),
            fit: BoxFit.cover,
          ),
        ),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Text(
            receta.titulo,
            style: const TextStyle(
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

class RecomendadosWidget extends StatelessWidget {
  final DocumentSnapshot doc;

  const RecomendadosWidget({
    Key? key,
    required this.doc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return GestureDetector(
      onTap: () => mostrarDetallesAlimento(context, doc),
      child: Container(
        width: 200,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            image: NetworkImage(data['url']),
            fit: BoxFit.cover,
          ),
        ),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Text(
            data['tip'],
            style: const TextStyle(
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

class Receta {
  final String titulo;
  final String imagenPath;
  final String descripcion;

  Receta(
      {required this.titulo,
      required this.imagenPath,
      required this.descripcion});

  factory Receta.fromMap(Map<String, dynamic> data) {
    return Receta(
      titulo: data['receta'] ?? '',
      imagenPath: data['url'] ?? '',
      descripcion: data['descripcion'] ?? '',
    );
  }
}
