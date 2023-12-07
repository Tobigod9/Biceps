import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:produccion_integradora/controllers/loginController.dart';
import 'package:produccion_integradora/views/ErrorView.dart';
import 'package:produccion_integradora/views/LoginView.dart';
import 'package:produccion_integradora/views/NavigatorView.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final LoginController _loginController = LoginController();

  MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Biceps',
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFF161d25),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true,
      ),
      home: FutureBuilder<Map<String, dynamic>>(
        future: LoginController().getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data != null && snapshot.data!['isLoggedIn']) {
              return NavigatorView();
            } else if (snapshot.data != null &&
                snapshot.data!.containsKey('error')) {
              String errorMessage = 'Por favor, inicie sesión.';
              if (snapshot.data != null &&
                  snapshot.data!.containsKey('error')) {
                switch (snapshot.data!['error']) {
                  case "status_timedout":
                    errorMessage = 'Su membresía ha caducado.';
                    break;
                  case "status_inactive":
                    errorMessage = 'Error: Su cuenta no está activa.';
                    break;
                  case "invalid_level":
                    errorMessage =
                        'Error: El nivel de usuario no está configurado o no es válido.';
                    break;
                  case "user_not_found":
                    errorMessage = 'Error: Se ha modificado el usuario.';
                    break;
                  default:
                    errorMessage = 'Se produjo un error inesperado.';
                }
              }
              return ErrorView(
                mensaje: errorMessage,
                accionReintentar: () {
                  _cerrarSesion(context);
                },
              );
            } else {
              return LoginView();
            }
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }

  Future<void> _cerrarSesion(BuildContext context) async {
    await _loginController.logout();

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => LoginView()),
      (Route<dynamic> route) => false,
    );
  }
}
