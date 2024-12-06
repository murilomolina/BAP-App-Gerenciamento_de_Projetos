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
    final validateFuncaoUsuario = StreamTransformer<String, String>.fromHandlers(
        handleData: (funcao, sink){
            funcao = funcao.toLowerCase();
            if (funcao == 'user' || funcao == 'adm') {
              sink.add(funcao);
            }
            else{
                sink.addError('A função deve ser "USER" ou "ADM"');
            }
        }
    );

    final validateOcupacaoUsuario = StreamTransformer<String, String>.fromHandlers(
        handleData: (ocupacao, sink){
            if (ocupacao.isNotEmpty) {
                sink.add(ocupacao);
            }
            else{
                sink.addError('Esse campo deve ser preenchido!!');
            }
        }
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

    final validateCampoNaoObrigatorio = StreamTransformer<String, String>.fromHandlers(
        handleData: (texto, sink){
            if(texto.isEmpty || texto == ''){
                sink.addError('Este campo pode estar vazio, porém recomenda-se que o preecha.');
            }else{
                sink.add(texto);
            }
        }
    );
}