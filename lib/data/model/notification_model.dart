// ignore_for_file: public_member_api_docs, sort_constructors_first

class NotificationDataModel {
  String? id;
  String? title;
  String? message;
  String? type;
  String? typeId;
  String? image;
  String? orderId;
  String? isRead;
  String? dateSent;
  String? duration;

  NotificationDataModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.typeId,
    required this.image,
    required this.orderId,
    required this.isRead,
    required this.dateSent,
    required this.duration,
  });

  factory NotificationDataModel.fromMap(final Map<String, dynamic> map) => NotificationDataModel(
      id: map["id"] as String,
      title: map["title"] as String,
      message: map["message"] as String,
      type: map["type"] as String,
      typeId: map["type_id"] as String,
      image: map["image"] as String,
      orderId: map["order_id"] as String,
      isRead: map["is_readed"] as String,
      dateSent: map["date_sent"] as String,
      duration: map["duration"] as String,
    );

  NotificationDataModel.fromJson(final Map<String, dynamic> map) {
    id = map['id'] ?? '0';
    title = map['title'].toString();
    message = map['message'].toString();
    type = map['type'].toString();
    typeId = map['type_id'].toString();
    image = map['image'].toString();
    orderId = map['order_id'].toString();
    isRead = map['is_readed'].toString();
    dateSent = map['date_sent'].toString();
    duration = map['duration'].toString();
  }
}
