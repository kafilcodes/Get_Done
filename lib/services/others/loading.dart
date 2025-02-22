import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black26,
      child: Center(
        child: SpinKitChasingDots(
          color: Theme.of(context).iconTheme.color,
          size: 25,
        ),
      ),
    );
  }
}
