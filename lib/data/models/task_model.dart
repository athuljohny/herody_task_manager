import '../../domain/entities/task_entity.dart';

class SubTaskModel extends SubTaskEntity {
  SubTaskModel({required super.id, required super.title, super.isCompleted});

  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title, 'isCompleted': isCompleted};
  }

  factory SubTaskModel.fromMap(Map<dynamic, dynamic> map) {
    return SubTaskModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      isCompleted: map['isCompleted'] ?? false,
    );
  }

  factory SubTaskModel.fromEntity(SubTaskEntity entity) {
    return SubTaskModel(
      id: entity.id,
      title: entity.title,
      isCompleted: entity.isCompleted,
    );
  }
}

class TaskModel extends TaskEntity {
  TaskModel({
    super.id,
    required super.title,
    required super.description,
    super.isCompleted,
    required super.createdAt,
    super.priority,
    super.dueDate,
    super.recurrence,
    super.category,
    super.tags,
    super.notes,
    super.attachmentUrl,
    super.subTasks,
    super.orderIndex,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'createdAt': createdAt.toIso8601String(),
      'priority': priority,
      'dueDate': dueDate?.toIso8601String(),
      'recurrence': recurrence,
      'category': category,
      'tags': tags,
      'notes': notes,
      'attachmentUrl': attachmentUrl,
      'subTasks': subTasks
          .map((e) => SubTaskModel.fromEntity(e).toMap())
          .toList(),
      'orderIndex': orderIndex,
    };
  }

  factory TaskModel.fromMap(String id, Map<dynamic, dynamic> map) {
    List<SubTaskEntity> parsedSubTasks = [];
    if (map['subTasks'] != null) {
      final list = map['subTasks'] as List<dynamic>;
      parsedSubTasks = list
          .map((e) => SubTaskModel.fromMap(e as Map<dynamic, dynamic>))
          .toList();
    }

    return TaskModel(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      isCompleted: map['isCompleted'] ?? false,
      createdAt: DateTime.parse(
        map['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      priority: map['priority'] ?? 'medium',
      dueDate: map['dueDate'] != null
          ? DateTime.tryParse(map['dueDate'])
          : null,
      recurrence: map['recurrence'] ?? 'none',
      category: map['category'] ?? 'General',
      tags: map['tags'] != null ? List<String>.from(map['tags']) : [],
      notes: map['notes'] ?? '',
      attachmentUrl: map['attachmentUrl'],
      subTasks: parsedSubTasks,
      orderIndex: map['orderIndex'] ?? 0,
    );
  }

  factory TaskModel.fromEntity(TaskEntity entity) {
    return TaskModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      isCompleted: entity.isCompleted,
      createdAt: entity.createdAt,
      priority: entity.priority,
      dueDate: entity.dueDate,
      recurrence: entity.recurrence,
      category: entity.category,
      tags: entity.tags,
      notes: entity.notes,
      attachmentUrl: entity.attachmentUrl,
      subTasks: entity.subTasks,
      orderIndex: entity.orderIndex,
    );
  }
}
