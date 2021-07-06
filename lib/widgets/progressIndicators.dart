import 'package:flutter/material.dart';

class ProgressIndicators {

  static circularIndicator() {
      return Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
            ],
          ),
        ),
      );
    }

    static linearIndicator() {
      return Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LinearProgressIndicator(),
            ],
          ),
        ),
      );
    }
}