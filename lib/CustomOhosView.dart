import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef OnViewCreated = Function(CustomViewController);

///自定义OhosView
class CustomOhosView extends StatefulWidget {
  final OnViewCreated onViewCreated;

  const CustomOhosView(this.onViewCreated, {super.key});

  @override
  State<CustomOhosView> createState() => _CustomOhosViewState();
}

class _CustomOhosViewState extends State<CustomOhosView> {
  late MethodChannel _channel;

  @override
  Widget build(BuildContext context) {
    return _getPlatformFaceView();
  }

  Widget _getPlatformFaceView() {
    return OhosView(
      viewType: 'com.rex.custom.ohos/customView',
      onPlatformViewCreated: _onPlatformViewCreated,
      creationParams: const <String, dynamic>{'initParams': 'hello world'},
      creationParamsCodec: const StandardMessageCodec(),
    );
  }

  void _onPlatformViewCreated(int id) {
    _channel = MethodChannel('com.rex.custom.ohos/customView$id');
    final controller = CustomViewController._(
      _channel,
    );
    widget.onViewCreated(controller);
  }
}

class CustomViewController {
  final MethodChannel _channel;
  final StreamController<String> _controller = StreamController<String>();

  CustomViewController._(
    this._channel,
  ) {
    _channel.setMethodCallHandler(
      (call) async {
        switch (call.method) {
          case 'getMessageFromOhosView':
            // 从native端获取数据
            final result = call.arguments as String;
            _controller.sink.add(result);
            break;
        }
      },
    );
  }

  Stream<String> get customDataStream => _controller.stream;

  // 发送数据给native
  Future<void> sendMessageToOhosView(String message) async {
    await _channel.invokeMethod(
      'getMessageFromFlutterView',
      message,
    );
  }
}
