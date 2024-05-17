import 'package:flutter/material.dart';
import 'main.dart'; // Pastikan untuk mengimpor file home_page.dart atau file halaman utama yang sesuai

class LoginPage extends StatelessWidget {
  // Buat kontroler untuk TextField
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                      'https://png.pngtree.com/png-clipart/20191121/original/pngtree-user-login-or-authenticate-icon-on-gray-background-flat-icon-ve-png-image_5089976.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: Text(
                  'Selamat Datang',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  TextField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Di sini Anda dapat menambahkan logika autentikasi
                      // Misalnya, Anda bisa menambahkan kondisi sederhana untuk memeriksa apakah username dan password benar.
                      // Jika benar, navigasikan ke halaman utama (HomePage).
                      String username = "admin";
                      String password = "admin";

                      String enteredUsername = usernameController.text;
                      String enteredPassword = passwordController.text;

                      if (enteredUsername == username && enteredPassword == password) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage()),
                        );
                      } else {
                        // Tambahkan pesan kesalahan jika login tidak berhasil
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Login gagal. Periksa kembali username dan password Anda."),
                          ),
                        );
                      }
                    },
                    child: Text('Login'),
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
