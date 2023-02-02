import 'company.dart';
import 'last_message.dart';

class MessageModel {
  int? id;
  Company? company;
  dynamic order;
  int? createdDt;
  String? title;
  String? image;
  LastMessage? lastMessage;
  int? unreadMessagesCount;

  MessageModel({
    this.id,
    this.company,
    this.order,
    this.createdDt,
    this.title,
    this.image,
    this.lastMessage,
    this.unreadMessagesCount,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
        id: json['id'] as int?,
        company: json['company'] == null
            ? null
            : Company.fromJson(json['company'] as Map<String, dynamic>),
        order: json['order'] as dynamic,
        createdDt: json['created_dt'] as int?,
        title: json['title'] as String?,
        image: json['image'] as String?,
        lastMessage: json['last_message'] == null
            ? null
            : LastMessage.fromJson(
                json['last_message'] as Map<String, dynamic>),
        unreadMessagesCount: json['unread_messages_count'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'company': company?.toJson(),
        'order': order,
        'created_dt': createdDt,
        'title': title,
        'image': image,
        'last_message': lastMessage?.toJson(),
        'unread_messages_count': unreadMessagesCount,
      };

  MessageModel copyWith({
    int? id,
    Company? company,
    dynamic order,
    int? createdDt,
    String? title,
    String? image,
    LastMessage? lastMessage,
    int? unreadMessagesCount,
  }) {
    return MessageModel(
      id: id ?? this.id,
      company: company ?? this.company,
      order: order ?? this.order,
      createdDt: createdDt ?? this.createdDt,
      title: title ?? this.title,
      image: image ?? this.image,
      lastMessage: lastMessage ?? this.lastMessage,
      unreadMessagesCount: unreadMessagesCount ?? this.unreadMessagesCount,
    );
  }
}
