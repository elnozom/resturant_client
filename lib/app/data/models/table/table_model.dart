class TableModel {
  late int serial;
  late int tableNo;
  late String tableName;
  late bool pause;
  late String state;
  late int printTimes;
  late String status;
  late String openDateTime;
  late String docNo;
  late int headSerial;
  late int guests;
  late int waiterCode;
  late double totalCash;
  

  TableModel(
      {required this.tableNo,
      required this.tableName,
      required this.pause,
      required this.openDateTime});
  TableModel.fromJson(Map<String, dynamic> json) {
    serial = json['Serial'];
    tableNo = json['TableNo'];
    tableName = json['TableName'];
    pause = json['Pause'];
    state = json['State'];
    printTimes = json['PrintTimes'];
    status = json['Status'];
    openDateTime = json['OpenDateTime'];
    docNo = json['DocNo'];
    headSerial = json['HeadSerial'];
    guests = json['Guests'];
    waiterCode = json['WaiterCode'];
    totalCash =  json['TotalCash'] is int ? json['TotalCash'].toDouble() : json['TotalCash'];
  }

  static TableModel newInstance() {
    return new TableModel(
        openDateTime: "", pause: false, tableName: "", tableNo: 0);
  }
}
