import 'package:client_v3/app/data/models/table/table_model.dart';
import 'package:client_v3/app/modules/order/helpers/action.dart';
import 'package:client_v3/app/data/models/customer/customer_model.dart';
import 'package:client_v3/app/data/models/customer/customer_provider.dart';
import 'package:client_v3/app/modules/order/helpers/updateActions.dart';
import 'package:client_v3/app/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangeCustomer extends UpdateActions implements ActionInterface {
  final CustomerProvider customerProvider = Get.put(CustomerProvider());
  Rx<bool> err = false.obs;
  Rx<bool> customersLoading = false.obs;
  List<Customer> customers = [];
  Customer? selectedCustomer;
  ChangeCustomer(TableModel config) : super(config){
    getCustomers();
  }
  Future getCustomers() async {
    customersLoading.value = true;
    await customerProvider.listCustomersByName("").then((value) {
      customers = value;
      customersLoading.value = false;
    });
  }

  List<DropdownMenuItem<Customer>> customersDropDown() {
    List<DropdownMenuItem<Customer>> list = [];
    for (var i = 0; i < customers.length; i++) {
      list.add(DropdownMenuItem<Customer>(
          child: Text(customers[i].accountName), value: customers[i]));
    }
    print(list);

    return list;
  }

  Widget customersAutocomplete() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(15.0),
        child: Autocomplete<Customer>(
          optionsBuilder: (TextEditingValue textEditingValue) {
            return customers
                .where((Customer county) => county.accountName
                    .toLowerCase()
                    .startsWith(textEditingValue.text.toLowerCase()))
                .toList();
          },
          displayStringForOption: (Customer option) => option.accountName,
          fieldViewBuilder: (BuildContext context,
              TextEditingController fieldTextEditingController,
              FocusNode fieldFocusNode,
              VoidCallback onFieldSubmitted) {
            return TextField(
              controller: fieldTextEditingController,
              focusNode: fieldFocusNode,
            );
          },
          onSelected: (Customer customer) {
            print('Selected: ${customer.accountName}');
            selectedCustomer = customer;
          },
          optionsViewBuilder: (BuildContext context,
              AutocompleteOnSelected<Customer> onSelected,
              Iterable<Customer> options) {
            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                child: Container(
                  child: ListView.builder(
                    padding: EdgeInsets.all(10.0),
                    itemCount: options.length,
                    itemBuilder: (BuildContext context, int index) {
                      final Customer option = options.elementAt(index);

                      return GestureDetector(
                        onTap: () {
                          onSelected(option);
                        },
                        child: ListTile(
                          title: Text(option.accountName,
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
  String actionTitle = "change_customer".tr;

  void reset(context) {
    err.value = false;
    customers = [];
    Navigator.pop(context);
  }

  @override
  Widget generateForm(context) => Column(
        children: [
          Obx(() => err.value
              ? Text("choose_customer".tr , style: TextStyle(color:Colors.red)) : SizedBox()),
          Obx(() => customersLoading.value
              ? LoadingWidget()
              : customersAutocomplete()),
          ElevatedButton(
              onPressed: () {
                submit(context);
              },
              child: Text("submit".tr))
        ],
      );

  @override
  void submit(context) {
    if (selectedCustomer == null) {
      err.value = true;
      return;
    }
    orderProvider
        .changeCustomer(config.serial, selectedCustomer!.serial)
        .then((value) {
      reset(context);
    });
  }
}
