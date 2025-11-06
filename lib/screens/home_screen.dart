import 'package:farmacio_app/screens/analise_screen.dart';
import 'package:farmacio_app/screens/catalogo_screen.dart';
import 'package:farmacio_app/screens/farmacias_simple_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AnaliseScreen()),
              );
            },
            child: Text('Análise Sintomática'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CatalogoScreen()),
              );
            },
            child: Text('Catalogo de remédios'), //ElevatedButton
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FarmaciasScreen()),
              );
            },
            child: Text('Farmácias Próximas'),
          ),
        ],
      ),
    );
  }
}
