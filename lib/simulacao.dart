import 'dart:convert';

import 'package:empresta/api.dart';
import 'package:empresta/models/convenio_model.dart';
import 'package:empresta/models/instituicao_model.dart';
import 'package:empresta/models/simulacao_model.dart';
import 'package:empresta/models/simular_model.dart';
import 'package:empresta/repositories/convenio_repository.dart';
import 'package:empresta/repositories/instituicai_repository.dart';
import 'package:empresta/repositories/simular_repository.dart';
import 'package:empresta/widgets/custom_button.dart';
import 'package:empresta/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class SimulacaoPage extends StatefulWidget {
  const SimulacaoPage({super.key});

  @override
  State<SimulacaoPage> createState() => _SimulacaoPageState();
}

class _SimulacaoPageState extends State<SimulacaoPage> {
  
  InstituicaoRepository _instituicaoRepository = InstituicaoRepository();
  ConvenioRepository _convenioRepository = ConvenioRepository();
  
  SimularRepository _simularRepository = SimularRepository();

  TextEditingController textEditingControllerValor = TextEditingController();
  List<String> instituicoesSelecionadas = [];
  List<String> conveniosSelecionados = [];
  
  static List<String> _opcoesParcela = [
    "36",
    "48",
    "60",
    "72",
    "84",
  ];
  String? _selectedOption;
  bool _boolSimulando = false;
  
  

  Future<void> _loadData() async {
    await Future.wait([
      _instituicaoRepository.getAll(),
      _convenioRepository.getAll(),
    ]);
  }

  @override
  void initState() {
    super.initState();
    // Não precisa mais chamar getAllInstituicoes aqui, pois o FutureBuilder cuidará disso.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orangeAccent,
      body: SafeArea(
        child: FutureBuilder(
          future: _loadData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Erro ao carregar instituições'));
            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      child: const Text(
                        '',
                        style: TextStyle(color: Colors.white, fontSize: 35, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      child: const Text(
                        '',
                        style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 20, right: 20, bottom: 5),
                    child: Align(alignment: Alignment.centerLeft, child: Text('Valor do empréstimo')),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      bottom: 10,
                    ),
                    child: CustomTextField(
                      controller: textEditingControllerValor,
                      textStyle: const TextStyle(color: Colors.black),
                      hint: "R\$10.000",
                      obscureText: false,
                      keyboardType: TextInputType.number,
                      inputFormatter: [
                        FilteringTextInputFormatter.digitsOnly, // Permite apenas dígitos
                        CurrencyInputFormatter(),
                      ],
                      maxLength: 52,
                      prefixIcon: Icon(Icons.payments_outlined, color: Colors.black38),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 20, right: 20, bottom: 5),
                    child: Align(alignment: Alignment.centerLeft, child: Text('Instituição')),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      left: 5,
                      right: 20,
                      bottom: 10,
                    ),
                    child: InstituicaoWidget(
                      instituicaoRepository: _instituicaoRepository,
                      onSelectionChanged: (selectedValores) {
                        instituicoesSelecionadas = selectedValores;
                      },
                    ),
                  ),
                  
                  const Padding(
                    padding: EdgeInsets.only(left: 20, right: 20, bottom: 5),
                    child: Align(alignment: Alignment.centerLeft, child: Text('Convênio')),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 20, left: 5, right: 20),
                    child: ConvenioWidget(
                      convenioRepository: _convenioRepository,
                      onSelectionChanged: (selectedValores) {
                        conveniosSelecionados = selectedValores;
                      },
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 20, right: 20, bottom: 5),
                    child: Align(alignment: Alignment.centerLeft, child: Text('Parcelas')),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black45, width: 2), // Define a borda
                      borderRadius: BorderRadius.circular(5), // Define a borda arredondada
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4), // Adiciona padding interno
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedOption,
                        hint: Text('Selecione uma opção'),
                        items: _opcoesParcela.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                           _selectedOption = newValue;
                        },
                        // Estilo do dropdown
                        isExpanded: true,
                        underline: Container(
                          height: 2,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 20, right: 20),
                    child: CustomButton(onTap: () async {
                      await simular();

                    }, 
                      widgetChildButton: _simularRepository.isLoading ? CircularProgressIndicator() 
                      : Text(
                        'Simular',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade100,
                          fontSize: 18
                        ),
                      ),
                    ),

                  ),
                  
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Future simular() async {
    if (textEditingControllerValor.text.isEmpty) {
      return;
    }
    

    double valorEmprestimo = CurrencyInputFormatter().parse(textEditingControllerValor.text);
    final quantidadeParcelas = int.parse(_selectedOption ?? '0');

    SimularModel simularData = SimularModel(
      valorEmprestimo: valorEmprestimo,
      instituicoes: instituicoesSelecionadas,
      convenios: conveniosSelecionados,
      parcelas: quantidadeParcelas,
    );
    
    SimulacaoModel simulacao = await _simularRepository.simular(simularData);
    
    double total = simulacao.valorParcela * simulacao.quantidadeParcelas;
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _simulacaoAlertWidget(simulacao, total);
      },
    );
  }


  Widget _simulacaoAlertWidget(SimulacaoModel simulacao, double total) {
    return AlertDialog(
      backgroundColor: const Color.fromRGBO(0, 0, 0, 0.5),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.close, color: Colors.white,),
              ),
            ),
          ),
          Text(
            'Convênio: ${simulacao.convenio}',
            style: TextStyle(color: Colors.white),
          ),
          RichText(
            text: TextSpan(children: [
              TextSpan(
                text: 'Valor Parcela: ',
                style: TextStyle(fontSize: 16)
              ),
              TextSpan(
                text: 'R\$ ${simulacao.valorParcela.toString()}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
              ),
            ])
          ),
          RichText(
            text: TextSpan(children: [
              TextSpan(
                text: 'Quantidade de Parcelas: ',
                style: TextStyle(fontSize: 16)
              ),
              TextSpan(
                text: simulacao.quantidadeParcelas.toString(),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
              ),
            ])
          ),
          Text(
            'Taxa: ${simulacao.taxa}%',
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 10,),
          Row(
            children: [
              RichText(
                text: TextSpan(children: [
                  TextSpan(
                    text: simulacao.quantidadeParcelas.toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                  ),
                  const TextSpan(
                    text: ' Parcelas de ',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                  ),
                  TextSpan(
                    text: 'R\$ ${simulacao.valorParcela.toString()}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                  ),
                  
                ])
              ),
            ],
          ),
          const SizedBox(height: 10,),
          Text('Totalizando: R\$ ${total}', style: TextStyle(color:Colors.white, fontSize: 16, fontWeight: FontWeight.bold),),
          SizedBox(height:20),
          Container(
            margin: const EdgeInsets.only(left: 20, right: 20),
                    child: CustomButton(onTap: () async {
                     

                    }, 
                      widgetChildButton: Text(
                        'Contratar',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade100,
                          fontSize: 18
                        ),
                      ),
                      
                    ),

                  ),

        ],
      ),
      
    );
  }
}

class InstituicaoWidget extends StatefulWidget {
  final InstituicaoRepository instituicaoRepository;
  final Function(List<String>) onSelectionChanged; // Mude para List<String> para valores

  const InstituicaoWidget({
    Key? key,
    required this.instituicaoRepository,
    required this.onSelectionChanged,
  }) : super(key: key);

  @override
  _InstituicaoWidgetState createState() => _InstituicaoWidgetState();
}

class _InstituicaoWidgetState extends State<InstituicaoWidget> {
  late List<bool?> listBoolCheckedInstituicoes;
  late List<String> valoresSelecionados;

  @override
  void initState() {
    super.initState();
    listBoolCheckedInstituicoes = List<bool?>.filled(widget.instituicaoRepository.items.length, false);
    valoresSelecionados = [];
  }

  @override
  Widget build(BuildContext context) {
    if (widget.instituicaoRepository.items.isEmpty) {
      return Center(
        child: Text('Nenhuma instituição disponível.'),
      );
    }

    return Row(
      children: [
        for (var index = 0; index < widget.instituicaoRepository.items.length; index++)
          Row(
            children: [
              Checkbox(
                value: listBoolCheckedInstituicoes[index],
                onChanged: (val) {
                  setState(() {
                    listBoolCheckedInstituicoes[index] = val;
                    if (val == true) {
                      valoresSelecionados.add(widget.instituicaoRepository.items[index].valor);
                    } else {
                      valoresSelecionados.remove(widget.instituicaoRepository.items[index].valor);
                    }
                    widget.onSelectionChanged(valoresSelecionados);
                  });
                },
              ),
              Text(widget.instituicaoRepository.items[index].valor),
            ],
          ),
      ],
    );
  }
}

class ConvenioWidget extends StatefulWidget {
  final ConvenioRepository convenioRepository;
  final Function(List<String>) onSelectionChanged; // Mude para List<String> para valores

  const ConvenioWidget({
    Key? key,
    required this.convenioRepository,
    required this.onSelectionChanged,
  }) : super(key: key);

  @override
  _ConvenioWidgetState createState() => _ConvenioWidgetState();
}

class _ConvenioWidgetState extends State<ConvenioWidget> {
  late List<bool?> listBoolCheckedConvenio;
  late List<String> valoresSelecionados;

  @override
  void initState() {
    super.initState();
    listBoolCheckedConvenio = List<bool?>.filled(widget.convenioRepository.items.length, false);
    valoresSelecionados = [];
  }

  @override
  Widget build(BuildContext context) {
    if (widget.convenioRepository.items.isEmpty) {
      return Center(
        child: Text('Nenhum convênio disponível.'),
      );
    }

    return Row(
      children: [
        for (var index = 0; index < widget.convenioRepository.items.length; index++)
          Row(
            children: [
              Checkbox(
                value: listBoolCheckedConvenio[index],
                onChanged: (val) {
                  setState(() {
                    listBoolCheckedConvenio[index] = val;
                    if (val == true) {
                      valoresSelecionados.add(widget.convenioRepository.items[index].valor);
                    } else {
                      valoresSelecionados.remove(widget.convenioRepository.items[index].valor);
                    }
                    widget.onSelectionChanged(valoresSelecionados);
                  });
                },
              ),
              Text(widget.convenioRepository.items[index].valor),
            ],
          ),
      ],
    );
  }
}

class CurrencyInputFormatter extends TextInputFormatter {
  final NumberFormat _formatter = NumberFormat.currency(
    locale: 'pt_BR',
    symbol: '',
    decimalDigits: 2,
  );

  final NumberFormat _parser = NumberFormat.simpleCurrency(
    locale: 'pt_BR',
    decimalDigits: 2,
  );

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final newText = newValue.text.replaceAll(RegExp(r'[^\d]'), '');

    if (newText.isEmpty) {
      return newValue.copyWith(text: '');
    }

    final newDouble = double.parse(newText) / 100;

    final formattedText = _formatter.format(newDouble);

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }

  double parse(String value) {
    final cleanedValue = value.replaceAll(RegExp(r'[^\d]'), '');
    return double.parse(cleanedValue) / 100;
  }
}



