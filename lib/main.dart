import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:badges/badges.dart' as badges;
import 'package:kanatin/models/menu_model.dart';
import 'package:http/http.dart' as myHttp;
import 'package:kanatin/provider/cart_provider.dart';
import 'package:provider/provider.dart';
import "login.dart";

// Splash Screen
class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    });

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTQNVfxGU7aWNm9BUSUyLk-sBgmG4EhxXo6Vg&s', // Ganti dengan logo Anda
              height: 100,
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => CartProvider())],
      child: MaterialApp(
        theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
        home: SplashScreen(), // Mengubah home menjadi SplashScreen
      ),
    );
  }

  void toggleDarkMode() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }
}

class LoginPage extends StatelessWidget {
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
              height: 300,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQUEKCFnHm9tKZ2kzgESH-iDGkLWhmVsYSFAw&s'),
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
                      String username = "admin";
                      String password = "admin";

                      String enteredUsername = usernameController.text;
                      String enteredPassword = passwordController.text;

                      if (enteredUsername == username &&
                          enteredPassword == password) {
                        Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation1, animation2) =>
                                HomePage(),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              return FadeTransition(
                                opacity: animation,
                                child: child,
                              );
                            },
                            transitionDuration: Duration(milliseconds: 500),
                          ),
                        );
                      } else {
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

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController namaController = TextEditingController();
  TextEditingController nomormejaController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  final String urlMenu =
      "https://script.google.com/macros/s/AKfycbxolBPsgcyDRa7OyWJZtP3GBZzmjA0VIf12sDAbZ30QVAhlLcGvMzFRYC1sljXmCuO_/exec";
  List<MenuModel> listMenu = [];
  List<MenuModel> filteredMenu = [];

  Future<void> getAllData() async {
    var response = await myHttp.get(Uri.parse(urlMenu));
    List data = json.decode(response.body);

    setState(() {
      listMenu = data.map((element) => MenuModel.fromJson(element)).toList();
      filteredMenu = listMenu;
    });
  }

  @override
  void initState() {
    super.initState();
    getAllData();
  }

  void filterSearchResults(String query) {
    setState(() {
      filteredMenu = listMenu
          .where(
              (item) => item.name.toLowerCase().startsWith(query.toLowerCase()))
          .toList();
    });
  }

 void openDialog(BuildContext context, TextEditingController namaController, TextEditingController nomormejaController) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder( // Gunakan StatefulBuilder untuk mengatur state di dalam dialog
        builder: (context, setState) {
          return AlertDialog(
            content: Container(
              height: 280,
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Text(
                    "Nama",
                    style: GoogleFonts.montserrat(),
                  ),
                  TextFormField(
                    controller: namaController,
                    decoration: InputDecoration(border: OutlineInputBorder()),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Nomor Meja",
                    style: GoogleFonts.montserrat(),
                  ),
                  TextFormField(
                    controller: nomormejaController,
                    decoration: InputDecoration(border: OutlineInputBorder()),
                  ),
                  SizedBox(height: 20),
                  Consumer<CartProvider>(
                    builder: (context, value, _) {
                      String strpesanan = "";
                      value.cart.forEach((element) {
                        strpesanan += "\n" +
                            element.name +
                            " (" +
                            element.quantity.toString() +
                            ")";
                      });
                      return ElevatedButton(
                        onPressed: () {
                          if (namaController.text.isNotEmpty &&
                              nomormejaController.text.isNotEmpty) {
                            String pesanan = "Nama : " +
                                namaController.text +
                                "\nNomor Meja : " +
                                nomormejaController.text +
                                "\nPesanan : " +
                                "\n" +
                                strpesanan;

                            print(pesanan);
                            // Tidak perlu clear controller di sini
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Pesanan anda telah diterima."),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text("Mohon lengkapi Nama dan Nomor Meja."),
                              ),
                            );
                          }
                        },
                        child: Text("Pesan"),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}


  @override
  Widget build(BuildContext context) {
    _MyAppState? parentState = context.findAncestorStateOfType<_MyAppState>();

    return Scaffold(
      appBar: AppBar(
        title: Text('kantin wikrama'),
        actions: [
          IconButton(
            icon: Icon(parentState?.isDarkMode == true
                ? Icons.brightness_7
                : Icons.brightness_4),
            onPressed: () {
              parentState?.toggleDarkMode();
            },
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              _logout(context);
            },
          ),
        ],
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          openDialog(context, namaController, nomormejaController);
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: badges.Badge(
          badgeContent: Consumer<CartProvider>(builder: (context, value, _) {
            return Text(
              (value.total > 0) ? value.total.toString() : "",
              style: GoogleFonts.montserrat(color: Colors.white),
            );
          }),
          child: Icon(Icons.shopping_bag, color: Colors.white),
          badgeStyle: badges.BadgeStyle(
            badgeColor: Colors.redAccent,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: searchController,
                onChanged: (value) {
                  filterSearchResults(value);
                },
                decoration: InputDecoration(
                  labelText: "Cari",
                  hintText: "Cari Menu",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  ),
                ),
              ),
            ),
            Expanded(
              child: (filteredMenu.isNotEmpty)
                  ? ListView.builder(
                      itemCount: filteredMenu.length,
                      itemBuilder: (context, index) {
                        MenuModel menu = filteredMenu[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.4),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(menu.image),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 16, right: 16, bottom: 16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          menu.name,
                                          style: GoogleFonts.montserrat(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary),
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          menu.discription,
                                          textAlign: TextAlign.left,
                                          style: GoogleFonts.montserrat(
                                              fontSize: 13,
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .bodyText2
                                                  ?.color),
                                        ),
                                        SizedBox(height: 12),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Rp. " + menu.price.toString(),
                                              style: GoogleFonts.montserrat(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary),
                                            ),
                                            Row(
                                              children: [
                                                IconButton(
                                                  onPressed: () {
                                                    Provider.of<CartProvider>(
                                                            context,
                                                            listen: false)
                                                        .addRemove(menu.name,
                                                            menu.id, false);
                                                  },
                                                  icon: Icon(
                                                    Icons.remove_circle,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                                SizedBox(width: 10),
                                                Consumer<CartProvider>(builder:
                                                    (context, value, _) {
                                                  var id = value.cart
                                                      .indexWhere((element) =>
                                                          element.menuId ==
                                                          filteredMenu[index]
                                                              .id);

                                                  return Text(
                                                    (id == -1)
                                                        ? "0"
                                                        : value
                                                            .cart[id].quantity
                                                            .toString(),
                                                    textAlign: TextAlign.left,
                                                    style:
                                                        GoogleFonts.montserrat(
                                                            fontSize: 15),
                                                  );
                                                }),
                                                IconButton(
                                                  onPressed: () {
                                                    Provider.of<CartProvider>(
                                                            context,
                                                            listen: false)
                                                        .addRemove(menu.name,
                                                            menu.id, true);
                                                  },
                                                  icon: Icon(
                                                    Icons.add_circle,
                                                    color: Colors.green,
                                                  ),
                                                ),
                                                SizedBox(width: 10),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      })
                  : Center(
                      child: Text(
                        "SABAR BRO LOADING",
                        style: GoogleFonts.montserrat(
                            color: Theme.of(context).colorScheme.primary),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _logout(BuildContext context) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => LoginPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration: Duration(milliseconds: 500),
      ),
    );
  }
}
