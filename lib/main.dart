import 'package:flutter/material.dart';
import 'package:teamfinalproject/screens/menu.dart';
void main(){
  runApp(
      MyApp(),
  );
}
class MyApp extends StatelessWidget{

  Widget build(BuildContext context){
    return MaterialApp(
      theme: ThemeData(scaffoldBackgroundColor: Colors.white),
      debugShowCheckedModeBanner: false,
      title: '배달',
      home: MenuPage(),
    );
  }
}