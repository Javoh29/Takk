class NotifModel {
  int? id;
  String? title;
  String? body;
  dynamic createdDt;

  NotifModel({this.id, this.title, this.body, this.createdDt});

  factory NotifModel.fromJson(Map<String, dynamic> json) => NotifModel(
        id: json['id'] as int?,
        title: json['title'] as String?,
        body: json['body'] as String?,
        createdDt: json['created_dt'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'body': body,
        'created_dt': createdDt,
      };
}
