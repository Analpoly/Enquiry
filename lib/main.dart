import 'package:enquiry/brandd.dart';
import 'package:enquiry/dropdown_provider.dart';
import 'package:enquiry/dropdown_screen.dart';
import 'package:enquiry/login_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';



void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => DropdownProvider()),
      ],
      child: MaterialApp(
       debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => LoginScreen(),
          '/dropdown': (context) => DropdownScreen(),
        },
      ),
    );
  }
}

