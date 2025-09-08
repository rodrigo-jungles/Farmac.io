import 'package:flutter/material.dart';

class FarmaciasScreen extends StatefulWidget {
  const FarmaciasScreen({super.key});

  @override
  State<FarmaciasScreen> createState() => _FarmaciasScreenState();
}

class _FarmaciasScreenState extends State<FarmaciasScreen> {
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('Farmácias')));
  }
}
