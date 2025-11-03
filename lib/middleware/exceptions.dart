class Exceptions implements Exception{
  final String message;
  const Exceptions([this.message = 'Uma excessão ocorreu.']);

  factory Exceptions.fromCode(String code){
    switch (code){
      case 'email-already-in-use':
        return const Exceptions("Email ja esta em uso.");
      case 'invalid-email':
        return const Exceptions("Email invalido.");
      case 'weak-password':
        return const Exceptions("Senha está muito fraca.");
      case 'user-disable':
        return const Exceptions("Usuario desativado.");
      case 'user-not-found':
        return const Exceptions("Usuario não encontrado na base de dados.");
      case 'wrong-password':
        return const Exceptions("Senha incorreta.");
      case 'too-many-requests':
        return const Exceptions("Muitas requisições, aguarde um momento.");
      case 'invalid-argument':
        return const Exceptions("Argumentos invalidos.");
      case 'invalid-password':
        return const Exceptions("Senha utilizada invalida.");
      case 'invalid-phone-number':
        return const Exceptions("Numero de telefone invalido.");
      case 'operation-not-allowed':
        return const Exceptions("Operação não permitida para o usuario.");
      case 'session-cookie-expired':
        return const Exceptions("Sessão expirada.");
      case 'uid-already-exists':
        return const Exceptions("Usuario ja cadastrado.");
      default:
        return const Exceptions();
    }
  }
}