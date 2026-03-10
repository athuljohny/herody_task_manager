import 'dart:convert';

class TaskModel {
  String? id;
  String title;
  String description;
  bool isCompleted;
  DateTime createdAt;

  TaskModel({
    this.id,
    required this.title,
    required this.description,
    this.isCompleted = false,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory TaskModel.fromMap(String id, Map<dynamic, dynamic> map) {
    return TaskModel(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      isCompleted: map['isCompleted'] ?? false,
      createdAt: DateTime.parse(
        map['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory TaskModel.fromJson(String id, String source) =>
      TaskModel.fromMap(id, json.decode(source));
}
