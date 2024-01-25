import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thawani_test/provider_payment.dart';
import 'package:thawani_test/webviw_payment.dart';

import 'home.dart';

void main() {
  runApp(

      MultiProvider(
          providers: [
      ChangeNotifierProvider<PaymentProvider>(
      create: (_) => PaymentProvider(),
  ),
          ],
          child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: Home(),
    );
  }
}


