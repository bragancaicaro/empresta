import 'package:empresta/simulacao.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'salesysoff',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          pageTransitionsTheme: const PageTransitionsTheme(builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          }),
          primaryColor: Colors.blue,
          fontFamily: 'Noto',
          colorScheme: const ColorScheme.light(
            primary: Colors.orange,
            secondary: Colors.orangeAccent,
          ),
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          appBarTheme: const AppBarTheme(
            iconTheme: IconThemeData(color: Colors.white),
          ),
          useMaterial3: true,
        ),
        home: const SimulacaoPage(),
      );
}
}