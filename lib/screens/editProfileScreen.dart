import 'package:farmacio_app/controller/userController.dart';
import 'package:farmacio_app/models/userModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late String _name, _lastname, _email, _password, _phoneNumber;
  UserModel? _user;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserFromSession();
  }

  Future<void> _loadUserFromSession() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId'); // 🔹 Corrigido para String

    if (userId != null) {
      try {
        // Buscar o usuário completo no banco de dados
        final user = await UserController.getUserById(userId);

        if (user != null) {
          setState(() {
            _user = user;
            _name = user.name;
            _lastname = user.lastname ?? '';
            _email = user.email;
            _password = ''; 
            _phoneNumber = user.number ?? '';
            _isLoading = false;
          });
        } else {
          Get.snackbar('Erro', 'Usuário não encontrado.', snackPosition: SnackPosition.BOTTOM);
          Get.offAllNamed('/login');
        }
      } catch (e) {
        Get.snackbar('Erro', 'Falha ao carregar usuário: $e', snackPosition: SnackPosition.BOTTOM);
        Get.offAllNamed('/login');
      }
    } else {
      Get.snackbar('Erro', 'Nenhum usuário logado encontrado.', snackPosition: SnackPosition.BOTTOM);
      Get.offAllNamed('/login');
    }
  }

  Future<void> _updateUser() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        _isLoading = true;
      });

      try {
        print("🔄 Tentando atualizar usuário...");
        print("🆔 ID: ${_user!.id}");
        print("📧 E-mail: ${_user!.email}");
        print("🔑 Senha: ${_password.isNotEmpty ? 'Alterada' : 'Não alterada'}");

        final success = await UserController.updateUser(
          UserModel(
            id: _user!.id,
            name: _name,
            email: _email,
            password: _password.isNotEmpty ? _password : _user!.password,
            number: _phoneNumber,
            lastname: _lastname,
            isGoogleUser: _user!.isGoogleUser,
            avatarUrl: _user!.avatarUrl,
          ),
        );

        print("🔎 Resultado da atualização: $success");

        if (success) {
          print("✅ Atualização bem-sucedida!");
          
          Get.snackbar(
            'Sucesso',
            'Perfil atualizado com sucesso!',
            snackPosition: SnackPosition.BOTTOM,
            duration: Duration(seconds: 2),
          );

          await Future.delayed(Duration(seconds: 2));

          Navigator.pushNamed(context, '/profile');
        } else {
          print("❌ Falha ao atualizar usuário!");
          Get.snackbar(
            'Erro',
            'Não foi possível atualizar o perfil.',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      } catch (e) {
        print("❌ Exceção ao atualizar usuário: $e");
        Get.snackbar(
          'Erro',
          'Ocorreu um erro: $e',
          snackPosition: SnackPosition.BOTTOM,
        );
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildTextField({
    required String label,
    required String initialValue,
    required IconData icon,
    required Function(String?) onSaved,
    String? Function(String?)? validator,
    bool obscureText = false,
    TextInputType inputType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        initialValue: initialValue,
        onSaved: onSaved,
        obscureText: obscureText,
        keyboardType: inputType,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow[700],
        title: const Text(
          'Editar Perfil',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildTextField(
                      label: 'Nome',
                      initialValue: _name,
                      icon: Icons.person,
                      onSaved: (value) => _name = value!,
                      validator: (value) => value == null || value.isEmpty ? 'Insira seu nome' : null,
                    ),
                    _buildTextField(
                      label: 'Sobrenome',
                      initialValue: _lastname,
                      icon: Icons.person_outline,
                      onSaved: (value) => _lastname = value!,
                      validator: (value) => value == null || value.isEmpty ? 'Insira seu sobrenome' : null,
                    ),
                    _buildTextField(
                      label: 'E-mail',
                      initialValue: _email,
                      icon: Icons.email,
                      inputType: TextInputType.emailAddress,
                      onSaved: (value) => _email = value!,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Insira seu e-mail';
                        } else if (!GetUtils.isEmail(value)) {
                          return 'E-mail inválido';
                        }
                        return null;
                      },
                    ),
                    _buildTextField(
                      label: 'Nova Senha',
                      initialValue: '',
                      icon: Icons.lock,
                      obscureText: true,
                      onSaved: (value) => _password = value!,
                      validator: (value) {
                        if (value != null && value.isNotEmpty && value.length < 6) {
                          return 'A senha deve ter pelo menos 6 caracteres';
                        }
                        return null;
                      },
                    ),
                    _buildTextField(
                      label: 'Telefone',
                      initialValue: _phoneNumber,
                      icon: Icons.phone,
                      inputType: TextInputType.phone,
                      onSaved: (value) => _phoneNumber = value!,
                      validator: (value) => value == null || value.isEmpty ? 'Insira seu telefone' : null,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: _isLoading ? null : _updateUser,
                      icon: const Icon(Icons.save, color: Colors.white),
                      label: const Text(
                        'Atualizar Perfil',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
