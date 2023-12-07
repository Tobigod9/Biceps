import 'package:flutter/material.dart';

class PoliticaPrivacidadView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF161d25),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: const Text(
          'Política de Privacidad',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Política de Privacidad',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 10),
            const Text(
              'Última actualización: 19 de Noviembre del 2023',
              style: TextStyle(fontSize: 16.0, fontStyle: FontStyle.italic, color: Colors.white),
            ),
            const SizedBox(height: 20),
            buildSectionText(
              'Bienvenido a Biceps. Nos comprometemos a proteger su privacidad. Esta Política de Privacidad explica cómo recopilamos, usamos, divulgamos y protegemos la información que recopilamos cuando utiliza nuestra aplicación.',
            ),
            const SizedBox(height: 20),
            buildSectionTitle('1. Información que recopilamos'),
            buildSectionText(
              'Podemos recopilar información personal y no personal sobre usted. Esto incluye, pero no se limita a, su nombre, dirección de correo electrónico, información de ubicación, dispositivo y datos de uso de la aplicación.',
            ),
            buildSectionTitle('2. Uso de la información'),
            buildSectionText(
              'La información recopilada se utiliza para mejorar la funcionalidad y el rendimiento de la aplicación, proporcionar soporte al cliente, comunicarnos con usted y cumplir con las leyes aplicables.',
            ),
            buildSectionTitle('3. Compartir información'),
            buildSectionText(
              'No compartimos su información personal con terceros, excepto según sea necesario para proporcionar nuestros servicios, como proveedores de servicios de nube o cuando lo requiera la ley.',
            ),
            buildSectionTitle('4. Seguridad'),
            buildSectionText(
              'Tomamos medidas razonables para proteger la información que recopilamos de accesos no autorizados, alteraciones, divulgaciones o destrucciones.',
            ),
            buildSectionTitle('5. Cambios en la Política de Privacidad'),
            buildSectionText(
              'Nos reservamos el derecho de modificar esta política en cualquier momento. Le notificaremos de cualquier cambio importante.',
            ),
            buildSectionTitle('6. Contacto'),
            buildSectionText(
              'Si tiene preguntas sobre esta política de privacidad, contáctenos en cloudsoft.com.mx.',
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        textAlign: TextAlign.justify,
        style: const TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: Colors.grey),
      ),
    );
  }

  Widget buildSectionText(String text) {
    return Text(
      text,
      textAlign: TextAlign.justify,
      style: const TextStyle(fontSize: 16.0, height: 1.5, color: Colors.white),
    );
  }
}
