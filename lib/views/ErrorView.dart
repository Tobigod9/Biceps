import 'package:flutter/material.dart';

class ErrorView extends StatelessWidget {
  final String mensaje;
  final VoidCallback? accionReintentar;

  const ErrorView({Key? key, required this.mensaje, this.accionReintentar})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Text(
                mensaje,
                style: const TextStyle(
                    fontSize: 18, color: Colors.white, letterSpacing: 1.5, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            if (accionReintentar != null)
              ElevatedButton(
                onPressed: accionReintentar,
                child: const Text('Volver'),
              ),
          ],
        ),
      ),
    );
  }
}
