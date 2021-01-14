import 'package:flutter/material.dart';
import 'package:anime_tv_app/style/theme.dart' as Style;

class BuildError {
  static Widget buildErrorWidget(String error, {Function retry}){
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Icon(Icons.wifi_off, color: Colors.white, size: 50),
              ),
            ),
            SizedBox(height: 20),
            Text("Connection Lost", style: TextStyle(fontSize: 18, letterSpacing: 2, color: Colors.white, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text(
                "Please check your internet connection and try again.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.white,letterSpacing: 0.7, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            FlatButton(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                color: Style.Colors.secondColor,
                child: Text("Retry"),
              onPressed: retry,
            )
          ],
        ));
  }
}