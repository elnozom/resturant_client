class TableGroup {
  late int  groupTableNo;
  late String  groupTableName;
  late int  tableCount;
  late bool  useMinimumBon;
  late bool  useSellTax;
  TableGroup({
    required this.groupTableNo, required this.groupTableName, required this.tableCount ,required this.useMinimumBon ,required this.useSellTax 
    });
  TableGroup.fromJson(Map<String, dynamic> json) {
   groupTableNo = json['GroupTableNo'];
   groupTableName = json['GroupTableName'];
   tableCount = json['TableCount'];
   useMinimumBon = json['UseMinimumBon'];
   useSellTax = json['UseSellTax'];
  }
  static TableGroup newInstance(){
    return new TableGroup(groupTableNo: 0 ,  groupTableName:"" , tableCount: 0 , useMinimumBon : false , useSellTax : false);
  }
}
