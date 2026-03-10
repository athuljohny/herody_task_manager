import '../entities/task_entity.dart';
import '../repositories/task_repository.dart';

class GetTasksUseCase {
  final TaskRepository repository;
  GetTasksUseCase(this.repository);

  Future<List<TaskEntity>> execute(String userId) {
    return repository.getTasks(userId);
  }
}

class AddTaskUseCase {
  final TaskRepository repository;
  AddTaskUseCase(this.repository);

  Future<void> execute(String userId, TaskEntity task) {
    return repository.addTask(userId, task);
  }
}

class UpdateTaskUseCase {
  final TaskRepository repository;
  UpdateTaskUseCase(this.repository);

  Future<void> execute(String userId, TaskEntity task) {
    return repository.updateTask(userId, task);
  }
}

class DeleteTaskUseCase {
  final TaskRepository repository;
  DeleteTaskUseCase(this.repository);

  Future<void> execute(String userId, String taskId) {
    return repository.deleteTask(userId, taskId);
  }
}
