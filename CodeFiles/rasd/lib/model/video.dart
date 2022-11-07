import 'package:cloud_firestore/cloud_firestore.dart';

class video {
  String id;
  final String video_url;

  video({
    this.id = '',
    required this.video_url,
  });

  video.fromSnapShot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : id = snapshot.id,
        video_url = snapshot['video_url'];

  Map<String, dynamic> toJsonD() => {
        'id': id,
        'video_url': video_url,
      };
  static video fromJsonD(Map<String, dynamic> json) => video(
        id: json['id'],
        video_url: json['video_url'],
      );
}
