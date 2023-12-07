import 'dart:async';

import 'package:flutter/material.dart';
import 'package:produccion_integradora/controllers/loginController.dart';
import 'package:produccion_integradora/views/NavigatorView.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginView extends StatefulWidget {
  LoginView({super.key});

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final LoginController _controller = LoginController();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _passwordVisible = false;
  bool isButtonEnabled = false;

  int _intentosFallidos = 0;
  bool get isLoginButtonEnabled => isButtonEnabled && _intentosFallidos < 3;
  Timer? _timer;

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'El correo no puede estar vacío';
    }
    if (!value.contains('@')) {
      return 'El correo debe contener un @';
    }
    if (!value.endsWith('.com')) {
      return 'El correo debe terminar con .com';
    }
    if (value.startsWith('.')) {
      return 'El correo no debe empezar con .';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'La contraseña no puede estar vacía';
    }
    return null;
  }

  Future<void> _launchURL(String url) async {
    final Uri _url = Uri.parse(url);
    if (!await launchUrl(_url)) {
      throw 'No se pudo abrir $url';
    }
  }

  void _iniciarSesion() async {
    if (!isLoginButtonEnabled) return;

    String result =
        await _controller.login(emailController.text, passwordController.text);
    if (result == "success") {
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => NavigatorView()));
    } else {
      // Incrementar el contador de intentos fallidos
      setState(() {
        _intentosFallidos++;
        if (_intentosFallidos >= 3) {
          _startTimer();
        }
      });

      String errorMessage;
      switch (result) {
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
          errorMessage = 'Usuario o contraseña incorrecta.';
          break;
        case "error":
          errorMessage = 'Error al conectarse a la base de datos.';
          break;
        default:
          errorMessage = 'Se produjo un error inesperado.';
      }

      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text(errorMessage),
            actions: <Widget>[
              TextButton(
                child: const Text("Cerrar"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  void _startTimer() {
    _timer?.cancel(); // Cancela cualquier temporizador existente
    _timer = Timer(Duration(minutes: 1), () {
      setState(() {
        _intentosFallidos = 0;
      });
    });
  }

  @override
  void dispose() {
    _timer
        ?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/img/backgroundLogin.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'INICIAR SESIÓN',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.yellow,
                ),
              ),
              const SizedBox(height: 30),
              TextFormField(
                controller: emailController,
                maxLength: 30,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.transparent,
                  hintText: 'USUARIO',
                  hintStyle: TextStyle(color: Colors.white),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  counterText: '',
                ),
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.emailAddress,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: validateEmail,
                onChanged: (value) {
                  setState(() {
                    isButtonEnabled =
                        validateEmail(emailController.text) == null &&
                            validatePassword(passwordController.text) == null;
                  });
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: passwordController,
                obscureText: !_passwordVisible,
                maxLength: 30,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.transparent,
                  hintText: 'CONTRASEÑA',
                  hintStyle: const TextStyle(color: Colors.white),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  border: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  counterText: '',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                  ),
                ),
                style: const TextStyle(color: Colors.white),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: validatePassword,
                onChanged: (value) {
                  setState(() {
                    isButtonEnabled =
                        validateEmail(emailController.text) == null &&
                            validatePassword(passwordController.text) == null;
                  });
                },
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: isLoginButtonEnabled ? _iniciarSesion : null,
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    onPrimary: Colors.black,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 100, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text('Iniciar sesión'),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: TextButton(
                  onPressed: () =>
                      _launchURL('https://biceps.cloudsoft.mx/recoverpass'),
                  style: TextButton.styleFrom(
                    primary: Colors.blue,
                  ),
                  child: const Text('Recuperar contraseña'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
