import 'package:flutter/material.dart';

//this class is to listen to the value of [_videoPlayerController.value.isPlaying]
//it defines a boolean variable [statCheck] if it is true thenn the stream is palying, else there is an error
class StreamCheck with ChangeNotifier {
  ValueNotifier<bool> statCheckHome = ValueNotifier<bool>(false);
  ValueNotifier<bool> statCheckLink = ValueNotifier<bool>(false);
}

StreamCheck streamCheck = new StreamCheck();
