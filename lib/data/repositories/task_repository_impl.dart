import '../../domain/entities/task_entity.dart';
import '../../domain/repositories/task_repository.dart';
import '../models/task_model.dart';
import '../sources/task_remote_data_source.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskRemoteDataSource remoteDataSource;

  TaskRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<TaskEntity>> getTasks(String userId) async {
    return await remoteDataSource.getTasks(userId);
  }

  @override
  Future<void> addTask(String userId, TaskEntity task) async {
    await remoteDataSource.addTask(userId, TaskModel.fromEntity(task));
  }

  @override
  Future<void> updateTask(String userId, TaskEntity task) async {
    await remoteDataSource.updateTask(userId, TaskModel.fromEntity(task));
  }

  @override
  Future<void> deleteTask(String userId, String taskId) async {
    await remoteDataSource.deleteTask(userId, taskId);
  }
}
