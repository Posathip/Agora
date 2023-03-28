import 'dart:async';
import 'dart:developer';

import 'package:agora/pages/call.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:agora_rtc_engine/rtc_remote_view.dart' as rtc_remote_view;
import 'package:agora_rtc_engine/rtc_local_view.dart' as rtc_local_view;

class IndexPage extends StatefulWidget {
  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  final channelController = TextEditingController();
  bool _validateError = false;
  ClientRole? _role = ClientRole.Broadcaster;

  @override
  void dispose() {
    // TODO: implement dispose
    channelController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agora'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(children: <Widget>[
            const SizedBox(height: 40),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: channelController,
              decoration: InputDecoration(
                  errorText: _validateError ? 'channel name is ' : null),
            ),
            RadioListTile(
              title: const Text('broadcaster'),
              onChanged: (ClientRole? value) {
                setState(() {
                  _role = value;
                });
              },
              value: ClientRole.Broadcaster,
              groupValue: _role,
            ),
            RadioListTile(
              title: const Text('Audience'),
              onChanged: (ClientRole? value) {
                setState(() {
                  _role = value;
                });
              },
              value: ClientRole.Audience,
              groupValue: _role,
            ),
            ElevatedButton(
              onPressed: onJoin,
              child: const Text('join'),
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 40)),
            )
          ]),
        ),
      ),
    );
  }

  Future<void> onJoin() async {
    setState(() {
      channelController.text.isEmpty
          ? _validateError = true
          : _validateError = false;
    });
    if (channelController.text.isNotEmpty) {
      await _handleCameraandMic(Permission.camera);
      await _handleCameraandMic(Permission.microphone);
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  CallPage(channelname: channelController.text, role: _role)));
    }
  }

  Future<void> _handleCameraandMic(Permission permission) async {
    final status = await permission.request();
    log(status.toString());
  }
}
