import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class FeedBackPage extends StatefulWidget {
  final String url;
  final String title;

  const FeedBackPage(this.url, this.title, {super.key});

  @override
  FeedBackPageState createState() =>
      FeedBackPageState(url, title);
}

class FeedBackPageState extends State<FeedBackPage> {
  final String url;
  final String title;
  FeedBackPageState(this.url, this.title);
  late WebViewController controller;

  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () async{
                if(await controller.canGoBack()){
                  controller.goBack();
                }
              },
            ),
            IconButton(
              icon: const Icon(
                Icons.refresh,
                color: Colors.white,
              ),
              onPressed: (){
                controller.reload();
              },
            ),
          ],
        ),
        body: Column(children: [
          Expanded(
              child: WebView(
                  initialUrl: url,
                  javascriptMode: JavascriptMode.unrestricted,
                  onWebViewCreated: (controller){
                    this.controller = controller;
                  },
              )
          )
        ])
    );
  }
}

