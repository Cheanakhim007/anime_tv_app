import 'package:flutter/material.dart';

class BuildError {
  static Widget buildErrorWidget(String error){
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Error occured: $error", style: TextStyle(color: Colors.white, fontSize: 14),),
          ],
        ));
  }
}