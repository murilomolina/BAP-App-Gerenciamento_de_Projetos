import 'dart:async';
import 'package:email_validator/email_validator.dart';

// mixin é quando voce quer incluir funções sem herança
mixin Validators{
  final validateEmail= StreamTransformer<String, String>.fromHandlers(
      handleData: (email, sink){
          // se o e-mail for válido (validar com o e-mail validator)
          // adicionar ele ao sink
          // caso contrário, adicionar uma mensagem de erro ao sink: E-mail inválido
          if (EmailValidator.validate(email)) {
            sink.add(email);
          }else{
              sink.addError('E-mail inválido');
          }
      }
  );

  final validateSenha= StreamTransformer<String, String>.fromHandlers(
      handleData: (senha, sink){
          if (senha.length >= 3) {
            sink.add(senha);
          }
          else{
              sink.addError('A senha deve ter pelo menos 3 caracteres');
          }
      }
  );

  final validateTelefone = StreamTransformer<String, String>.fromHandlers(
    handleData: (telefone, sink) {
      // Expressão regular para validar o formato
      final telefoneRegex = RegExp(r'^\d{2}\d{8,9}$');
      if (telefoneRegex.hasMatch(telefone)) {
        sink.add(telefone); // Telefone válido
      } else {
        sink.addError('Número de telefone inválido'); // Telefone inválido
      }
    },
  );

  final validateFormatoData = StreamTransformer<String, String>.fromHandlers(
    handleData:(entrada, sink) {
      final formData = RegExp(r'^(0[1-9]|[12][0-9]|3[01])/(0[1-9]|1[0-2])/\d{4}$');

      if (entrada.isNotEmpty && formData.hasMatch(entrada)) {
          sink.add(entrada);
      }else{
          sink.addError('Respeite o formato: dd/mm/aaaa');
      }
    },
  );

  final validateCampo = StreamTransformer<String, String>.fromHandlers(
      handleData: (texto, sink){
          if(texto.isEmpty || texto == ''){
              sink.addError('Campo obrigatório. Preencha esse campo!!');
          }else{
              sink.add(texto);
          }
      }
  );

  final validateCampoLinkFoto = StreamTransformer<String, String>.fromHandlers(
      handleData: (texto, sink){
          if(texto.isEmpty || texto == ''){
              sink.add('');
          }else{
              sink.add(texto);
          }
      }
  );

  final validateCampoNaoObrigatorio = StreamTransformer<String, String>.fromHandlers(
      handleData: (texto, sink){
          if(texto.isEmpty || texto == ''){
              sink.addError('Este campo pode estar vazio, porém recomenda-se que o preecha.');
          }else{
              sink.add(texto);
          }
      }
  );

    // Validação de RG (7 a 9 dígitos)
  final validateRG = StreamTransformer<String, String>.fromHandlers(
    handleData: (rg, sink) {
      // Remover traços e pontos
      final rgSemMascara = rg.replaceAll(RegExp(r'[^\d]'), '');
      
      final rgRegex = RegExp(r'^\d{7,9}$');
      if (rgRegex.hasMatch(rgSemMascara)) {
        sink.add(rg); // RG válido
      } else {
        sink.addError('RG inválido');
      }
    },
  );

  // Validação de CPF (11 dígitos)
  final validateCPF = StreamTransformer<String, String>.fromHandlers(
    handleData: (cpf, sink) {
      // Remover traços, pontos e hífens
      final cpfSemMascara = cpf.replaceAll(RegExp(r'[^\d]'), '');
      
      final cpfRegex = RegExp(r'^\d{11}$');
      if (cpfRegex.hasMatch(cpfSemMascara)) {
        sink.add(cpf); // CPF válido
      } else {
        sink.addError('CPF inválido');
      }
    },
  );
}