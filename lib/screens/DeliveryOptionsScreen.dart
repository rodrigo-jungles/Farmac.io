import 'package:flutter/material.dart';

class DeliveryOptionsScreen extends StatefulWidget {
  final Map<String, dynamic> product;

  const DeliveryOptionsScreen({Key? key, required this.product}) : super(key: key);

  @override
  _DeliveryOptionsScreenState createState() => _DeliveryOptionsScreenState();
}

class _DeliveryOptionsScreenState extends State<DeliveryOptionsScreen> {
  final _formKey = GlobalKey<FormState>();

  bool _isLocalPickup = false;
  bool _isDeliveryAvailable = false;

  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _additionalInfoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: const Text(
          'Configurar Entrega',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Escolha as opções de entrega:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              _buildOptionTile(
                title: 'Endereço Local',
                description: 'Informe onde o cliente deve buscar o produto.',
                value: _isLocalPickup,
                onChanged: (value) {
                  setState(() {
                    _isLocalPickup = value!;
                  });
                },
              ),
              if (_isLocalPickup) _buildAddressFields(),
              const SizedBox(height: 10),
              _buildOptionTile(
                title: 'Entrega pelo Vendedor',
                description: 'Você pode entregar o produto ao cliente.',
                value: _isDeliveryAvailable,
                onChanged: (value) {
                  setState(() {
                    _isDeliveryAvailable = value!;
                  });
                },
              ),
              const SizedBox(height: 30),
              _buildConfirmButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionTile({
    required String title,
    required String description,
    required bool value,
    required Function(bool?) onChanged,
  }) {
    return CheckboxListTile(
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(description),
      value: value,
      onChanged: onChanged,
      controlAffinity: ListTileControlAffinity.leading,
    );
  }

  Widget _buildAddressFields() {
    return Column(
      children: [
        const SizedBox(height: 10),
        _buildTextField(
          label: 'Endereço',
          controller: _addressController,
          hint: 'Informe o endereço de retirada',
          icon: Icons.location_on,
          validator: _validateRequiredField,
        ),
        _buildTextField(
          label: 'Informações Adicionais',
          controller: _additionalInfoController,
          hint: 'Ex: Horário de retirada ou pontos de referência',
          icon: Icons.info_outline,
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
    );
  }

  Widget _buildConfirmButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            if (_isLocalPickup && _addressController.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Informe o endereço para retirada!')),
              );
              return;
            }

            final deliveryOptions = {
              'isLocalPickup': _isLocalPickup,
              'localPickupAddress': _isLocalPickup ? _addressController.text : null,
              'additionalInfo': _isLocalPickup ? _additionalInfoController.text : null,
              'isDeliveryAvailable': _isDeliveryAvailable,
            };

            Navigator.pop(context, deliveryOptions);
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: const Text(
          'Confirmar',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }

  String? _validateRequiredField(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo é obrigatório';
    }
    return null;
  }
}
