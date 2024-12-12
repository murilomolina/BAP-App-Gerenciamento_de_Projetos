class Endereco {
  String rua;
  String numero;
  String bairro;
  String cidade;
  String cep;
  String observacoes;

  Endereco({
    required this.rua,
    required this.numero,
    required this.bairro,
    required this.cidade,
    required this.cep,
    required this.observacoes,
  });

  // Método para criar uma instância de Endereco a partir de um Map (JSON)
  factory Endereco.fromJson(Map<String, dynamic> json) {
    return Endereco(
      rua: json['rua'] ?? 'null',
      numero: json['numero'] ?? 'null',
      bairro: json['bairro'] ?? 'null',
      cidade: json['cidade'] ?? 'null',
      cep: json['cep'] ?? 'null',
      observacoes: json['observacoes'] ?? '',
    );
  }

  // Método para converter uma instância de Endereco para Map (JSON)
  Map<String, dynamic> toJson() {
    return {
      'rua': rua,
      'numero': numero,
      'bairro': bairro,
      'cidade': cidade,
      'cep': cep,
      'observacoes': observacoes,
    };
  }
}
