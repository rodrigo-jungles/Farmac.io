import 'package:flutter/material.dart';



class AnaliseScreen extends StatefulWidget {
  const AnaliseScreen({super.key});

  @override
  State<AnaliseScreen> createState() => _AnaliseScreenState();
}

class _AnaliseScreenState extends State<AnaliseScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('Análise Sintomática')),
    body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              
            },
            child: Text('Dor na cabeça'),
          ),
          ElevatedButton(
            onPressed: () {
              
            },
            child: Text('Dor no peito'),
          ),
          ElevatedButton(
            onPressed: () {
              
            },
            child: Text('Dor nas costas'),
          ),
          ElevatedButton(
            onPressed: () {
              
            },
            child: Text('Dor nos braços ou pernas'),
          ),
        ]
    ));
      
  }
}
