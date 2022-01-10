import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:client_v3/app/data/models/group/group_model.dart';
import 'package:client_v3/app/data/models/group/subgroup_model.dart';

class GroupProvider extends GetConnect {
  @override
  void onInit() {
    httpClient.baseUrl = dotenv.env['API_URL'];
  }

  Future<List<GroupModel?>> listMainGroups() async {
    final response = await get('${dotenv.env['API_URL']}group');
    // var body = response.body != null ? jsonDecode(response.body) : [];
     if (response.status.hasError) {
      return Future.error(response.statusText.toString());
    } else {
      List<GroupModel> groups = [];
      if(response.body != null) response.body.forEach((item){
        GroupModel group = GroupModel.fromJson(item);
        groups.add(group);
      });
      return groups;
    }
   
  }



  Future<List<SubGroupModel>?> listSubGroups(int code) async {
    final response = await get('${dotenv.env['API_URL']}group/${code}');
    // var body = response.body != null ? jsonDecode(response.body) : [];
     if (response.status.hasError) {
      return Future.error(response.statusText.toString());
    } else {
      List<SubGroupModel> groups = [];
      if(response.body != null) response.body.forEach((item){
        SubGroupModel group = SubGroupModel.fromJson(item);
        groups.add(group);
      });
      return groups;
    }
   
  }
}
