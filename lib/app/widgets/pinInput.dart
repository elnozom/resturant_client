import 'package:flutter/material.dart';

Container pullet(active){

  Color color = active ? Colors.blue : Colors.black;
    return Container(
          margin: EdgeInsets.all(5.0),
          width: 10,
          height: 10,
          decoration: BoxDecoration(
              border: Border.all(color: Color(0xffffffff)),
              color: color,
              shape: BoxShape.circle),
        );
  }

List<Widget> pullets(count){
  List<Widget> pullets = [];
  for (var i = 0; i < 6; i++) {
    pullets.add(pullet(i < count));
  }
  return pullets;
}
class PinInput extends StatelessWidget {
  final int count;

  PinInput({required this.count});
  
  @override
  Widget build(BuildContext context) {
    return Row(
       mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
      children:pullets(this.count),
    );
  }



  
}
