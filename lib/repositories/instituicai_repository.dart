
import 'dart:convert';

import 'package:empresta/api.dart';
import 'package:empresta/models/instituicao_model.dart';
import 'package:http/http.dart' as http;


class InstituicaoRepository {
  final List<InstituicaoModel> _items = [];  
  bool _isLoading = false;


  List<InstituicaoModel> get items => List.from(_items);
  bool get isLoading => _isLoading;
  
  
  Future<void> getAll() async {
    if(_isLoading){
      return;
    }
    _isLoading = true;
    var requestURL = Uri.parse(Api.instituicao);
    final response = await http.get(
      requestURL,
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
      },

    );

    _isLoading = false;

    if(response.statusCode == 200) {
      List<dynamic> data = json.decode(utf8.decode(response.bodyBytes, allowMalformed: true));

      print(data);
      if(data.isNotEmpty){
        _items
        ..clear()
        ..addAll(data.map((item) => InstituicaoModel.fromMap(item)));
      }
      
    
    } else {
      throw Exception('Failed to load items. Status code: ${response.statusCode}');
    }


  }

}