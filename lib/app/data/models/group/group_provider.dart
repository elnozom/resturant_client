import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:client_v3/app/data/models/group/group_model.dart';
import 'package:client_v3/app/data/models/group/subgroup_model.dart';
import 'package:client_v3/app/modules/order/helpers/localStorage.dart';

class GroupProvider extends GetConnect {
  final localStorage = LocalStorage.instance;

  @override
  void onInit() {
    // httpClient.baseUrl = localStorage.getApiUrl();
  }

  Future<List<GroupModel?>> listMainGroups() async {
    final response = await get('${localStorage.getApiUrl()}group');
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
    final response = await get('${localStorage.getApiUrl()}group/${code}');
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
