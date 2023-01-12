class Driver {
  String id;
  final String Fname;
  final String Lname;
  final String dashcam_id;
  final String dashcam_username;
  final String dashcam_pass;
  final String rtsp_url;
  final String email;
  final String hash_pass;
  final String phone_number;
  final bool phoneVerfied;

  Driver(
      {this.id = '',
      required this.Fname,
      required this.Lname,
      required this.dashcam_id,
      required this.dashcam_username,
      required this.dashcam_pass,
      required this.rtsp_url,
      required this.email,
      required this.hash_pass,
      required this.phone_number,
      required this.phoneVerfied});

  Map<String, dynamic> toJsonD() => {
        'id': id,
        'Fname': Fname,
        'Lname': Lname,
        'dashcam_id': dashcam_id,
        'dashcam_username': dashcam_username,
        'dashcam_pass': dashcam_pass,
        'rtsp_url': rtsp_url,
        'email': email,
        'hash_pass': hash_pass,
        'phone_number': phone_number,
        'phoneVerfied': phoneVerfied,
      };

  static Driver fromJsonD(Map<String, dynamic> json) => Driver(
      id: json['id'],
      Fname: json['Fname'],
      Lname: json['Lname'],
      dashcam_id: json['dashcam_id'],
      dashcam_username: json['dashcam_username'],
      dashcam_pass: json['dashcam_pass'],
      rtsp_url: json['rtsp_url'],
      email: json['email'],
      hash_pass: json['hash_pass'],
      phone_number: json['phone_number'],
      phoneVerfied: json['phoneVerfied']);
}
