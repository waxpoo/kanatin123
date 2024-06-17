import 'login.dart'; // Pastikan login.dart ada di direktori yang sama atau sesuai path

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _password = '';

  Future<void> _signup() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        final response = await http.post(
          Uri.parse('http://localhost/kantin/signup.php'), // Ubah ke 'http://10.0.2.2' untuk emulator Android
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
          },
          body: {
            'username': _username,
            'password': _password,
          },
        );
        
        // Mengolah respons dari server
        if (response.statusCode == 201) {
          // Periksa apakah respons berisi pesan 'Signup successful' untuk validasi tambahan
          if (response.body.contains('Signup successful')) {
            _showSuccessDialog('Registrasi berhasil. Silakan masuk.');
          } else if (response.body.contains('Username already taken')) {
            _showErrorDialog('Nama pengguna sudah digunakan.');
          } else {
            _showErrorDialog('Registrasi gagal. Coba lagi.');
          }
        } else {
          _showErrorDialog('Registrasi gagal. Kode status: ${response.statusCode}');
        }
      } catch (e) {
        _showErrorDialog('Terjadi kesalahan: $e');
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text("Error"),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text("OK"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text("Success"),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text("OK"),
            onPressed: () {
              Navigator.of(context).pop(); // Tutup dialog
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registrasi'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Username',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Masukkan nama pengguna';
                  }
                  return null;
                },
                onSaved: (value) => _username = value!,
              ),
              SizedBox(height: 20),
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                  filled: true,
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Masukkan password';
                  }
                  return null;
                },
                onSaved: (value) => _password = value!,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _signup,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 15.0),
                  child: Text('Daftar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
