import 'package:flutter/material.dart';

void mostrarDetallesEjercicio(
    BuildContext context, Map<String, dynamic> ejercicio) {
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
      // String nombreEjercicio = ejercicio['nombre'] ?? 'default';
      return Container(
        height: 500,
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                ejercicio['nombre'] ?? 'No disponible',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
              const SizedBox(
                height: 5,
              ),
              Container(
                height: 250,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: NetworkImage(
                      ejercicio['url'],
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    "x ${ejercicio['repeticiones'] ?? 'No disponible'}",
                    style: const TextStyle(
                        fontSize: 40, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  Container(
                    height: 50,
                    width: 120,
                    decoration: BoxDecoration(
                        color: Color(0xFF161d25),
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: Text(
                        capitalize(ejercicio['categoria']),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                ejercicio['descripcion'] ?? 'No disponible',
                style: const TextStyle(fontSize: 15),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      );
    },
  );
}

String capitalize(String s) {
  if (s.isEmpty) return s;
  return s[0].toUpperCase() + s.substring(1);
}
