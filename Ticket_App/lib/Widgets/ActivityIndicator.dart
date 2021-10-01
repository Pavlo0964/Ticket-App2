import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ActivityIndicator extends StatelessWidget {
  final size;
  ActivityIndicator({this.size = 40});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SpinKitWave(
        color: Theme.of(context).primaryColor,
        size: 40,
      ),
    );
  }
}
