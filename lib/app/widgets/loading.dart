import 'package:flutter/material.dart';
import 'package:client_v3/app/utils/globals.dart';

class LoadingWidget extends StatelessWidget {

  LoadingWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          /// Loader Animation Widget

          CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
          ),
        ],
      ),
    );
  }
}
