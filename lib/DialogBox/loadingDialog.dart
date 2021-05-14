import 'package:flutter/material.dart';
import 'package:pedigreejh/Widgets/loadingWidget.dart';

class loadingAlertDialog extends StatelessWidget {

  final String message;
  const loadingAlertDialog({Key key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: key,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          circularProgress(),
          SizedBox(
            height: 10,
          ),
          Text('Authenticating, please wait...'),
        ],
      ),
    );
  }
}