class TableOpenOrderResp {
  late bool  isOrderOpened;
  late String  msg;
  
  TableOpenOrderResp({required this.isOrderOpened, required this.msg});
  TableOpenOrderResp.fromJson(Map<String, dynamic> json) {
   isOrderOpened = json['IsOrderOpened'];
   msg = json['Msg'];
  }

}
