import 'dart:io';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:rasd/model/video.dart';
import 'package:rasd/streamStatucCheck.dart';

class LiveStreamScreenLink extends StatefulWidget {
  //rtsp url
  final String url;
  final String uid;
  final bool recordStream;
  const LiveStreamScreenLink(
      {super.key,
      required this.url,
      required this.uid,
      required this.recordStream});

  @override
  _liveStreamScreenLink createState() => _liveStreamScreenLink();
}

class _liveStreamScreenLink extends State<LiveStreamScreenLink> {
  Timer? timer; //timer for start timer method
  Timer? _timer; //timer for count down
  Timer? _streamUpdate; //timer to check the status of out application
  int _start = 55; //length of video
  bool isRec = false; // true if it is recording, false if it is not recording
  bool? isLive; // true if it is live, false if it is not
  bool? isLive2;
  VlcPlayerController _videoPlayerController =
      VlcPlayerController.network(''); //initilze video controller
  // bool _isPlaying = true; //stop or play stream

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VlcPlayerController.network(
      widget.url,
      hwAcc: HwAcc.full,
      autoPlay: true,
      options: VlcPlayerOptions(video: VlcVideoOptions(['--drop-late-frames'])),
    );

    //After initializing the video player controller call the isStreamLive method to check if the stream is playing
    _streamUpdate = Timer.periodic(Duration(seconds: 1), (_) => isStreamLive());

    print("widget.recordStream");
    print(widget.recordStream);

    if (widget.recordStream) {
      // if ture this mean that the stream will be recorded
      //repete recording every minute
      timer = Timer.periodic(
        Duration(seconds: 60),
        (_) => startTimer(),
      );
    }
  }

  //check the status of the stream
  void isStreamLive() {
    setState(() {
      isLive = _videoPlayerController.value.isPlaying;
    });
    streamCheck.statCheckLink.value = isLive!;
    print('------------LinkPage------------is it playing? $isLive');
  }

  void startRec() {
    print('--------- in start ------------');
    if (_videoPlayerController.value.recordPath != '') {
      print('path:'); //get the path of the recorded video
      print(_videoPlayerController.value.recordPath);
      //upload file to storage
      uploadFile(_videoPlayerController.value.recordPath);
    }
    //to see the status of the recording
    setState(() {
      isRec = true;
    });
    //start recording
    _videoPlayerController.startRecording('');
  }

  void stopRec() async {
    print('--------- in stop ------------');
    //to see the status of the recording
    setState(() {
      isRec = false;
    });
    //stop recording
    _videoPlayerController.stopRecording();
  }

  void startTimer() {
    _start = 55;
    //call start recording method
    startRec();
    //decrement _start each second
    const oneSec = const Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        //if the recording reached the end stop recording
        if (_start == 0) {
          stopRec();
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--; //decrement by one second
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    timer?.cancel();
    _streamUpdate?.cancel();
    super.dispose();
  }

  Future uploadFile(String pa) async {
    print('--------- in upload ------------');
    final path = widget.uid + '/$pa';
    final file = File(pa);
    print("Print file" + file.toString());
    final ref = FirebaseStorage.instance.ref().child(path);
    ref.putFile(file);
    await Future.delayed(Duration(seconds: 2));
    print('--------- delete ------------');
    var fileD = File(pa);
    fileD.delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          VlcPlayer(
            controller: _videoPlayerController,
            aspectRatio: 15 / 8,
            placeholder: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
          // Row(
          //   children: [
          // TextButton(
          //     //this is the play and stop stram button
          //     onPressed: () {
          //       if (_isPlaying) {
          //         setState(() {
          //           _isPlaying = false;
          //         });
          //         _videoPlayerController.pause();
          //       } else {
          //         setState(() {
          //           _isPlaying = true;
          //         });
          //         _videoPlayerController.play();
          //       }
          //     },
          //     child: Icon(
          //       _isPlaying ? Icons.pause : Icons.play_arrow,
          //       size: 28,
          //       color: Colors.black,
          //     )),
          // Icon(
          //   isRec
          //       ? Icons.emergency_recording_rounded
          //       : Icons.emergency_recording_outlined,
          //   size: 28,
          //   color: Colors.black,
          // ),
          // TextButton(
          //     onPressed: () {
          //       setState(() {
          //         timer!.cancel();
          //       });
          //     },
          //     child: Icon(
          //       Icons.close,
          //       size: 28,
          //       color: Colors.black,
          //     ))
          //  ],
          // ),
        ],
      ),
    );
  }
}
