import 'dart:convert';
import 'package:empresta/models/simulacao_model.dart';
import 'package:http/http.dart' as http;
import 'package:empresta/api.dart';
import 'package:empresta/models/simular_model.dart';

class SimularRepository{
  
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<SimulacaoModel> simular(SimularModel simular) async {
    
    _isLoading = true;
    var url = Uri.parse(Api.simular);
    
    final encodedBody = jsonEncode(simular.toMap());
    
    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json; charset=utf-8', 
      },
      body: encodedBody
    );


    _isLoading = false;
    
    if (response.statusCode == 200) {

      final Map<String, dynamic> responseData = jsonDecode(response.body);

      final SimulacaoModel simulacao = SimulacaoModel.fromMap(responseData);

      return simulacao;
    } else {
      
      throw Exception('Falha na solicitação: ${response.statusCode}');
    }

  }

}