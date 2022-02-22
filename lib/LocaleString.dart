import 'package:get/get.dart';
class LocaleString extends Translations{
  @override
  // TODO: implement keys
  Map<String, Map<String, String>> get keys => {
    'en_US':{
      'touch_any_where':'Touch anywhere to add a new order',
      'enter_code':'Please provide your employee code',
      'enter_pin':'Please provide your employee pin',
      'new_code':'Enter new code',
      'emp_code_err':'this employee code is not exists',
      "login_by_code" : "login by your employee code and pin",
      "login_by_qr" : "login by qr code",
      "emp_password_err" : "password is incorrect",
      'welcome':'welcome',
      "order_finished" : "this order has been finished",
      "not_allowed":"not allowed",
      "Working_without_cheque":"working - not settled",
      "Working_with_cheque":"working - settled",
      "paused":"someone is working on this table right now",
      "unauthorized":"this table dosn't belong to you",
      "error": "error",
      "tax" : "TAX",
      "connection_error": "somthing wrong happened while trying to connect to the server ",
      "login_desc" : "we need to verify who you are , so choose login method to continue"
    },
    'ar_EG':{
     'touch_any_where':'Touch anywhere to add a new order',
      'enter_code':'Please provide your employee code',
      'enter_pin':'Please provide your employee pin',
      'new_code':'Enter new code',
      'emp_code_err':'this employee code is not exists',
      "login_by_code" : "login by your employee code and pin",
      "login_by_qr" : "login by qr code",
      "emp_password_err" : "password is incorrect",
      'welcome':'welcome',
      "not_allowed":"not allowed",
      "Working_without_cheque":"working - not settled",
      "Working_with_cheque":"working - settled",
      "paused":"someone is working on this table right now",
      "unauthorized":"this table dosn't belong to you",
      "error": "error",
      "connection_error": "somthing wrong happened while trying to connect to the server ",
      "login_desc" : "we need to verify who you are , so choose login method to continue",
      "subtotal" : "اجمالي فرعي",
      "total" : "اجمالي",
      "discount" : "خصم",
      "name" : "الاسم",
      "price" : "السعر",
      "order_finished" : "تم الانتهاء من هذا الطلب",
      "tax" : "الضريبة",
      "qnt" : "الكمية"
    },
  };
}