import 'dart:io';
import 'dart:ui';

import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:inhameal_flutter_project/Controller/data_controller.dart';
import 'package:ios_utsname_ext/extension.dart';
import 'package:package_info/package_info.dart';
import '../constants/static_variable.dart';
import 'component/custom_reorderable_list_view.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key, required this.parentSetState});

  final VoidCallback parentSetState;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('설정'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CafePriorityListWidget(
              parentSetState: parentSetState,
            ),
            Container(
              height: 20,
              color: Colors.black12,
            ),
            ConnectEmailWidget(),
          ],
        ),
      ),
    );
  }
}

class CafePriorityListWidget extends StatefulWidget {
  const CafePriorityListWidget({super.key, required this.parentSetState});

  final VoidCallback parentSetState;

  @override
  State<CafePriorityListWidget> createState() => _CafePriorityListWidgetState();
}

class _CafePriorityListWidgetState extends State<CafePriorityListWidget> {
  late final List<String> _items;
  final DataController _dataController = DataController();

  @override
  void initState() {
    super.initState();
    _items = _dataController.cafeList;
  }

  @override
  Widget build(BuildContext context) {
    return ReorderableListView(
      shrinkWrap: true,
      primary: false,
      header: Text("식당 순서 설정",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: <Widget>[
        for (int index = 0; index < _items.length; index += 1)
          ListTile(
            key: Key('$index'),
            title: Text(AppVar.cafeKorean[_items[index]] ?? "식당"),
            trailing: ReorderableDragStartListener(
                index: index, child: const Icon(Icons.drag_handle)),
          ),
      ],
      onReorder: this.onReorder,
    );
  }

  void onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }
      final String item = _items.removeAt(oldIndex);
      _items.insert(newIndex, item);
    });
    _dataController.updateCafePriority(_items);
    widget.parentSetState();
  }
}


class ConnectEmailWidget extends StatelessWidget {
  ConnectEmailWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async {
        String body = await _getEmailBody();

        final Email email = Email(
          body: body,
          subject: '[인하밥먹자 문의]',
          recipients: ['mun97696@gmail.com'],
          cc: [],
          bcc: [],
          attachmentPaths: [],
          isHTML: false,
        );

        try {
          await FlutterEmailSender.send(email);
        } catch (error) {
          String content = "기본 메일 앱을 사용할 수 없기 때문에 앱에서 바로 문의를 전송하기 어려운 상황입니다.\n\n아래 이메일로 연락주시면 친절하게 답변해드릴게요 :)\n\nmun97696@gmail.com";
          showDialog(
            context: context,
            builder: (_) => CupertinoAlertDialog(
                content: Text(content),
                actions: [
                  TextButton(
                    onPressed: () => Clipboard.setData(ClipboardData(text:"mun97696@gmail.com")),
                    child: const Text("이메일 복사"),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'OK'),
                    child: const Text("확인"),
                  ),
                ]
            ),
          );
        }
      },
      child: const Text('문의하기'),
    );
  }
  // TODO: 안드랑 아이폰 스타일 다이얼로그 스타일 변경
  // TODO: 날짜 없을 때 나오는 다이얼로그 통일
}


Future<String> _getEmailBody() async {
  Map<String, dynamic> appInfo = await _getAppInfo();
  Map<String, dynamic> deviceInfo = await _getDeviceInfo();

  String body = "";

  body += "==============\n";
  body += "아래 내용을 함께 보내주시면 큰 도움이 됩니다 😄\n";

  appInfo.forEach((key, value) {
    body += "$key: $value\n";
  });

  deviceInfo.forEach((key, value) {
    body += "$key: $value\n";
  });

  body += "==============\n";

  return body;
}



Future<Map<String, dynamic>> _getDeviceInfo() async {
  DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> deviceData = <String, dynamic>{};

  try {
    if (Platform.isAndroid) {
      deviceData = _readAndroidDeviceInfo(await deviceInfoPlugin.androidInfo);
    } else if (Platform.isIOS) {
      deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
    }
  } catch(error) {
    deviceData = {
      "Error": "Failed to get platform version."
    };
  }

  return deviceData;
}

Map<String, dynamic> _readAndroidDeviceInfo(AndroidDeviceInfo info) {
  var release = info.version.release;
  var sdkInt = info.version.sdkInt;
  var manufacturer = info.manufacturer;
  var model = info.model;

  return {
    "OS 버전": "Android $release (SDK $sdkInt)",
    "기기": "$manufacturer $model"
  };
}

Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo info) {
  var systemName = info.systemName;
  var version = info.systemVersion;
  var machine = info.utsname.machine.iOSProductName;

  return {
  "OS 버전": "$systemName $version",
  "기기": "$machine"
  };
}

Future<Map<String, dynamic>> _getAppInfo() async {
  PackageInfo info = await PackageInfo.fromPlatform();
  return {
    "인하밥먹자 버전": info.version
  };
}