import 'package:get/get.dart';
import '../core/network/dio_client.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../data/repositories/task_repository_impl.dart';
import '../data/sources/task_remote_data_source.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/repositories/task_repository.dart';
import '../domain/usecases/task_usecases.dart';
import '../presentation/controllers/auth_controller.dart';
import '../presentation/controllers/task_controller.dart';
import '../presentation/controllers/theme_controller.dart';

class DependencyInjection {
  static void init() {
    // Theme
    Get.put(ThemeController(), permanent: true);

    // Network
    Get.lazyPut(() => DioClient(), fenix: true);

    // Data Sources
    Get.lazyPut(() => TaskRemoteDataSource(Get.find()), fenix: true);

    // Repositories
    Get.lazyPut<AuthRepository>(() => AuthRepositoryImpl(), fenix: true);
    Get.lazyPut<TaskRepository>(
      () => TaskRepositoryImpl(remoteDataSource: Get.find()),
      fenix: true,
    );

    // Use Cases
    Get.lazyPut(() => GetTasksUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => AddTaskUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => UpdateTaskUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => DeleteTaskUseCase(Get.find()), fenix: true);

    // Controllers
    Get.put(AuthController(Get.find()), permanent: true);
    Get.put(
      TaskController(Get.find(), Get.find(), Get.find(), Get.find()),
      permanent: true,
    );
  }
}
