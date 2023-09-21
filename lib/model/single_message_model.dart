class MessageModel {
  final String category;
  final String value;

  MessageModel({
    required this.category,
    required this.value,
  });

  static MessageModel fromJson(json) => MessageModel(
        category: json['category'],
        value: json['value'],
      );
}

List<MessageModel> getList() {
  const variant = [
    {
      "category": "Initated by",
      "value": "Prakash Jaganathan",
    },
    {"category": "User Category", "value": "Parent"},
    {"category": "initated on", "value": "02 November "},
    {"category": "Approved by", "value": "Aswin"},
    {"category": "User Category", "value": "teacher"},
    {"category": "Area", "value": "maths"},
    {"category": "Approved at ", "value": "02 November  "},
    {"category": "Deleted by", "value": "N/A"},
    {"category": "Deleted on", "value": "N/A"},
    {"category": "initlized on", "value": "N/A"},
  ];

  return variant.map<MessageModel>(MessageModel.fromJson).toList();
}

List<MessageModel> getPendingList() {
  const variant = [
    {"category": "Initated by", "value": "Prakash Jaganathan"},
    {"category": "User Category", "value": "Parent"},
    {"category": "initated on", "value": "02 November "},
    {"category": "Approved by", "value": "N/A"},
    {"category": "User Category", "value": "N/A"},
    {"category": "Area", "value": "N/A"},
    {"category": "Approved at ", "value": "N/A  "},
    {"category": "Deleted by", "value": "N/A"},
    {"category": "Deleted on", "value": "N/A"},
    {"category": "initlized on", "value": "N/A"},
  ];

  return variant.map<MessageModel>(MessageModel.fromJson).toList();
}
