
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EmptyListWidget extends StatelessWidget {
   EmptyListWidget({
    super.key,
    required this.title,
  });
  String title;

  @override
  Widget build(BuildContext context) {
    return  Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(CupertinoIcons.layers_alt,size: 100,),
          Text(title),
        ],
      ),
    );
  }
}
