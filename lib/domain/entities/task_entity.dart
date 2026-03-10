class SubTaskEntity {
  final String id;
  final String title;
  final bool isCompleted;

  SubTaskEntity({
    required this.id,
    required this.title,
    this.isCompleted = false,
  });

  SubTaskEntity copyWith({String? id, String? title, bool? isCompleted}) {
    return SubTaskEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

class TaskEntity {
  final String? id;
  final String title;
  final String description;
  final bool isCompleted;
  final DateTime createdAt;

  // New Feature Fields
  final String priority; // 'low', 'medium', 'high'
  final DateTime? dueDate;
  final String recurrence; // 'none', 'daily', 'weekly', 'monthly'
  final String category;
  final List<String> tags;
  final String notes;
  final String? attachmentUrl;
  final List<SubTaskEntity> subTasks;
  final int orderIndex; // For drag & drop reordering

  TaskEntity({
    this.id,
    required this.title,
    required this.description,
    this.isCompleted = false,
    required this.createdAt,
    this.priority = 'medium',
    this.dueDate,
    this.recurrence = 'none',
    this.category = 'General',
    this.tags = const [],
    this.notes = '',
    this.attachmentUrl,
    this.subTasks = const [],
    this.orderIndex = 0,
  });

  TaskEntity copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
    DateTime? createdAt,
    String? priority,
    DateTime? dueDate,
    String? recurrence,
    String? category,
    List<String>? tags,
    String? notes,
    String? attachmentUrl,
    List<SubTaskEntity>? subTasks,
    int? orderIndex,
  }) {
    return TaskEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      priority: priority ?? this.priority,
      dueDate: dueDate ?? this.dueDate,
      recurrence: recurrence ?? this.recurrence,
      category: category ?? this.category,
      tags: tags ?? this.tags,
      notes: notes ?? this.notes,
      attachmentUrl: attachmentUrl ?? this.attachmentUrl,
      subTasks: subTasks ?? this.subTasks,
      orderIndex: orderIndex ?? this.orderIndex,
    );
  }
}
