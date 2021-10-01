class User {
  int id;
  String username;
  String password;

  User({this.username, this.password, this.id});

  User.fromMap(dynamic obj) {
    this.username = obj['username'];
    this.password = obj['password'];
    this.id = obj['id'];
  }

  String get userName => username;
  int get iD => id;
  String get passWord => password;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["username"] = username;
    map["password"] = password;
    return map;
  }
}
