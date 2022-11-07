class Driver {
  String id;
  final String Fname;
  final String Lname;
  final String dashcam_id;
  final String email;
  final String hash_pass;

  Driver(
      {this.id = '',
      required this.Fname,
      required this.Lname,
      required this.dashcam_id,
      required this.email,
      required this.hash_pass});

  Map<String, dynamic> toJsonD() => {
        'id': id,
        'Fname': Fname,
        'Lname': Lname,
        'dashcam_id': dashcam_id,
        'email': email,
        'hash_pass': hash_pass
      };

  static Driver fromJsonD(Map<String, dynamic> json) => Driver(
        id: json['id'],
        Fname: json['Fname'],
        Lname: json['Lname'],
        dashcam_id: json['dashcam_id'],
        email: json['email'],
        hash_pass: json['hash_pass'],
      );
}
