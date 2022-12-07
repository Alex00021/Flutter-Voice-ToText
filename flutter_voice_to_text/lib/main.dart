import 'package:flutter/material.dart';
import 'package:flutter_voice_to_text/utils/sound_manage.dart';
import 'package:flutter_voice_to_text/utils/xf_manage.dart';

void main() {
  runApp(MaterialApp(
    home: HomePage(),
  ));
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WsWidgetPage(),
    );
  }
}

const host = 'iat-api.xfyun.cn';
const appId = '2a91074e';
// const appId = '';
// const apiKey = '';
const apiKey = 'ef44d1b88cf9d461d2de29760081d70b';
// const apiSecret = '';
const apiSecret = 'ZGY3MGE3ZGM3ODUzYzE0YjI2MzBkNWMz';

class WsWidgetPage extends StatefulWidget {
  @override
  _WsWidgetPageState createState() => _WsWidgetPageState();
}

class _WsWidgetPageState extends State<WsWidgetPage> {
  String _msg = '等待中...';
  XfManage? _xf;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SoundRecord.init();
  }

  @override
  void dispose() {
    _xf?.close();
    SoundRecord.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('语音识别'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          TextButton(
            onPressed: () async {
              // MicRecord.startListening();
              await SoundRecord.startListening();
              setState(() {
                _msg = '录音中..';
              });
            },
            child: Text('开始录音'),
          ),
          TextButton(
            onPressed: connect,
            child: Text('停止录音'),
          ),
          Container(
            height: 20,
          ),
          Center(child: Text(_msg)),
        ],
      ),
    );
  }

  connect() async {
    // MicRecord.stopListening();
    await SoundRecord.stopListening();
    setState(() {
      _msg = '录音停止,正在语音转文字...';
    });

    _xf = XfManage.connect(
      host,
      apiKey,
      apiSecret,
      appId,
      // await MicRecord.currentSamples(),
      await SoundRecord.currentSamples(),
          (msg) {
        setState(() {
          _msg = '语音转文字完成: \r\n$msg';
        });
      },
    );
  }
}
