class CreateOrderResp {
  late int  headSerial;
  late String  docNo;
  CreateOrderResp({
    required this.headSerial, required this.docNo 
    });
  CreateOrderResp.fromJson(Map<String, dynamic> json) {
    headSerial = json['HeadSerial'];
    docNo = json['DocNo'];
  }
}
