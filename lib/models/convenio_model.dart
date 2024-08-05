class ConvenioModel{
  String chave;
  String valor;

  ConvenioModel({
    required this.chave,
    required this.valor,
  });
  
  Map<String, dynamic> toMap() {
    return {
      'chave':chave,
      'valor':valor,
    };
  }

  factory ConvenioModel.fromMap(Map<String, dynamic> map) {
    return ConvenioModel(
      chave: map['chave'], 
      valor: map['valor'],
    );
  }
}