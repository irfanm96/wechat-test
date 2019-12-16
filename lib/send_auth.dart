import 'package:flutter/material.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class SendAuthPage extends StatefulWidget {
  @override
  _SendAuthPageState createState() => _SendAuthPageState();
}

class _SendAuthPageState extends State<SendAuthPage> {
  String _result = "无";
  String APP_ID = 'wx52be4f5f1e383173';
  String APP_SECRET = '946125d07a2c3c5406873210c14185f8';

  @override
  void initState() {
    super.initState();

    fluwx.responseFromAuth.listen((data) async {
      print(data.code);

      var url =
          'https://api.weixin.qq.com/sns/oauth2/access_token?appid=${APP_ID}&secret=${APP_SECRET}&code=${data.code}&grant_type=authorization_code';
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var jsonResponse = convert.jsonDecode(response.body);
        print(jsonResponse);
      } else {
        print("Request failed with status: ${response.statusCode}.");
      }

      setState(() {
        _result = "${data.errCode}";
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _result = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Send Auth"),
      ),
      body: Column(
        children: <Widget>[
          OutlineButton(
            onPressed: () {
              fluwx
                  .sendAuth(
                      scope: "snsapi_userinfo", state: "wechat_sdk_demo_test")
                  .then((data) {
                print(data);
              });
            },
            child: const Text("send auth"),
          ),
          const Text("响应结果;"),
          Text(_result)
        ],
      ),
    );
  }
}
