import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 400,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: _image != null
                      ? FileImage(_image!) as ImageProvider
                      : NetworkImage(
                          'data:image/png;base64,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'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
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
                    onPressed: () {
                      // Di sini Anda dapat menambahkan logika autentikasi
                      String username = "admin";
                      String password = "admin";

                      String enteredUsername = usernameController.text;
                      String enteredPassword = passwordController.text;

                      if (enteredUsername == username &&
                          enteredPassword == password) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage()),
                        );
                      } else {
                        // Tambahkan pesan kesalahan jika login tidak berhasil
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                "Login gagal. Periksa kembali username dan password Anda."),
                          ),
                        );
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 15.0),
                      child: Text('Login'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
