import 'dart:math';

import 'package:flutter/material.dart';
import 'package:my_app/CustomOhosView.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String receivedData = '';
  CustomViewController? _controller;
  void _onCustomOhosViewCreated(CustomViewController controller) {
    _controller = controller;
    _controller?.customDataStream.listen((data) {
      //接收到来自OHOS端的数据
      setState(() {
        receivedData = '来自ohos的数据：$data';
      });
    });
  }

  Widget _buildOhosView() {
    return SizedBox(
      width: 100,
      height: 100,
      child: CustomOhosView(_onCustomOhosViewCreated),
    );
  }

  Widget _buildFlutterView() {
    return Expanded(
      flex: 1,
      child: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              TextButton(
                onPressed: () {
                  final randomNum = Random().nextInt(10);
                  _controller?.sendMessageToOhosView(
                      'https://raw.githubusercontent.com/yyued/SVGAPlayer-iOS/master/SVGAPlayer/Samples/Goddess.svga');
                },
                child: const Text('发送数据给ohos'),
              ),
              const SizedBox(height: 10),
              Text(receivedData),
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 15),
            child: Text(
              'Flutter - View',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _buildOhosView(),
          _buildFlutterView(),
        ],
      ),
    );
  }
}
