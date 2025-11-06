import 'dart:math';
import 'package:flutter/material.dart';

const double _defaultLat = -23.55052;
const double _defaultLng = -46.633308;

class FarmaciasScreen extends StatefulWidget {
  const FarmaciasScreen({Key? key}) : super(key: key);

  @override
  State<FarmaciasScreen> createState() => _FarmaciasScreenState();
}

class _FarmaciasScreenState extends State<FarmaciasScreen> {
  // Lista de farmácias de exemplo
  final List<Map<String, dynamic>> _pharmacies = [
    {
      'name': 'Farmácia Central',
      'lat': -23.55052,
      'lng': -46.633308,
      'addr': 'Av. Central, 100',
    },
    {
      'name': 'Drogaria Vida',
      'lat': -23.55200,
      'lng': -46.64000,
      'addr': 'Rua A, 123',
    },
    {
      'name': 'Farmácia Saúde',
      'lat': -23.54500,
      'lng': -46.63000,
      'addr': 'Praça B, 45',
    },
  ];

  late List<Map<String, dynamic>> _sorted;

  @override
  void initState() {
    super.initState();
    // Ordena pela distância a partir do ponto padrão
    _sorted = List.from(_pharmacies);
    _sorted.sort((a, b) {
      final da = _haversine(_defaultLat, _defaultLng, a['lat'], a['lng']);
      final db = _haversine(_defaultLat, _defaultLng, b['lat'], b['lng']);
      return da.compareTo(db);
    });
  }

  double _haversine(double lat1, double lon1, double lat2, double lon2) {
    // retorna distância aproximada em metros
    const R = 6371000; // raio da Terra em metros
    final dLat = _deg2rad(lat2 - lat1);
    final dLon = _deg2rad(lon2 - lon1);
    final a =
        (sin(dLat / 2) * sin(dLat / 2)) +
        cos(_deg2rad(lat1)) *
            cos(_deg2rad(lat2)) *
            (sin(dLon / 2) * sin(dLon / 2));
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

  double _deg2rad(double deg) => deg * (pi / 180.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Farmácias')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            const Text(
              'Farmácia mais próxima destacada. (Baseada em localização padrão)',
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.separated(
                itemCount: _sorted.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final p = _sorted[index];
                  final dist = _haversine(
                    _defaultLat,
                    _defaultLng,
                    p['lat'],
                    p['lng'],
                  );
                  return ListTile(
                    leading: Icon(
                      Icons.local_pharmacy,
                      color: index == 0 ? Colors.red : Colors.blue,
                    ),
                    title: Text(p['name']),
                    subtitle: Text(p['addr'] ?? ''),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          index == 0
                              ? 'Mais próxima'
                              : '${(dist / 1000).toStringAsFixed(2)} km',
                        ),
                        if (index == 0) const SizedBox(height: 4),
                      ],
                    ),
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (_) => Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                p['name'],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(p['addr'] ?? ''),
                              const SizedBox(height: 8),
                              Text(
                                'Distância aproximada: ${(dist / 1000).toStringAsFixed(2)} km',
                              ),
                              const SizedBox(height: 12),
                              ElevatedButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Fechar'),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
