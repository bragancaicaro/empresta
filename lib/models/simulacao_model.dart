class SimulacaoModel{

  String convenio;
  double valorParcela;
  int quantidadeParcelas;
  double taxa;


  SimulacaoModel({
    required this.convenio,
    required this.valorParcela,
    required this.quantidadeParcelas,
    required this.taxa,
  });

  Map<String, dynamic> toMap() {
    return {
      'convenio':convenio,
      'valor_parcela':valorParcela,
      'parcelas':quantidadeParcelas,
      'taxa':taxa
    };
  }

  factory SimulacaoModel.fromMap(Map<String, dynamic> map) {
    return SimulacaoModel(
     convenio:map['convenio'],
      valorParcela:map['valor_parcela'],
      quantidadeParcelas:map['parcelas'],
      taxa:map['taxa']
    );
  }
}