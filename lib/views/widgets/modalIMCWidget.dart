import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

void mostrarDetallesAlimento(BuildContext context, DocumentSnapshot doc) {
  Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

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
                data['tip'],
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
              const SizedBox(height: 10),
              Container(
                height: 250,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: NetworkImage(
                      data['url'],
                    ),
                    fit: BoxFit.cover
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(data['descripcion'], style: const TextStyle(fontSize: 15)),
              const SizedBox(height: 10),
            ],
          ),
        ),
      );
    },
  );
}
