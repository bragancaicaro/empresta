class InstituicaoModel{
  String chave;
  String valor;

  InstituicaoModel({
    required this.chave,
    required this.valor,
  });
  
  Map<String, dynamic> toMap() {
    return {
      'chave':chave,
      'valor':valor,
    };
  }

  factory InstituicaoModel.fromMap(Map<String, dynamic> map) {
    return InstituicaoModel(
      chave: map['chave'], 
      valor: map['valor'],
    );
  }
}