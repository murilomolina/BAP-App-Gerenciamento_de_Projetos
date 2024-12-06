import 'package:bap_gerenciamento_projetos/data/usuarioAPP/operacoes_usuario.dart';

class AuthService {
  bool _isLoggedIn = false;

  // Simula o processo de login
  Future<bool> autenticaUsuario(String email, String senha) async {
    List<UsuarioApp> usuarios = await consultaUsuariosApp();

    for (final usuario in usuarios) {
      if (usuario.email == email && usuario.senha == senha) {
        _isLoggedIn = true;
        return true; // Retorna null se o login for bem sucedido
      }
    }
    return false; // Retorna uma mensagem de erro
  }

  Future<bool> verificaEmail(String email) async {
    List<UsuarioApp> usuarios = await consultaUsuariosApp();

    for (final usuario in usuarios) {
      if (usuario.email == email) {
        return true; // Retorna true se o email estiver cadastrado
      }
    }
    return false; // Retorna uma mensagem de erro
  }
  
  Future<Map<String, dynamic>?> getUserData(String email, String senha) async {
    List<UsuarioApp> usuarios = await consultaUsuariosApp();
    Map<String, dynamic>? userData;

    for (final usuario in usuarios) {
      if (usuario.email == email && usuario.senha == senha) {
        userData = {
          'nome': usuario.nome,
          'email': usuario.email,
          'link_foto': usuario.linkFoto,
          'telefone': usuario.telefone,
          'senha':usuario.senha
        };
        break;
      }
    }
    return userData;
  }

  // Simula o processo de recuperação de senha
  Future<String?> recoverPassword(String email) async {
    return await recuperaSenha(email); // Chama a função de recuperação de senha definida em operacoes_usuario.dart
  }

  // Método para deslogar o usuário
  Future<void> logout() async {
    _isLoggedIn = false; 
  }

  // Método para verificar se o usuário está logado
  bool get isLoggedIn => _isLoggedIn;
}