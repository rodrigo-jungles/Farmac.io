import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis_auth/auth_io.dart';
import 'package:get/get.dart';
import 'package:farmacio_app/controller/authController.dart';

class GoogleDriveService {
  static const String folderId = "11pm-nxE8SGd5zV-U_P95PGsK8QXG55AA"; // 🔹 Substitua pelo seu Folder ID real

  Future<drive.DriveApi> getDriveApi() async {
    try {
      print("🔹 Carregando credenciais do Google Cloud...");
      final credentials = await rootBundle.loadString('assets/google/google-cloud.json');

      final serviceAccount = ServiceAccountCredentials.fromJson(json.decode(credentials));

      final authClient = await clientViaServiceAccount(
        serviceAccount,
        [drive.DriveApi.driveFileScope],
      );

      print("✅ Conectado à API do Google Drive!");
      return drive.DriveApi(authClient);
    } catch (e) {
      print("❌ Erro ao autenticar com Google Drive: $e");
      rethrow;
    }
  }

  Future<String?> uploadImageToDrive(File imageFile) async {
    try {
      final driveApi = await getDriveApi();

      var media = drive.Media(imageFile.openRead(), imageFile.lengthSync());
      var driveFile = drive.File();

      // 🔹 Definindo nome do arquivo e pasta destino
      driveFile.name = imageFile.path.split('/').last;
      driveFile.parents = [folderId];

      print("📤 Iniciando upload da imagem para o Google Drive...");
      var response = await driveApi.files.create(driveFile, uploadMedia: media);

      if (response.id == null) {
        print("❌ Erro: Falha no upload, ID do arquivo não foi gerado.");
        return null;
      }

      print("✅ Upload concluído! ID do arquivo: ${response.id}");

      // 🔹 Criando permissão pública
      print("🔓 Aplicando permissão pública para o arquivo...");
      await driveApi.permissions.create(
      drive.Permission()
        ..type = "anyone"
        ..role = "reader",
      response.id!, // ID do arquivo do Google Drive (segundo argumento)
    );

      print("✅ Permissão pública aplicada com sucesso!");

      // 🔹 Criando a URL pública do arquivo
      String url = "https://drive.google.com/uc?export=view&id=${response.id}";
      print("🌍 URL pública gerada: $url");

      // 🔹 Pegando o usuário logado
      final authController = Get.find<AuthController>();
      final user = await authController.getUserFromSession();

      if (user == null || user.id == null) {
        print("❌ Erro: Usuário não encontrado ou não logado.");
        return null;
      }

      final int userId = user.id!;
      final novoAvatarUrl = url;

      // 🔹 Atualizar banco de dados e SharedPreferences com a nova URL do avatar
      print("🛠️ Atualizando avatar no banco de dados...");
      await authController.updateUserAvatarInDB(userId, novoAvatarUrl);
      print("✅ Avatar atualizado no banco!");

      return url;
    } catch (e) {
      print("❌ Erro ao enviar imagem para o Google Drive: $e");
      return null;
    }
  }
}
