
import 'dart:convert';

import 'package:empresta/api.dart';
import 'package:empresta/models/convenio_model.dart';
import 'package:http/http.dart' as http;


class ConvenioRepository {
  final List<ConvenioModel> _items = [];  
  bool _isLoading = false;


  List<ConvenioModel> get items => List.from(_items);
  bool get isLoading => _isLoading;
  
  
  Future<void> getAll() async {
    if(_isLoading){
      return;
    }
    _isLoading = true;
    var requestURL = Uri.parse(Api.convenio);
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
        ..addAll(data.map((item) => ConvenioModel.fromMap(item)));
      }
      
    
    } else {
      throw Exception('Failed to load items. Status code: ${response.statusCode}');
    }


  }

}