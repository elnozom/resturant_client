class TableGroup {
  late int  groupTableNo;
  late String  groupTableName;
  late int  tableCount;
  TableGroup({
    required this.groupTableNo, required this.groupTableName, required this.tableCount 
    });
  TableGroup.fromJson(Map<String, dynamic> json) {
   groupTableNo = json['GroupTableNo'];
   groupTableName = json['GroupTableName'];
   tableCount = json['TableCount'];
  }

    static TableGroup newInstance(){
    return new TableGroup(groupTableNo: 0 ,  groupTableName:"" , tableCount: 0);
  }
}
