import 'package:flutter/material.dart';

class MainGroup extends StatelessWidget {
  final String title;
  final String icon;

  MainGroup({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width > 960 ? 110 : 80,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width > 960 ? 70 : 70,
            height: MediaQuery.of(context).size.width > 960 ? 70 : 70,
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Theme.of(context).primaryColor),
              child:Text(
            this.title,
            textAlign: TextAlign.center,
            maxLines: 1,
            style: TextStyle(color: Colors.white),
          )
            ),
          ),
        ],
      ),
    );
  }
}
