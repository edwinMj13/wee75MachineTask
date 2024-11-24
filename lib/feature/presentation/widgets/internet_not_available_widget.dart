import 'package:flutter/material.dart';

class InternetNotAvailableWidget extends StatelessWidget {
  const InternetNotAvailableWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.signal_wifi_connected_no_internet_4_sharp,size: 80,color: Colors.redAccent,),
          Text(
            "Internet Not Available",
            style: TextStyle(color: Colors.redAccent, fontSize: 18),
          ),
        ],
      ),
    );
  }
}
