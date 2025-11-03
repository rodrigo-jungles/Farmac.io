import 'dart:io';
import 'package:farmacio_app/controller/authController.dart';
import 'package:farmacio_app/service/googledriveService.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:farmacio_app/models/userModel.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  final UserModel user;

  const ProfileScreen({super.key, required this.user});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthController _authController = Get.put(AuthController());
  final GoogleDriveService _driveService = GoogleDriveService();
  late UserModel _user;
  File? _avatarImage;

  @override
  void initState() {
    super.initState();
    _user = widget.user;
    _loadAvatarFromPreferences(); // Carrega o avatar salvo
  }

  Future<void> _loadAvatarFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final avatarPath = prefs.getString('userAvatarPath');
    if (avatarPath != null) {
      setState(() {
        _avatarImage = File(avatarPath);
      });
    }
  }

  Future<void> _pickAvatar() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File newAvatar = File(pickedFile.path);
      setState(() {
        _avatarImage = newAvatar;
      });

      print("📤 Enviando nova foto para o Google Drive...");
      String? imageUrl = await _driveService.uploadImageToDrive(newAvatar);

      if (imageUrl != null) {
        print("✅ Foto salva no Google Drive: $imageUrl");

        // 🔄 Atualiza o banco e a UI
        await _authController.updateUserAvatarInDB(_user.id!, imageUrl);
        print("✅ Avatar atualizado no banco!");

        // 🔄 Atualiza o modelo de usuário e a interface
        setState(() {
          _user = _user.copyWith(avatarUrl: imageUrl);
        });
      } else {
        print("❌ Erro ao fazer upload da imagem.");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Perfil'),
        backgroundColor: Colors.yellow[700],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Center(
            child: Column(
              children: [
                GestureDetector(
                  onTap: _pickAvatar,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: _avatarImage != null
                        ? FileImage(_avatarImage!)
                        : (_user.avatarUrl != null && _user.avatarUrl!.isNotEmpty
                            ? NetworkImage(_user.avatarUrl!) as ImageProvider
                            : null),
                    child: _avatarImage == null &&
                            (_user.avatarUrl == null || _user.avatarUrl!.isEmpty)
                        ? const Icon(Icons.person, size: 50)
                        : null,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  _user.name,
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(height: 8),
                Text(
                  _user.email,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Dados pessoais'),
            onTap: () {
              Navigator.pushNamed(context, '/edit_profile');
            },
          ),
          ListTile(
            leading: const Icon(Icons.location_on),
            title: const Text('Endereços'),
            onTap: () async {
              UserModel? loggedUser = await _authController.getUserFromSession();
              if (loggedUser != null) {
                final userId = loggedUser.id;
                Navigator.pushNamed(context, '/enderecos', arguments: userId);
              } else {
                Navigator.pushNamed(context, '/login');
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip),
            title: const Text('Privacidade'),
            onTap: () {
              Navigator.pushNamed(context, '/privacidade');
            },
          ),
          const Divider(),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/edit_profile', arguments: _user);
            },
            child: const Text('Editar Perfil'),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () async {
              await _authController.logout();
              Navigator.pushNamedAndRemoveUntil(
                  context, '/login', (route) => false);
            },
            child: const Text('Sair da Conta'),
          ),
        ],
      ),
    );
  }
}
