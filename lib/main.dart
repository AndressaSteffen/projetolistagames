import 'package:flutter/material.dart';
import 'package:listagames/view/home_page.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Minha Listinha de Joguinhos',
      theme: ThemeData(
        primaryColor: Colors.purple[800], // Cor principal do aplicativo
        scaffoldBackgroundColor: Colors.purple[600], // Cor de fundo do Scaffold
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.purple[400], // Cor de fundo da AppBar
        ),
        // Outras personalizações de cores conforme necessário
      ),
      home: HomePage(),
    );
  }
}
