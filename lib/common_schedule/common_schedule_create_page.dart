import 'package:My_Day_app/common_schedule/common_schedule_list_page.dart';
import 'package:My_Day_app/public/alert.dart';
import 'package:My_Day_app/public/schedule_request/create_common.dart';
import 'package:My_Day_app/schedule/schedule_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CommonScheduleCreatePage extends StatefulWidget {
  int groupNum;
  CommonScheduleCreatePage(this.groupNum);

  @override
  _CommonScheduleCreateWidget createState() =>
      new _CommonScheduleCreateWidget(groupNum);
}

class _CommonScheduleCreateWidget extends State<CommonScheduleCreatePage> {
  int groupNum;
  _CommonScheduleCreateWidget(this.groupNum);

  int _type;
  DateTime _startDateTime = DateTime.now();
  DateTime _endDateTime = DateTime.now().add(Duration(hours: 1));
  String _title;
  String _location;
  TextEditingController _titleController = TextEditingController();
  TextEditingController _locationController = TextEditingController();

  bool _allDay = false;
  bool _isNotCreate = false;

  @override
  Widget build(BuildContext context) {
    _titleController.text = _title;
    _locationController.text = _location;
    // values ------------------------------------------------------------------------------------------
    Size size = MediaQuery.of(context).size;
    double _height = size.height;
    double _width = size.width;
    double _bottomHeight = _height * 0.07;
    double _bottomIconWidth = _width * 0.05;

    Color _color = Theme.of(context).primaryColor;
    Color _light = Theme.of(context).primaryColorLight;

    double _paddingLR = _width * 0.06;
    double _listPaddingLR = _width * 0.1;
    double _listItemHeight = _height * 0.08;

    double _iconSize = _height * 0.05;
    double _h1Size = _height * 0.035;
    double _h2Size = _height * 0.03;
    double _pSize = _height * 0.025;
    double _timeSize = _width * 0.045;

    String _startView = _allDay
        ? '${_startDateTime.month.toString().padLeft(2, '0')} 月 ${_startDateTime.day.toString().padLeft(2, '0')} 日 ${weekdayName[_startDateTime.weekday - 1]}'
        : '${_startDateTime.month.toString().padLeft(2, '0')} 月 ${_startDateTime.day.toString().padLeft(2, '0')} 日 ${weekdayName[_startDateTime.weekday - 1]} ${_startDateTime.hour.toString().padLeft(2, '0')}:${_startDateTime.minute.toString().padLeft(2, '0')}';
    String _endView = _allDay
        ? '${_endDateTime.month.toString().padLeft(2, '0')} 月 ${_endDateTime.day.toString().padLeft(2, '0')} 日 ${weekdayName[_endDateTime.weekday - 1]}'
        : '${_endDateTime.month.toString().padLeft(2, '0')} 月 ${_endDateTime.day.toString().padLeft(2, '0')} 日 ${weekdayName[_endDateTime.weekday - 1]} ${_endDateTime.hour.toString().padLeft(2, '0')}:${_endDateTime.minute.toString().padLeft(2, '0')}';

    // _submit -----------------------------------------------------------------------------------------
    _submit() async {
      String _alertTitle = '新增共同行程失敗';
      String uid = 'lili123';
      String title = _titleController.text;
      String startTime;
      String endTime;

      int typeId = _type;
      String place = _locationController.text;

      String startTimeString =
          '${_startDateTime.year.toString()}-${_startDateTime.month.toString().padLeft(2, '0')}-${_startDateTime.day.toString().padLeft(2, '0')} 00:00:00';
      String endTimeString =
          '${_endDateTime.year.toString()}-${_endDateTime.month.toString().padLeft(2, '0')}-${_endDateTime.day.toString().padLeft(2, '0')} 23:59:59';

      if (_allDay) {
        startTime = DateTime.parse(startTimeString).toString();
        endTime = DateTime.parse(endTimeString).toString();
      } else {
        startTime = _startDateTime.toString();
        endTime = _endDateTime.toString();
      }

      if (uid == null) {
        await alert(context, _alertTitle, '請先登入');
        _isNotCreate = true;
        Navigator.pop(context);
      }
      if (title == null || title == '') {
        await alert(context, _alertTitle, '請輸入標題');
        _isNotCreate = true;
      }
      if (startTime == null || startTime == '') {
        await alert(context, _alertTitle, '請選擇開始時間');
        _isNotCreate = true;
      }

      if (endTime == null || endTime == '') {
        await alert(context, _alertTitle, '請選擇結束時間');
        _isNotCreate = true;
      }
      if (typeId == null || typeId <= 0 || typeId > 8) {
        await alert(context, _alertTitle, '請選擇類別');
        _isNotCreate = true;
      }
      if (_isNotCreate) {
        _isNotCreate = false;
        return true;
      } else {
        var submitWidget;
        _submitWidgetfunc() async {
          return CreateCommon(
            uid: uid,
            groupNum: groupNum,
            title: title,
            startTime: startTime,
            endTime: endTime,
            typeId: typeId,
            place: place,
          );
        }

        submitWidget = await _submitWidgetfunc();
        if (await submitWidget.getIsError())
          return true;
        else
          return false;
      }
    }

    dynamic getTypeColor(value) {
      dynamic color = value == null ? 0xffFFFFFF : typeColor[value - 1];
      return color;
    }

    // // picker mode ----------------------------------------------------------------------------------
    CupertinoDatePickerMode _mode() {
      if (_allDay)
        return CupertinoDatePickerMode.date;
      else
        return CupertinoDatePickerMode.dateAndTime;
    }

    void _datePicker(contex, isStart) {
      DateTime _dateTime;
      if (isStart)
        _dateTime = _startDateTime;
      else
        _dateTime = _startDateTime.add(Duration(hours: 1));
      showCupertinoModalPopup(
        context: context,
        builder: (_) => Container(
          height: _height * 0.35,
          color: Colors.white,
          child: Column(
            children: [
              Container(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: CupertinoButton(
                    child: Text('確定', style: TextStyle(color: _color)),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ),
              Container(
                height: _height * 0.28,
                child: CupertinoDatePicker(
                  mode: _mode(),
                  initialDateTime: _dateTime,
                  onDateTimeChanged: (value) => setState(() {
                    if (isStart) {
                      _startDateTime = value;
                      _endDateTime = value.add(Duration(hours: 1));
                    } else
                      _endDateTime = value;
                  }),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // createScheduleList ------------------------------------------------------------------------------
    Widget createScheduleList = ListView(
      children: [
        // text field ----------------------------------------------------------------------------- title
        Padding(
          padding: EdgeInsets.fromLTRB(
              _paddingLR, _height * 0.03, _paddingLR, _height * 0.02),
          child: TextField(
            style: TextStyle(fontSize: _h1Size),
            decoration: InputDecoration(
                hintText: '標題',
                hintStyle: TextStyle(color: Colors.grey),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 0.5)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: _color))),
            cursorColor: _color,
            controller: _titleController,
            onSubmitted: (_) => FocusScope.of(context)
                .requestFocus(FocusNode()), //按enter傳回空的focus
          ),
        ),

        //  text ---------------------------------------------------------------------------------- time
        Padding(
          padding: EdgeInsets.fromLTRB(_paddingLR, 0, _paddingLR, 0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                      flex: 6,
                      child: Text('整天', style: TextStyle(fontSize: _pSize))),
                  Expanded(
                      flex: 1,
                      child: Align(
                        child: CupertinoSwitch(
                          activeColor: _color,
                          value: _allDay,
                          onChanged: (bool value) =>
                              setState(() => _allDay = value),
                        ),
                      )),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // 開始-------------------------------------------------------
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(_paddingLR, 0, _paddingLR, 0),
                    child: Text(
                      '開始',
                      style: TextStyle(fontSize: _pSize),
                    ),
                  ),
                  TextButton(
                    child: Text(
                      _startView,
                      style: TextStyle(
                          fontSize: _timeSize,
                          color: Colors.black,
                          fontWeight: FontWeight.normal),
                    ),
                    style: ButtonStyle(alignment: Alignment.centerRight),
                    onPressed: () => _datePicker(context, true),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // 結束 ------------------------------------------------------
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(_paddingLR, 0, _paddingLR, 0),
                    child: Text(
                      '結束',
                      style: TextStyle(fontSize: _pSize),
                    ),
                  ),
                  TextButton(
                    child: Text(
                      _endView,
                      style: TextStyle(
                          fontSize: _timeSize,
                          color: Colors.black,
                          fontWeight: FontWeight.normal),
                    ),
                    style: ButtonStyle(alignment: Alignment.centerRight),
                    onPressed: () => _datePicker(context, false),
                  ),
                ],
              )
            ],
          ),
        ),

        // 分隔線
        Divider(
          height: _height * 0.02,
          indent: _paddingLR,
          endIndent: _paddingLR,
          color: Colors.grey,
          thickness: 0.5,
        ),

        // dropdown buttn ------------------------------------------------------------------------- type
        Padding(
          padding: EdgeInsets.fromLTRB(
              _listPaddingLR, size.height * 0.01, _listPaddingLR, 0),
          child: Container(
            height: _listItemHeight,
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Image.asset(
                    'assets/images/type.png',
                    height: _height * 0.05,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(),
                ),
                Expanded(
                  flex: 7,
                  child: DropdownButton(
                    itemHeight: _height * 0.1,
                    hint: Text('類別',
                        style:
                            TextStyle(fontSize: _h2Size, color: Colors.grey)),
                    iconEnabledColor: Colors.grey,
                    underline: Container(),
                    focusColor: _color,
                    value: _type,
                    items: [
                      DropdownMenuItem(
                          child:
                              Text('讀書', style: TextStyle(fontSize: _h2Size)),
                          value: 1),
                      DropdownMenuItem(
                          child:
                              Text('工作', style: TextStyle(fontSize: _h2Size)),
                          value: 2),
                      DropdownMenuItem(
                          child:
                              Text('會議', style: TextStyle(fontSize: _h2Size)),
                          value: 3),
                      DropdownMenuItem(
                          child:
                              Text('休閒', style: TextStyle(fontSize: _h2Size)),
                          value: 4),
                      DropdownMenuItem(
                          child:
                              Text('社團', style: TextStyle(fontSize: _h2Size)),
                          value: 5),
                      DropdownMenuItem(
                          child:
                              Text('吃飯', style: TextStyle(fontSize: _h2Size)),
                          value: 6),
                      DropdownMenuItem(
                          child:
                              Text('班級', style: TextStyle(fontSize: _h2Size)),
                          value: 7),
                      DropdownMenuItem(
                          child:
                              Text('個人', style: TextStyle(fontSize: _h2Size)),
                          value: 8),
                    ],
                    onChanged: (int value) {
                      setState(() => _type = value);
                    },
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                      height: _height * 0.025,
                      child: CircleAvatar(
                        radius: _height * 0.025,
                        backgroundColor: Color(getTypeColor(_type)),
                      )),
                )
              ],
            ),
          ),
        ),

        // text field ----------------------------------------------------------------------------- location
        Padding(
          padding: EdgeInsets.fromLTRB(_listPaddingLR, 0, _listPaddingLR, 0),
          child: Container(
            height: _listItemHeight,
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Image.asset(
                    'assets/images/location.png',
                    height: _iconSize,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(),
                ),
                Expanded(
                  flex: 8,
                  child: TextField(
                    controller: _locationController,
                    style: TextStyle(fontSize: _h2Size),
                    decoration: InputDecoration(
                      hintText: '地點',
                      hintStyle: TextStyle(color: Colors.grey),
                      enabledBorder: InputBorder.none,
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: _color)),
                    ),
                    cursorColor: _color,
                    onSubmitted: (_) =>
                        FocusScope.of(context).requestFocus(FocusNode()),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );

    return Scaffold(
      body: GestureDetector(
        // 點擊空白處釋放焦點
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Container(
          color: Colors.white,
          child: SafeArea(
            bottom: false,
            child: Center(child: createScheduleList),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: Theme.of(context).bottomAppBarColor,
        child: SafeArea(
          top: false,
          child: BottomAppBar(
            elevation: 0,
            child: Row(children: <Widget>[
              Expanded(
                child: SizedBox(
                  height: _bottomHeight,
                  child: RawMaterialButton(
                      elevation: 0,
                      child: Image.asset(
                        'assets/images/cancel.png',
                        width: _bottomIconWidth,
                      ),
                      fillColor: _light,
                      onPressed: () => Navigator.pop(context)),
                ),
              ), // 取消按鈕
              Expanded(
                child: SizedBox(
                  height: _bottomHeight,
                  child: RawMaterialButton(
                    elevation: 0,
                    child: Image.asset(
                      'assets/images/confirm.png',
                      width: _bottomIconWidth,
                    ),
                    fillColor: _color,
                    onPressed: () async {
                      if (await _submit() != true) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                CommonScheduleListPage(groupNum)));
                      }
                    },
                  ),
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }
}