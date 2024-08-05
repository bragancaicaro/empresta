class SimularModel{

  double valorEmprestimo;
  List<String> instituicoes;
  List<String> convenios;
  int parcelas;

  SimularModel({
    required this.valorEmprestimo,
    required this.instituicoes,
    required this.convenios,
    required this.parcelas,
  });
  
  Map<String, dynamic> toMap() {
    return {
      'valor_emprestimo':valorEmprestimo,
      'instituicoes':instituicoes,
      'convenios':convenios,
      'parcelas':parcelas
    };
  }

  factory SimularModel.fromMap(Map<String, dynamic> map) {
    return SimularModel(
     valorEmprestimo:map['valor_emprestimo'],
      instituicoes:map['instituicoes'],
      convenios:map['convenios'],
      parcelas:map['parcelas']
    );
  }


}