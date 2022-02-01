import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:client_v3/app/data/models/table/table_model.dart';
import 'package:client_v3/app/utils/globals.dart';
import 'package:client_v3/app/data/models/table/table_group_model.dart';

class TablesWidgets {
  Widget areaTab(TableGroup group, Function click, Rx<int> activeGroup) {
    return GestureDetector(onTap: () {
      click(group.groupTableNo);
    }, child: Obx(() {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        margin: EdgeInsets.only(bottom: 5),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: activeGroup.value == group.groupTableNo
              ? Color(0xff1e90ff)
              : Colors.black,
          borderRadius: Globals().radius,
          // boxShadow: [Globals().shadowLight]
        ),
        child: Text(
          group.groupTableName,
          style: TextStyle(fontSize: 16),
        ),
      );
    }));
  }

  SingleChildScrollView tabsGroups(
      List<TableGroup> groups, Function onTap, activeGroup) {
    List<Widget> list = [];
    groups.forEach((group) {
      list.add(areaTab(group, onTap, activeGroup));
      list.add(SizedBox(width: 10));
    });

    return SingleChildScrollView(
        scrollDirection: Axis.horizontal, child: Row(children: list));
  }

  Color generateTableColor(TableModel table) {
    Color color = Color(0xff1e201f);
    if (table.pause) {
      color = Colors.red.shade900;
      return color;
    }
    if (table.state == "Working") {
      color =
          table.printTimes > 0 ? Colors.orange.shade900 : Colors.green.shade900;
    }

    return color;
  }

  Widget tableWidget(TableModel table, context) {
    bool isMobile = MediaQuery.of(context).size.width > 960;
    return Padding(
      padding: EdgeInsets.all(5),
      child: Container(
        width: isMobile ? 100 : 80,
        height: isMobile ? 100 : 80,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: generateTableColor(table)),
        child: Padding(
          padding: EdgeInsets.all(5),
          child: Column(
              mainAxisAlignment:table.state == 'Working' ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                 if(table.state == 'Working') Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                      Icon(Icons.schedule , color:Colors.white , size: 12,),
                      SizedBox(width:2),
                        Text(table.openTime , style : TextStyle(color : Colors.white, fontSize: 10)),
                      ],
                    )
                    
                    ,Text(table.docNo , style : TextStyle(color : Colors.white, fontSize: 10))],
                ),
                
                Text(table.tableName, style: TextStyle(color : Colors.white, fontSize: 20 , fontWeight: FontWeight.bold),),
                if(table.state == 'Free') Center(child: Text(table.status.tr , style: TextStyle(color : Colors.white,))),
                if(table.state == 'Working')  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text("${table.totalCash.toStringAsFixed(2)} EGP" , style: TextStyle(color : Colors.white, fontSize: 10),),
                  Row(
                    children: [
                      Icon(Icons.person_outline , color:Colors.white , size: 14,),
                      Text(table.guests.toString() ,  style: TextStyle(color : Colors.white, fontSize: 10)
                      ,),
                    ],
                  )],
                ),
              ]),
        ),
      ),
    );
  }

  tablesWidget(
      RxList<TableModel> tables, Function chooseTable, BuildContext context) {
    List<Widget> list = [];
    tables.value.forEach((TableModel table) {
      list.add(GestureDetector(
          onTap: () {
            chooseTable(table);
          },
          child: tableWidget(table, context)));
    });
    return GridView.count(
      crossAxisCount: MediaQuery.of(context).size.width > 960 ? 8 : 3,
      crossAxisSpacing: 1.0,
      mainAxisSpacing: 1.0,
      children: list,
    );
  }
}
