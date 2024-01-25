import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thawani_test/webviw_payment.dart';

class PaymentProvider extends ChangeNotifier{
  String thSession='';
  String customerId='';
  String clientReferenceId = '';
  String paymentMethodId = '';
  String paymentIntentId='';
  String get sessionId =>thSession;


  createCustomer(BuildContext context)async{
    try{

      final response = await http.post(
        Uri.parse('https://uatcheckout.thawani.om/api/v1/customers'),
        headers: {
          'Content-Type': 'application/json',
          'thawani-api-key':'rRQ26GcsZzoEhbrP2HZvLYDbn9C9et',
          'Authorization': 'Basic clJRMjZHY3Naem9FaGJyUDJIWnZMWURibjlDOWV0OkhHdlRNTERzc0pnaHI5dGxOOWdyNERWWXQwcXlCeQ=='
        },
        body: json.encode({
          "client_customer_id": "alifarazbutt038@example.com"
        }),
      );
      print('status code ${response.statusCode}');
      print('response create customer ${response.body}');
      if (response.statusCode == 200) {
        final parsedJson = json.decode(response.body);
        if (parsedJson['success'] == true) {
          // Save the customer ID to shared preferences
          final customerID = parsedJson['data']['id'];
          await saveCustomerIDToSharedPreferences(customerID);
          print('id : $customerID');
        }
      } else {

      }
    }catch(error){

      print('catch error in create customer $error');
    }finally{
      // _paymentLoading = false;
      notifyListeners();
    }
  }
  Future<void> saveCustomerIDToSharedPreferences(String customerID) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('customerID', customerID);
  }


  createSession(BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final customerID = prefs.getString('customerID');

      if (customerID == null) {
        // Handle the case where customerID is not available
        return;
      }

      final response = await http.post(
        Uri.parse('https://uatcheckout.thawani.om/api/v1/checkout/session'),
        headers: {
          'Content-Type': 'application/json',
          'thawani-api-key': 'rRQ26GcsZzoEhbrP2HZvLYDbn9C9et',
          'Authorization':
          'Basic clJRMjZHY3Naem9FaGJyUDJIWnZMWURibjlDOWV0OkhHdlRNTERzc0pnaHI5dGxOOWdyNERWWXQwcXlCeQ=='
        },
        body: json.encode({
          "client_reference_id": "123412",
          "mode": "payment",
          "customer_id": customerID, // Add customer ID to the metadata
          "products": [
            {
              "name": "product 1",
              "quantity": 1,
              "unit_amount": 100
            }
          ],
          "success_url": "https://company.com/success",
          "cancel_url": "https://company.com/cancel",
          "metadata": {
            "Customer name": "somename",
            "order id": 0,
          }
        }),
      );

      print('status code ${response.statusCode}');
      print('response session ${response.body}');
      if (response.statusCode == 200) {
        final parsedJson = json.decode(response.body);
        if (parsedJson['success'] == true) {
          thSession = parsedJson['data']['session_id'];
          if(thSession != null){

            Navigator.push(context, MaterialPageRoute(builder: (context) =>  ThawaniPaymentWebView(session: thSession,)));
          }
        }
      } else {
        // Handle non-200 response, if needed
      }
    } catch (error, st) {
      print('catch error in thawaniSession $error');
      // Handle errors, if needed
    } finally {
      // _paymentLoading = false;
      notifyListeners();
    }
  }

  retrieveSession(BuildContext context) async {
    try {
      final response = await http.get(
        Uri.parse('https://uatcheckout.thawani.om/api/v1/checkout/session/$sessionId'),
        headers: {
          'Content-Type': 'application/json',
          'thawani-api-key': 'rRQ26GcsZzoEhbrP2HZvLYDbn9C9et',
          'Authorization': 'Basic clJRMjZHY3Naem9FaGJyUDJIWnZMWURibjlDOWV0OkhHdlRNTERzc0pnaHI5dGxOOWdyNERWWXQwcXlCeQ==',
          'session_id': sessionId,
        },

      );

      print('status code ${response.statusCode}');
      print('response retrieve session ${response.body}');
      if (response.statusCode == 200) {
        final parsedJson = json.decode(response.body);
        if (parsedJson['success'] == true) {
          customerId = parsedJson['data']['customer_id'];
          print('customer id $customerId');
          clientReferenceId = parsedJson['data']['client_reference_id']; // Set the client reference id
          print('client refrence id $clientReferenceId');
        }
      } else {
        // Handle non-200 response, if needed
      }
    } catch (error, st) {
      print('catch error in thawaniSession $error');
      // Handle errors, if needed
    } finally {
      // _paymentLoading = false;
      notifyListeners();
    }
  }


  saveCard(BuildContext context) async {
    try {


      final response = await http.get(
        Uri.parse('https://uatcheckout.thawani.om/api/v1/payment_methods?customer_id=$customerId'),
        headers: {
          'Content-Type': 'application/json',
          'thawani-api-key': 'rRQ26GcsZzoEhbrP2HZvLYDbn9C9et',
          'Authorization':
          'Basic clJRMjZHY3Naem9FaGJyUDJIWnZMWURibjlDOWV0OkhHdlRNTERzc0pnaHI5dGxOOWdyNERWWXQwcXlCeQ==',
        },

      );

      print('status code ${response.statusCode}');
      print('response card ${response.body}');
      print('customerId $customerId');
      if (response.statusCode == 200) {
        final parsedJson = json.decode(response.body);
        if (parsedJson['success'] == true) {
          if (parsedJson['data'] is List && parsedJson['data'].isNotEmpty) {
            paymentMethodId = parsedJson['data'][0]['id'];
            print('Payment Method ID: $paymentMethodId');
          }
        }
      } else {
        // Handle non-200 response, if needed
      }
    } catch (error, st) {
      print('catch error in thawaniSession $error');
      // Handle errors, if needed
    } finally {
      // _paymentLoading = false;
      notifyListeners();
    }
  }

  createPaymentIntent(BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse('https://uatcheckout.thawani.om/api/v1/payment_intents'),
        headers: {
          'Content-Type': 'application/json',
          'thawani-api-key': 'rRQ26GcsZzoEhbrP2HZvLYDbn9C9et',
          'Authorization':
          'Basic clJRMjZHY3Naem9FaGJyUDJIWnZMWURibjlDOWV0OkhHdlRNTERzc0pnaHI5dGxOOWdyNERWWXQwcXlCeQ=='
        },
        body: json.encode({
            "payment_method_id": paymentMethodId,
            "amount": 100,
            "client_reference_id": clientReferenceId,
            "return_url": "https://thw.om/success",
            "metadata": {
              "customer": "thawani developers"
            }
        }));
        print('method id $paymentMethodId');
        print('refrence id $clientReferenceId');
      print('status code ${response.statusCode}');
      print('response create payment intent ${response.body}');
      if (response.statusCode == 200) {
        final parsedJson = json.decode(response.body);
        if (parsedJson['success'] == true) {
           paymentIntentId = parsedJson['data']['id'];
          print('Payment Intent ID: $paymentIntentId');
        }
      } else {
        // Handle non-200 response, if needed
      }
    } catch (error, st) {
      print('catch error in thawaniSession $error');
      // Handle errors, if needed
    } finally {
      // _paymentLoading = false;
      notifyListeners();
    }
  }

  confirmPaymentIntent(BuildContext context) async {
    try {
      final response = await http.post(
          Uri.parse('https://uatcheckout.thawani.om/api/v1/payment_intents/$paymentIntentId/confirm'),
          headers: {
            'Content-Type': 'application/json',
            'thawani-api-key': 'rRQ26GcsZzoEhbrP2HZvLYDbn9C9et',
            'Authorization':
            'Basic clJRMjZHY3Naem9FaGJyUDJIWnZMWURibjlDOWV0OkhHdlRNTERzc0pnaHI5dGxOOWdyNERWWXQwcXlCeQ=='
          },
          body: json.encode({

          }));

      print('status code ${response.statusCode}');
      print('response confirm payment intent ${response.body}');
      if (response.statusCode == 200) {
        final parsedJson = json.decode(response.body);
        if (parsedJson['success'] == true) {
        }
      } else {
        // Handle non-200 response, if needed
      }
    } catch (error, st) {
      print('catch error in thawaniSession $error');
      // Handle errors, if needed
    } finally {
      // _paymentLoading = false;
      notifyListeners();
    }
  }

}