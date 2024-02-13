import 'dart:io';
import 'dart:ui';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:inhameal_flutter_project/Controller/data_controller.dart';
import 'package:ios_utsname_ext/extension.dart';
import 'package:package_info/package_info.dart';
import '../constants/static_variable.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key, required this.pSetState});

  final VoidCallback pSetState;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '설정',
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary, fontWeight: FontWeight.w700),
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.onSurface,
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(left: 8, right: 8, top: 8),
              decoration: BoxDecoration(
                border: Border.all(width: 0.8, color: Theme.of(context).colorScheme.background),
                borderRadius: BorderRadius.circular(10),
              ),
              child: CafePriorityListWidget(pSetState: this.pSetState),
            ),
            Container(height: 12),
            Container(
              margin: EdgeInsets.only(left: 8, right: 8, top: 8),
              decoration: BoxDecoration(
                border: Border.all(width: 0.8, color: Theme.of(context).colorScheme.background),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 12, top: 16),
                    child: Text("앱", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                  ConnectEmailWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 식당 순서 위젯
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
class CafePriorityListWidget extends StatefulWidget {
  CafePriorityListWidget({super.key, required this.pSetState});

  final DataController _dataController = DataController();
  final VoidCallback pSetState;

  @override
  State<CafePriorityListWidget> createState() => _CafePriorityListWidgetState();
}

class _CafePriorityListWidgetState extends State<CafePriorityListWidget> {
  late final List<String> _items = widget._dataController.cafeList;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ReorderableListView.builder(
      itemCount: _items.length,
      shrinkWrap: true,
      primary: false,
      header: Padding(
        padding: const EdgeInsets.only(left: 12, bottom: 12, top: 16),
        child: Text("식당 순서", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      ),
      itemBuilder: (BuildContext context, int index) => Card(
        key: Key('$index'),
        elevation: 0,
        color: Colors.transparent,
        margin: EdgeInsets.symmetric(horizontal: 8),
        child: ListTile(
          title: Text(AppVar.cafeKorean[_items[index]] ?? "식당"),
          trailing: ReorderableDragStartListener(index: index, child: const Icon(Icons.drag_handle)),
        ),
      ),
      onReorder: this.onReorder,
    );
  }

  void onReorder(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) { newIndex -= 1; }
    setState(() {
      widget._dataController.onReorder(oldIndex, newIndex);
    });
    widget.pSetState();
  }
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 문의하기 위젯
///////////////////////////////////////////////////////////////////////////////////////////////////////////////

class ConnectEmailWidget extends StatelessWidget {
  ConnectEmailWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () async {
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
          String content = "기본 메일 앱을 사용할 수 없기 때문에\n앱에서 바로 문의를 전송하기 어렵습니다.\n\n아래 이메일로 연락주시면\n답변해드릴게요 :)\n\nmun97696@gmail.com";
// TODO: 디바이스별 줄개행 해결하기
          showDialog(
            context: context,
            builder: (_) {
              return (Theme.of(context).platform == TargetPlatform.iOS)
                  ? CupertinoAlertDialog(
                      content: Text(content),
                      actions: [
                        TextButton(
                          onPressed: () => Clipboard.setData(ClipboardData(text: "mun97696@gmail.com")),
                          child: const Text("이메일 복사"),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'OK'),
                          child: const Text("확인"),
                        ),
                      ],
                    )
                  : AlertDialog(
// TODO: 반복코드 줄이기
                      content: Text(content),
                      actionsPadding: EdgeInsets.only(right: 20, bottom: 20),
                      actions: [
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () => Clipboard.setData(ClipboardData(text: "mun97696@gmail.com")),
                          child: Text("이메일복사"),
                        ),
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () => Navigator.pop(context, 'OK'),
                          child: Text("확인"),
                        ),
                      ],
                    );
            },
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: ListTile(
          title: Text("문의하기"),
          trailing: Icon(Icons.keyboard_arrow_right_rounded),
        ),
      ),
    );
  }
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////
// email 본문
///////////////////////////////////////////////////////////////////////////////////////////////////////////////

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
  } catch (error) {
    deviceData = {"Error": "Failed to get platform version."};
  }

  return deviceData;
}

Map<String, dynamic> _readAndroidDeviceInfo(AndroidDeviceInfo info) {
  var release = info.version.release;
  var sdkInt = info.version.sdkInt;
  var manufacturer = info.manufacturer;
  var model = info.model;

  return {"OS 버전": "Android $release (SDK $sdkInt)", "기기": "$manufacturer $model"};
}

Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo info) {
  var systemName = info.systemName;
  var version = info.systemVersion;
  var machine = info.utsname.machine.iOSProductName;

  return {"OS 버전": "$systemName $version", "기기": "$machine"};
}

Future<Map<String, dynamic>> _getAppInfo() async {
  PackageInfo info = await PackageInfo.fromPlatform();
  return {"인하밥먹자 버전": info.version};
}
