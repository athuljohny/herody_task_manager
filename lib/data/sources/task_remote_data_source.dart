import 'package:dio/dio.dart';
import '../../core/network/dio_client.dart';
import '../../core/utils/app_constants.dart';
import '../models/task_model.dart';

class TaskRemoteDataSource {
  final Dio _dio;
  final String _baseUrl = AppConstants.firebaseRealtimeDbUrl;

  TaskRemoteDataSource(DioClient dioClient) : _dio = dioClient.dio;

  Future<List<TaskModel>> getTasks(String userId) async {
    try {
      final response = await _dio.get('$_baseUrl/tasks/$userId.json');
      final data = response.data;
      if (data == null) return [];

      List<TaskModel> tasks = [];
      (data as Map<String, dynamic>).forEach((id, value) {
        tasks.add(TaskModel.fromMap(id, value));
      });
      return tasks;
    } on DioException catch (e) {
      throw Exception('Failed to load tasks: ${e.message}');
    }
  }

  Future<void> addTask(String userId, TaskModel task) async {
    try {
      await _dio.post('$_baseUrl/tasks/$userId.json', data: task.toMap());
    } on DioException catch (e) {
      throw Exception('Failed to add task: ${e.message}');
    }
  }

  Future<void> updateTask(String userId, TaskModel task) async {
    try {
      await _dio.patch(
        '$_baseUrl/tasks/$userId/${task.id}.json',
        data: task.toMap(),
      );
    } on DioException catch (e) {
      throw Exception('Failed to update task: ${e.message}');
    }
  }

  Future<void> deleteTask(String userId, String taskId) async {
    try {
      await _dio.delete('$_baseUrl/tasks/$userId/$taskId.json');
    } on DioException catch (e) {
      throw Exception('Failed to delete task: ${e.message}');
    }
  }
}
