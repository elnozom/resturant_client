class TableModel {
  late int serial;
  late int tableNo;
  late String tableName;
  late bool pause;
  late String state;
  late int printTimes;
  late String status;
  late String openTime;
  late String openDate;
  late int bonNo;
  late int orderNo;
  late String docNo;
  late int headSerial;
  late int guests;
  late int waiterCode;
  late int customerSerial;
  late double subtotal;
  late int discountPercent;
  late double discountValue;
  late double totalCash;
  late bool useTax;
  late double minimumBon;
  late String computerName;

  TableModel({
    required this.tableNo,
    required this.tableName,
    required this.pause,
    required this.openTime,
    required this.openDate,
    required this.bonNo,
    required this.orderNo,
    required this.useTax,
    required this.minimumBon,
    required this.computerName,
  });

  TableModel.fromJson(Map<String, dynamic> json) {
    serial = json['Serial'];
    tableNo = json['TableNo'];
    tableName = json['TableName'];
    pause = json['Pause'];
    state = json['State'];
    printTimes = json['PrintTimes'];
    status = json['Status'];
    openTime = json['OpenTime'];
    openDate = json['OpenDate'];
    bonNo = json['BonNo'];
    orderNo = json['OrderNo'];
    docNo = json['DocNo'];
    headSerial = json['HeadSerial'];
    guests = json['Guests'];
    waiterCode = json['WaiterCode'];
    customerSerial = json['CustomerSerial'];
    computerName = json['ComputerName'];
    useTax = json['UseTax'];
    subtotal = json['Subtotal'] is int  ? json['Subtotal'].toDouble() : json['Subtotal'];
    minimumBon = json['MinimumBon'] is int  ? json['MinimumBon'].toDouble() : json['MinimumBon'];
    discountPercent = json['DiscountPercent'];
    discountValue = json['DiscountValue'] is int  ? json['DiscountValue'].toDouble() : json['DiscountValue'];
    totalCash = json['TotalCash'] is int ? json['TotalCash'].toDouble() : json['TotalCash'];
  }

  static TableModel newInstance() {
    return new TableModel(
      openTime: "",
      pause: false,
      tableName: "",
      tableNo: 0,
      openDate: "",
      bonNo: 0,
      orderNo: 0,
      useTax: false,
      minimumBon: 0.0,
      computerName : ""
    );
  }
}
