class Payment {

  Payment(
      {this.id,
      this.userId,
      this.orderId,
      this.type,
      this.txnId,
      this.amount,
      this.status,
      this.message,});

  Payment.fromJson(final Map<String, dynamic> json) {
    id = json["id"].toString();
    userId = json["user_id"].toString();
    orderId = json["order_id"].toString();
    type = json["type"].toString();
    txnId = json["txn_id"].toString();
    amount = json["amount"].toString();
    status = json["status"].toString();
    message = json["message"].toString();
  }
  String? id;
  String? userId;
  String? orderId;
  String? type;
  String? txnId;
  String? amount;
  String? status;
  String? message;
}
