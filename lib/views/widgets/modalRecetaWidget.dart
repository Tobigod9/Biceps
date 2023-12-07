import 'package:flutter/material.dart';
import 'package:produccion_integradora/views/NutricionView.dart';

void mostrarDetallesReceta(BuildContext context, Receta receta) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
    ),
    builder: (BuildContext context) {
      return Container(
        height: 500,
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                receta.titulo,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
              const SizedBox(height: 10),
              Container(
                height: 250,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                      image: NetworkImage(receta.imagenPath),
                      fit: BoxFit.cover),
                ),
              ),
              const SizedBox(height: 10),
              const Text('Preparación',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20)),
              const SizedBox(height: 10),
              Text(receta.descripcion, style: const TextStyle(fontSize: 15)),
              const SizedBox(height: 10),
            ],
          ),
        ),
      );
    },
  );
}
