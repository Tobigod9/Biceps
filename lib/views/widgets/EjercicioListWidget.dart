// ejercicio_list_view.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EjercicioList extends StatelessWidget {
  final List<DocumentSnapshot> ejercicios;
  final Function(BuildContext, Map<String, dynamic>) onEjercicioTap;

  const EjercicioList({
    Key? key,
    required this.ejercicios,
    required this.onEjercicioTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: ejercicios.length,
        itemBuilder: (context, index) {
          var ejercicio = ejercicios[index].data() as Map<String, dynamic>;
          String urlEjercicio = ejercicio['url'] ?? 'default';
          return ListTile(
            leading: ClipOval(
              child: Container(
                width: 40,
                height: 40,
                child: Image.network(
                  urlEjercicio,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            title: Text(
              ejercicio['nombre'] ?? 'Sin nombre',
              style: const TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              capitalize(ejercicio['categoria']),
              style: const TextStyle(color: Colors.grey),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 20,
              color: Colors.grey,
            ),
            onTap: () => onEjercicioTap(context, ejercicio),
          );
        },
      ),
    );
  }

  String capitalize(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1);
  }
}
