import 'package:codetrade/providers/Login.dart';
import 'package:codetrade/screens/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      // debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MultiProvider(providers: [
        ChangeNotifierProvider(create: (context) => MainControll())
      ], child: HomeScreen()),
    );
  }
}
