class Author {
  int? id;
  String? username;
  String? phone;
  String? avatar;
  bool? isOnline;
  String? lastConnect;

  Author({
    this.id,
    this.username,
    this.phone,
    this.avatar,
    this.isOnline,
    this.lastConnect,
  });

  factory Author.fromJson(Map<String, dynamic> json) => Author(
        id: json['id'] as int?,
        username: json['username'] as String?,
        phone: json['phone'] as String?,
        avatar: json['avatar'] as String?,
        isOnline: json['is_online'] as bool?,
        lastConnect: json['last_connect'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'phone': phone,
        'avatar': avatar,
        'is_online': isOnline,
        'last_connect': lastConnect,
      };

  Author copyWith({
    int? id,
    String? username,
    String? phone,
    String? avatar,
    bool? isOnline,
    String? lastConnect,
  }) {
    return Author(
      id: id ?? this.id,
      username: username ?? this.username,
      phone: phone ?? this.phone,
      avatar: avatar ?? this.avatar,
      isOnline: isOnline ?? this.isOnline,
      lastConnect: lastConnect ?? this.lastConnect,
    );
  }
}
