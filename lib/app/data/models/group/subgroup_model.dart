class SubGroupModel {
  late String groupName;
  late int groupCode;

  SubGroupModel({required this.groupName, required this.groupCode});
  SubGroupModel.fromJson(Map<String, dynamic> json) {
    groupName = json['GroupName'];
    groupCode = json['GroupCode'];
  }
}
