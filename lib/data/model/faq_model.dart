

class Faqs {
  Faqs({
    required this.id,
    required this.question,
    required this.answer,
    required this.status,
    required this.createdAt,
  });
  
  Faqs.fromJson(final Map<String, dynamic> json){
    id = json["id"];
    question = json["question"];
    answer = json["answer"];
    status = json["status"];
    createdAt = json["created_at"];
  }
  late final String id;
  late final String question;
  late final String answer;
  late final String status;
  late final String createdAt;

}