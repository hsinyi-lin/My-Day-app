import 'package:flutter/material.dart';

const PrimaryColor = const Color(0xFFF86D67);

class TimetableReceivePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TimetableReceive();
  }
}

class TimetableReceive extends State {
  get child => null;
  get left => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffF86D67),
        title: Text('接收課表', style: TextStyle(fontSize: 20)),
      ),
    );
  }
}