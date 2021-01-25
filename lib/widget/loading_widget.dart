import 'package:flutter/material.dart';
import 'package:anime_tv_app/style/theme.dart' as Style;

class Loading {
  static Widget buildLoadingWidget(){
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 25.0,
              width: 25.0,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Style.Colors.secondColor),
                strokeWidth: 4.0,
              ),
            )
          ],
        ));
  }
}