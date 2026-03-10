import 'package:get/get.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/usecases/task_usecases.dart';

class TaskController extends GetxController {
  final GetTasksUseCase _getTasksUseCase;
  final AddTaskUseCase _addTaskUseCase;
  final UpdateTaskUseCase _updateTaskUseCase;
  final DeleteTaskUseCase _deleteTaskUseCase;

  TaskController(
    this._getTasksUseCase,
    this._addTaskUseCase,
    this._updateTaskUseCase,
    this._deleteTaskUseCase,
  );

  var tasks = <TaskEntity>[].obs;
  var isLoading = false.obs;

  // Search & Filter State
  var searchQuery = ''.obs;
  var selectedPriorityFilter = 'All'.obs;
  var selectedSortOption = 'Due Date'.obs;
  var selectedStatusFilter = 'All'.obs; // 'All', 'Pending', 'Completed'

  @override
  void onInit() {
    super.onInit();
  }

  // Dynamic getter for UI that applies search, filter, and sorting automatically
  List<TaskEntity> get filteredAndSortedTasks {
    List<TaskEntity> result = tasks.toList();

    // 1. Search Query Filter
    if (searchQuery.value.isNotEmpty) {
      result = result
          .where(
            (task) =>
                task.title.toLowerCase().contains(
                  searchQuery.value.toLowerCase(),
                ) ||
                task.description.toLowerCase().contains(
                  searchQuery.value.toLowerCase(),
                ),
          )
          .toList();
    }

    // 2. Status Filter
    if (selectedStatusFilter.value == 'Pending') {
      result = result.where((task) => !task.isCompleted).toList();
    } else if (selectedStatusFilter.value == 'Completed') {
      result = result.where((task) => task.isCompleted).toList();
    }

    // 3. Priority Filter
    if (selectedPriorityFilter.value != 'All') {
      result = result
          .where(
            (task) =>
                task.priority.toLowerCase() ==
                selectedPriorityFilter.value.toLowerCase(),
          )
          .toList();
    }

    // 4. Sorting
    switch (selectedSortOption.value) {
      case 'Date Created':
        result.sort(
          (a, b) => b.createdAt.compareTo(a.createdAt),
        ); // Newest first
        break;
      case 'Due Date':
        result.sort((a, b) {
          if (a.dueDate == null && b.dueDate == null) return 0;
          if (a.dueDate == null) return 1; // Put null due dates at the bottom
          if (b.dueDate == null) return -1;
          return a.dueDate!.compareTo(b.dueDate!); // Closest due date first
        });
        break;
      case 'Priority':
        int priorityValue(String p) {
          if (p == 'high') return 3;
          if (p == 'medium') return 2;
          return 1;
        }
        result.sort(
          (a, b) =>
              priorityValue(b.priority).compareTo(priorityValue(a.priority)),
        );
        break;
      case 'Alphabetical':
        result.sort(
          (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
        );
        break;
      case 'Custom Order': // For Drag & Drop
        result.sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
        break;
    }

    return result;
  }

  Future<void> fetchTasks(String userId) async {
    isLoading(true);
    try {
      final fetchedTasks = await _getTasksUseCase.execute(userId);
      tasks.assignAll(fetchedTasks);
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch tasks: $e");
    } finally {
      isLoading(false);
    }
  }

  Future<void> addTask(String userId, TaskEntity task) async {
    try {
      await _addTaskUseCase.execute(userId, task);
      await fetchTasks(userId);
    } catch (e) {
      Get.snackbar("Error", "Failed to add task: $e");
    }
  }

  Future<void> toggleTaskStatus(String userId, TaskEntity task) async {
    final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
    try {
      // Optimistic update for instant UI response
      final index = tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        tasks[index] = updatedTask;
      }
      await _updateTaskUseCase.execute(userId, updatedTask);
    } catch (e) {
      await fetchTasks(userId); // Revert on failure
      Get.snackbar("Error", "Failed to update task: $e");
    }
  }

  Future<void> updateTask(String userId, TaskEntity task) async {
    try {
      // Optimistic update
      final index = tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        tasks[index] = task;
      }
      await _updateTaskUseCase.execute(userId, task);
      // Wait for cloud confirmation without disrupting the UI
      fetchTasks(userId);
    } catch (e) {
      Get.snackbar("Error", "Failed to update task: $e");
    }
  }

  Future<void> deleteTask(String userId, String taskId) async {
    try {
      // Optimistic Delete for Swipe-To-Delete instant feedback
      tasks.removeWhere((t) => t.id == taskId);
      await _deleteTaskUseCase.execute(userId, taskId);
    } catch (e) {
      await fetchTasks(userId); // Revert on failure
      Get.snackbar("Error", "Failed to delete task: $e");
    }
  }

  // Drag and drop reordering function
  Future<void> reorderTasks(String userId, int oldIndex, int newIndex) async {
    if (selectedSortOption.value != 'Custom Order') {
      selectedSortOption.value = 'Custom Order'; // Force mode swap
    }

    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

    // Operate on the sorted list
    List<TaskEntity> workingList = List.from(filteredAndSortedTasks);
    final TaskEntity item = workingList.removeAt(oldIndex);
    workingList.insert(newIndex, item);

    // Update states locally to feel instant
    for (int i = 0; i < workingList.length; i++) {
      final updated = workingList[i].copyWith(orderIndex: i);
      final realIndex = tasks.indexWhere((t) => t.id == updated.id);
      if (realIndex != -1) tasks[realIndex] = updated;
    }
    tasks.refresh();

    // Sync to DB in the background
    try {
      for (int i = 0; i < workingList.length; i++) {
        final updatedTask = workingList[i].copyWith(orderIndex: i);
        await _updateTaskUseCase.execute(userId, updatedTask);
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to synchronize order: $e");
    }
  }
}
