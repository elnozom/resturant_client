import 'package:client_v3/app/data/models/auth/emp_model.dart';
import 'package:client_v3/app/data/models/table/table_model.dart';
import 'package:client_v3/app/modules/order/helpers/action.dart';
import 'package:client_v3/app/modules/order/helpers/updateActions.dart';
import 'package:client_v3/app/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangeWaiter extends UpdateActions implements ActionInterface {
  Rx<bool> err = false.obs;
  Rx<bool> waitersLoading = false.obs;
  List<Emp> waiters = [];
  Emp? selectedWaiter;
  ChangeWaiter(TableModel config) : super(config){
    getWaiters();
  }
  Future getWaiters() async {
    waitersLoading.value = true;
    await orderProvider.listWaiters().then((value) {
      waiters = value;
      waitersLoading.value = false;
    });
  }

  @override
  String actionTitle = "change_waiter".tr;

  void reset(context) {
    err.value = false;
    waiters = [];
    Navigator.pop(context);
  }

  Widget waitersAutocomplete() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(15.0),
        child: Autocomplete<Emp>(
          optionsBuilder: (TextEditingValue textEditingValue) {
            return waiters
                .where((Emp emp) => emp.empName
                    .toLowerCase()
                    .startsWith(textEditingValue.text.toLowerCase()))
                .toList();
          },
          displayStringForOption: (Emp option) => option.empName,
          fieldViewBuilder: (BuildContext context,
              TextEditingController fieldTextEditingController,
              FocusNode fieldFocusNode,
              VoidCallback onFieldSubmitted) {
            return TextField(
              controller: fieldTextEditingController,
              focusNode: fieldFocusNode,
            );
          },
          onSelected: (Emp emp) {
            print('Selected: ${emp.empName}');
            selectedWaiter = emp;
          },
          optionsViewBuilder: (BuildContext context,
              AutocompleteOnSelected<Emp> onSelected, Iterable<Emp> options) {
            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                child: Container(
                  child: ListView.builder(
                    padding: EdgeInsets.all(10.0),
                    itemCount: options.length,
                    itemBuilder: (BuildContext context, int index) {
                      final Emp option = options.elementAt(index);

                      return GestureDetector(
                        onTap: () {
                          onSelected(option);
                        },
                        child: ListTile(
                          title: Text(option.empName,
                              style: const TextStyle(color: Colors.black)),
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }


  @override
  Widget generateForm(context) => Column(
        children: [
           Obx(() => err.value
              ? Text("choose_waiter".tr , style: TextStyle(color:Colors.red)) : SizedBox()),
          Obx(() => waitersLoading.value
              ? LoadingWidget()
              : waitersAutocomplete()),
          ElevatedButton(
              onPressed: () {
                submit(context);
              },
              child: Text("submit".tr))
        ],
      );

  @override
  void submit(context) {
    if (selectedWaiter == null) {
      err.value = true;
      return;
    }
    orderProvider
        .changeWaiter(config.serial, selectedWaiter!.empCode)
        .then((value) {
      reset(context);
    });
  }
}
