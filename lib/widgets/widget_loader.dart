import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  String texto;

  Loader({this.texto});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircularProgressIndicator(),
          SizedBox(
            height: 10,
          ),
          Text(this.texto)
        ],
      ),
    );
  }
}
