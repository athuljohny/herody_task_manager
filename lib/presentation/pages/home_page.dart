import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import '../../domain/entities/task_entity.dart';
import '../controllers/auth_controller.dart';
import '../controllers/task_controller.dart';
import '../controllers/theme_controller.dart';
import 'add_task_page.dart';
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthController _authController = Get.find<AuthController>();
  final TaskController _taskController = Get.find<TaskController>();
  final ThemeController _themeController = Get.find<ThemeController>();

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (_authController.user != null) {
      _taskController.fetchTasks(_authController.user!.uid);
    }
  }

  Color _getPriorityColor(String priority) {
    if (priority == 'high') return Colors.redAccent;
    if (priority == 'low') return Colors.greenAccent;
    return Colors.orangeAccent;
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF121212)
          : const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(isDark),
            _buildProgressCard(),
            _buildSearchBar(isDark),
            _buildFiltersRow(isDark),
            Expanded(
              child: Obx(() {
                if (_taskController.isLoading.value &&
                    _taskController.tasks.isEmpty) {
                  return _buildSkeletonLoader(isDark);
                }

                final tasks = _taskController.filteredAndSortedTasks;

                if (tasks.isEmpty) {
                  return _buildEmptyState();
                }

                return _buildTaskList(tasks, isDark);
              }),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => const AddTaskPage()),
        backgroundColor: const Color(0xFF5E60CE), // Match reference color
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Obx(() {
              final user = _authController.user;
              final name =
                  user?.email?.split('@')[0] ?? user?.displayName ?? 'User';

              // Calculate remaining tasks for today
              final remaining = _taskController.tasks
                  .where((t) => !t.isCompleted)
                  .length;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hello, $name 👋",
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "You have $remaining tasks remaining for today.",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                ],
              );
            }),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () => _themeController.toggleTheme(),
                icon: Obx(
                  () => Icon(
                    _themeController.isDarkMode
                        ? Icons.light_mode
                        : Icons.dark_mode,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ),
              const SizedBox(width: 5),
              InkWell(
                onTap: () => Get.to(() => const ProfilePage()),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF5E60CE).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.person_outline,
                    color: Color(0xFF5E60CE),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard() {
    return Obx(() {
      final total = _taskController.tasks.length;
      final completed = _taskController.tasks
          .where((t) => t.isCompleted)
          .length;
      final percent = total == 0 ? 0.0 : completed / total;
      final percentInt = (percent * 100).toInt();

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: const LinearGradient(
            colors: [Color(0xFF6B48FF), Color(0xFF8B5CF6)], // Purple/blue blend
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6B48FF).withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "TODAY'S PROGRESS",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                    fontSize: 12,
                  ),
                ),
                Text(
                  "$percentInt%",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: percent,
                backgroundColor: Colors.white.withOpacity(0.3),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                minHeight: 6,
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildSearchBar(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: isDark
              ? Border.all(color: Colors.grey[800]!)
              : Border.all(color: Colors.grey[300]!),
          boxShadow: isDark
              ? []
              : [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
        ),
        child: TextField(
          controller: _searchController,
          onChanged: (val) => _taskController.searchQuery.value = val,
          decoration: InputDecoration(
            hintText: "Search your tasks...",
            prefixIcon: const Icon(Icons.search, color: Colors.grey),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 15),
            hintStyle: TextStyle(
              color: isDark ? Colors.grey[500] : Colors.grey[400],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFiltersRow(bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Custom Tab Bar for Status
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Obx(
                () => Row(
                  children: ['All', 'Pending', 'Completed'].map((status) {
                    final isSelected =
                        _taskController.selectedStatusFilter.value == status;
                    return GestureDetector(
                      onTap: () =>
                          _taskController.selectedStatusFilter.value = status,
                      child: Container(
                        margin: const EdgeInsets.only(right: 15),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: isSelected
                            ? BoxDecoration(
                                color: isDark
                                    ? const Color(0xFF2C2C2C)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: isDark
                                    ? []
                                    : [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.15),
                                          blurRadius: 5,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                              )
                            : const BoxDecoration(),
                        child: Text(
                          status,
                          style: GoogleFonts.poppins(
                            color: isSelected
                                ? const Color(0xFF5E60CE)
                                : Colors.grey[500],
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.w500,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),

          // Sorting Dropdown - always shows "Sort by Due" label
          Obx(
            () => DropdownButton<String>(
              value: _taskController.selectedSortOption.value,
              underline: const SizedBox(),
              icon: const SizedBox.shrink(),
              selectedItemBuilder: (context) =>
                  ['Due Date', 'Priority', 'Alphabetical', 'Custom Order']
                      .map(
                        (_) => Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.filter_list,
                              size: 16,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Sort by Due',
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      )
                      .toList(),
              items: ['Due Date', 'Priority', 'Alphabetical', 'Custom Order']
                  .map(
                    (s) => DropdownMenuItem(
                      value: s,
                      child: Text(
                        s == 'Custom Order' ? 'Custom Order' : 'Sort by $s',
                        style: GoogleFonts.poppins(fontSize: 13),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (val) =>
                  _taskController.selectedSortOption.value = val!,
              style: GoogleFonts.poppins(color: Colors.grey[600]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.assignment_outlined, size: 100, color: Colors.grey[350]),
          const SizedBox(height: 20),
          Text(
            "No tasks found!",
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Try adjusting filters or add a new task.",
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[500]),
          ),
          const SizedBox(height: 50), // To avoid covering by FAB
        ],
      ),
    );
  }

  Widget _buildTaskList(List<TaskEntity> tasks, bool isDark) {
    return ReorderableListView.builder(
      padding: const EdgeInsets.only(top: 10, bottom: 100, left: 16, right: 16),
      itemCount: tasks.length,
      onReorder: (oldInd, newInd) {
        _taskController.reorderTasks(_authController.user!.uid, oldInd, newInd);
      },
      itemBuilder: (context, index) {
        final task = tasks[index];
        return Dismissible(
          key: ValueKey(task.id),
          direction: DismissDirection.endToStart,
          background: Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.redAccent,
              borderRadius: BorderRadius.circular(15),
            ),
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          onDismissed: (direction) {
            _taskController.deleteTask(_authController.user!.uid, task.id!);
          },
          child: Card(
            key: ValueKey(task.id),
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: isDark
                  ? BorderSide(color: Colors.grey[800]!)
                  : BorderSide(color: Colors.grey[200]!),
            ),
            elevation: isDark ? 0 : 0, // Flat design with border
            color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: Checkbox(
                value: task.isCompleted,
                shape: const CircleBorder(),
                activeColor: const Color(0xFF5E60CE),
                onChanged: (val) => _taskController.toggleTaskStatus(
                  _authController.user!.uid,
                  task,
                ),
              ),
              title: Row(
                children: [
                  Expanded(
                    child: Text(
                      task.title,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                        color: task.isCompleted ? Colors.grey : null,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getPriorityColor(task.priority).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      task.priority.toUpperCase(),
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        color: _getPriorityColor(task.priority),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 5),
                  if (task.description.isNotEmpty)
                    Text(
                      task.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.folder_open,
                        size: 14,
                        color: Colors.grey[500],
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          task.category,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                      ),
                      if (task.dueDate != null) ...[
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color:
                              task.dueDate!.isBefore(DateTime.now()) &&
                                  !task.isCompleted
                              ? Colors.red
                              : Colors.grey[500],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          DateFormat('MMM dd').format(task.dueDate!),
                          style: TextStyle(
                            fontSize: 12,
                            color:
                                task.dueDate!.isBefore(DateTime.now()) &&
                                    !task.isCompleted
                                ? Colors.red
                                : Colors.grey[500],
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
              trailing: IconButton(
                icon: Icon(
                  Icons.delete_outline,
                  size: 20,
                  color: Colors.grey[400],
                ),
                onPressed: () {
                  if (task.id != null) {
                    _taskController.deleteTask(
                      _authController.user!.uid,
                      task.id!,
                    );
                  }
                },
              ),
              onTap: () => Get.to(() => AddTaskPage(task: task)),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSkeletonLoader(bool isDark) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: isDark ? Colors.grey[800]! : Colors.grey[300]!,
          highlightColor: isDark ? Colors.grey[700]! : Colors.grey[100]!,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        );
      },
    );
  }
}
