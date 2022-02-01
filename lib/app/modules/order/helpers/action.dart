import 'package:client_v3/app/data/models/table/table_model.dart';
import 'package:flutter/material.dart';

abstract class ActionInterface  {
  // void openDialog(context);
  Widget generateForm(context);
  String actionTitle = "";
  void submit(context);
  void reset(context);


}
