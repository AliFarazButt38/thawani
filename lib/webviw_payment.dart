import 'dart:async';
import 'package:flutter/material.dart';
import 'package:thawani_test/home.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ThawaniPaymentWebView extends StatefulWidget {
  final String session;
  final bool? check;

  ThawaniPaymentWebView({Key? key, required this.session, this.check}) : super(key: key);

  @override
  State<ThawaniPaymentWebView> createState() => _ThawaniPaymentWebViewState();
}

class _ThawaniPaymentWebViewState extends State<ThawaniPaymentWebView> {
  final Completer<WebViewController> _controller = Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: WebView(
          initialUrl: 'https://uatcheckout.thawani.om/pay/${widget.session}?key=HGvTMLDssJghr9tlN9gr4DVYt0qyBy',
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
          },
          onPageStarted: (String url) {
            if (url.endsWith('/cancel')) {
             Navigator.push(context, MaterialPageRoute(builder: (context)=>Home()));
            } else if (url.endsWith('/success')) {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>Home()));

              if (widget.check == true) {
                // Handle success for wallet recharge
              } else {
                // Handle success for booking confirmation
              }
            }
          },
          gestureNavigationEnabled: true,
        ),
      ),
    );
  }
}
