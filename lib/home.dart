import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thawani_test/provider_payment.dart';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

      ),
      body: Column(

        children: [
          Center(
            child: ElevatedButton(onPressed: (){
              Provider.of<PaymentProvider>(context,listen: false).createCustomer(context);
            }, child: Text("Create customer")),
          ),
          Center(
            child: ElevatedButton(onPressed: (){
              Provider.of<PaymentProvider>(context,listen: false).createSession(context);
            }, child: Text("Create session")),
          ),
          Center(
            child: ElevatedButton(onPressed: (){
              Provider.of<PaymentProvider>(context,listen: false).retrieveSession(context);
            }, child: Text("retrieve session")),
          ),
          Center(
            child: ElevatedButton(onPressed: (){
              Provider.of<PaymentProvider>(context,listen: false).saveCard(context);
            }, child: Text("save card")),
          ),
          Center(
            child: ElevatedButton(onPressed: (){
              Provider.of<PaymentProvider>(context,listen: false).createPaymentIntent(context);
            }, child: Text("create payment intent")),
          ),
          Center(
            child: ElevatedButton(onPressed: (){
              Provider.of<PaymentProvider>(context,listen: false).confirmPaymentIntent(context);
            }, child: Text("cofirm payment intent")),
          ),
        ],
      ),
    );
  }
}
