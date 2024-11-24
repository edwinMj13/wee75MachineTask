
import 'package:flutter/cupertino.dart';

class EmptyListWidget extends StatelessWidget {
   const EmptyListWidget({
    super.key,
    required this.title,
    required this.icon,
  });
  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return  Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon,size: 100,),
          Text(title),
        ],
      ),
    );
  }
}
