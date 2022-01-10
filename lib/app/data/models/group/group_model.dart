class GroupModel {
  late String groupName;
  late String icon;
  late int groupCode;

  GroupModel({required this.groupName, required this.icon  , required this.groupCode});
  GroupModel.fromJson(Map<String, dynamic> json) {
    groupName = json['GroupName'];
    groupCode = json['GroupCode'];
    icon = json['Icon'];
  }
}
