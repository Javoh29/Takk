import 'author.dart';
import 'file_model.dart';

class LastMessage {
  int? id;
  String? text;
  dynamic orderId;
  int? createdDt;
  Author? author;
  List<FileModel>? files;
  bool? isRead;

  LastMessage({
    this.id,
    this.text,
    this.orderId,
    this.createdDt,
    this.author,
    this.files,
    this.isRead,
  });

  factory LastMessage.fromJson(Map<String, dynamic> json) => LastMessage(
        id: json['id'] as int?,
        text: json['text'] as String?,
        orderId: json['order_id'] as dynamic,
        createdDt: json['created_dt'] as int?,
        author: json['author'] == null
            ? null
            : Author.fromJson(json['author'] as Map<String, dynamic>),
        files: (json['files'] as List<dynamic>?)
            ?.map((e) => FileModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        isRead: json['is_read'] as bool?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'text': text,
        'order_id': orderId,
        'created_dt': createdDt,
        'author': author?.toJson(),
        'files': files?.map((e) => e.toJson()).toList(),
        'is_read': isRead,
      };

  LastMessage copyWith({
    int? id,
    String? text,
    dynamic orderId,
    int? createdDt,
    Author? author,
    List<FileModel>? files,
    bool? isRead,
  }) {
    return LastMessage(
      id: id ?? this.id,
      text: text ?? this.text,
      orderId: orderId ?? this.orderId,
      createdDt: createdDt ?? this.createdDt,
      author: author ?? this.author,
      files: files ?? this.files,
      isRead: isRead ?? this.isRead,
    );
  }
}
