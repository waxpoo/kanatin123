import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'signup.dart'; // Pastikan file SignupPage diimpor dengan benar
import 'main.dart'; // Pastikan file HomePage diimpor dengan benar

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  File? _image; // Variabel untuk menyimpan gambar yang dipilih

  final ImagePicker _picker = ImagePicker();

  // Fungsi untuk memilih gambar dari galeri
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future<void> _loginUser() async {
    String username = usernameController.text;
    String password = passwordController.text;

    // Buat permintaan HTTP ke backend untuk memverifikasi login
    String url = 'http://10.0.2.2/kantin/login.php'; // Sesuaikan dengan URL login.php di server Anda
    try {
      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'username': username,
          'password': password,
        },
      );

      // Cek status response dari backend
      if (response.statusCode == 200) {
        // Decode response JSON
        var jsonResponse = json.decode(response.body);

        // Cek status dari response
        if (jsonResponse['status'] == 'success') {
          // Jika login berhasil, arahkan ke halaman beranda atau halaman lain
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        } else {
          // Jika login gagal, tampilkan pesan kesalahan
          _showDialog("Error", jsonResponse['message']);
        }
      } else {
        // Jika request gagal, tampilkan pesan error
        _showDialog("Error", "Terjadi kesalahan saat melakukan login. Kode status: ${response.statusCode}");
      }
    } catch (e) {
      // Tampilkan pesan kesalahan jika ada masalah dengan koneksi
      _showDialog("Error", "Terjadi kesalahan: $e");
    }
  }

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(title),
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

  @override
  Widget build(BuildContext context) {
    final String backgroundImageUrl =
        'https://images.pexels.com/photos/3585074/pexels-photo-3585074.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1';

    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(backgroundImageUrl),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 20),
                    Center(
                      child: _image != null
                          ? CircleAvatar(
                              radius: 60,
                              backgroundImage: FileImage(_image!),
                            )
                          : CircleAvatar(
                              radius: 60,
                              child: Icon(Icons.person, size: 60),
                            ),
                    ),
                    SizedBox(height: 10),
                    Center(
                      child: TextButton.icon(
                        icon: Icon(Icons.photo_camera),
                        label: Text("Pilih Foto"),
                        onPressed: _pickImage,
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: usernameController,
                      decoration: InputDecoration(
                        labelText: 'Username',
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: _loginUser,
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 15.0),
                        child: Text('Login'),
                      ),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        // Di sini Anda dapat menambahkan logika untuk pergi ke halaman pendaftaran
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignupPage()),
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 15.0),
                        child: Text('Daftar'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
