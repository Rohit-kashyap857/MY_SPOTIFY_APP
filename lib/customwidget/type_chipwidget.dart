import 'package:flutter/material.dart';

class TypeChipwidget extends StatelessWidget {
  String typeName;
  TypeChipwidget({required this.typeName});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right:11),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: Colors.grey, width: 0.5),
      ),
      child: Center(
        child: Text(
          "${typeName}",
          style: TextStyle(color: Colors.white, fontSize: 12),
        ),
      ),
    );
  }
}

