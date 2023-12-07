import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> login(String email, String password) async {
    try {
      // Hashing de la contraseña ingresada
      String hashedPassword = hashPassword(password);

      // Acceso a Firestore
      var userQuery = await _firestore
          .collection('login')
          .doc('gym1')
          .collection('usuarios_gym')
          .where('user', isEqualTo: email)
          .where('pass', isEqualTo: hashedPassword)
          .get();

      // Verificar si encontró el documento
      if (userQuery.docs.isNotEmpty) {
        var userDoc = userQuery.docs.first;
        String nivelUsuario = userDoc.data()['nivel'] as String;
        String status = userDoc.data()['status'] as String;

        if (status == '0') {
          return "status_timedout";
        }

        if (status != '1') {
          return "status_inactive";
        }

        if (!['principiante', 'intermedio', 'experto'].contains(nivelUsuario)) {
          return "invalid_level";
        }

        // Guardar información de la sesión si el nivel es válido
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isUserLoggedIn', true);
        await prefs.setString('userEmail', email);
        await prefs.setString('userLevel', nivelUsuario);

        return "success";
      } else {
        return "user_not_found";
      }
    } catch (error) {
      print("Error al buscar en Firestore: $error");
      return "error";
    }
  }

  Future<Map<String, dynamic>> getUserStatusFromDatabase(String email) async {
    try {
      var userQuery = await _firestore
          .collection('login')
          .doc('gym1')
          .collection('usuarios_gym')
          .where('user', isEqualTo: email)
          .get();

      if (userQuery.docs.isNotEmpty) {
        var userDoc = userQuery.docs.first;
        String status = userDoc.data()['status'] ?? '';
        String nivel = userDoc.data()['nivel'] ?? '';

        return {'status': status, 'nivel': nivel};
      } else {
        return {'error': 'user_not_found'};
      }
    } catch (error) {
      print("Error al buscar en Firestore: $error");
      return {'error': 'database_error'};
    }
  }

  Future<double> obtenerIMCActual() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userEmail = prefs.getString('userEmail');

    if (userEmail == null) {
      throw Exception('No hay un usuario logueado.');
    }

    var userQuery = await _firestore
        .collection('login')
        .doc('gym1')
        .collection('usuarios_gym')
        .where('user', isEqualTo: userEmail)
        .get();

    if (userQuery.docs.isEmpty) {
      throw Exception('Usuario no encontrado.');
    }

    var userData = userQuery.docs.first.data();
    if (!userData.containsKey('imc')) {
      throw Exception('El IMC del usuario no está disponible.');
    }

    var imcRaw = userData['imc'];
    if (imcRaw == null) {
      throw Exception('El IMC del usuario es nulo.');
    }

    return imcRaw is int ? imcRaw.toDouble() : imcRaw as double;
  }

  Future<bool> isUserLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isUserLoggedIn') ?? false;
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('isUserLoggedIn');
    await prefs.remove('userEmail');
    await prefs.remove('userLevel');
  }

  Future<String?> getUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userEmail');
  }

  Future<String?> getUserLevel() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userLevel');
  }

  Future<Map<String, dynamic>> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isUserLoggedIn') ?? false;
    String? userEmail = isLoggedIn ? prefs.getString('userEmail') : null;

    if (isLoggedIn && userEmail != null) {
      var data = await getUserStatusFromDatabase(userEmail);

      if (data.containsKey('error')) {
        return {'isLoggedIn': false, 'error': data['error']};
      }

      String status = data['status'] ?? '';
      String nivel = data['nivel'] ?? '';

      if (status == '0') {
        return {'isLoggedIn': false, 'error': 'status_timedout'};
      }

      if (status != '1') {
        return {'isLoggedIn': false, 'error': 'status_inactive'};
      }

      if (!['principiante', 'intermedio', 'experto'].contains(nivel)) {
        return {'isLoggedIn': false, 'error': 'invalid_level'};
      }

      return {
        'isLoggedIn': true,
        'userEmail': userEmail,
        'nivelUsuario': nivel
      };
    }

    return {'isLoggedIn': false};
  }

  Future<Map<String, dynamic>> getUserDataByEmail(String userEmail) async {
    try {
      var querySnapshot = await _firestore
          .collection('login')
          .doc('gym1')
          .collection('usuarios_gym')
          .where('user', isEqualTo: userEmail)
          .get();

      if (querySnapshot.docs.isEmpty) {
        return {'isLoggedIn': false, 'error': 'user_not_found'};
      }

      var userDoc = querySnapshot.docs.first;
      var userData = userDoc.data() as Map<String, dynamic>;

      return {
        'isLoggedIn': true,
        'userEmail': userEmail,
        'altura': userData['altura'] ?? '',
        'imc': userData['imc'] ?? '',
        'nivel': userData['nivel'] ?? '',
        'peso': userData['peso'] ?? '',
        'status': userData['status'] ?? '',
        'user': userData['user'] ?? '',
        'usergym': userData['usergym'] ?? '',
      };
    } catch (error) {
      print("Error al buscar en Firestore: $error");
      return {'error': 'database_error'};
    }
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
                'nombre': doc.data()['nombre'] ?? ''
              })
          .toList();
    } catch (error) {
      print("Error al buscar en Firestore: $error");
      return [
        {'error': 'database_error'}
      ];
    }
  }
}

String hashPassword(String password) {
  var bytes = utf8.encode(password);
  var digest = sha256.convert(bytes);
  return digest.toString();
}
