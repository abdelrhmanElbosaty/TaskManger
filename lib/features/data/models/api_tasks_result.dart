class ApiTask {
  String? documentId;
  String? title;
  String? description;
  String? type;
  String? createdAt;

  ApiTask({
    this.documentId,
    this.title,
    this.description,
    this.type,
    this.createdAt,
  });

  factory ApiTask.fromJson(Map<String, dynamic> json, String id) => ApiTask(
        documentId: id,
        title: json["title"],
        description: json["content"],
        type: json["type"],
        createdAt: json["created_at"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "content": description,
        "type": type,
        "created_at": createdAt,
      };
}
