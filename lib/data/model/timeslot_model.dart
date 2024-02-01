class AllSlots {

  AllSlots({this.time, this.isAvailable, this.message});

  AllSlots.fromJson(final Map<String, dynamic> json) {
    time = json["time"];
    isAvailable = json["is_available"];
    message = json["message"];
  }
  String? time;
  String? message;
  int? isAvailable;
}
