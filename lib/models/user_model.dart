class User {
  int id;
  String username;
  String nickname;
  String password;
  String socketId;

  User ({this.id, this.nickname, this.password, this.username, this.socketId});

  static User fromMap(Map map) {
    return User(
      id: map.containsKey('id')?map['id']:0,
      username: map.containsKey('username')?map['username']:"",
      nickname: map.containsKey('nickname')?map['nickname']:"",
      password: map.containsKey('password')?map['password']:"",
      socketId: map.containsKey('socket_id')?map['socket_id']:""
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": this.id,
      "username": this.username,
      "nickname": this.nickname,
      "password": this.password,
      "socket_id": this.socketId
    };
  }
}