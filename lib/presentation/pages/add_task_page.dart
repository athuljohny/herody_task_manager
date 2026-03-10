import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/task_entity.dart';
import '../controllers/auth_controller.dart';
import '../controllers/task_controller.dart';

class AddTaskPage extends StatefulWidget {
  final TaskEntity? task;
  const AddTaskPage({super.key, this.task});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late TextEditingController _notesController;
  late TextEditingController _tagsController;

  final _taskController = Get.find<TaskController>();
  final _authController = Get.find<AuthController>();

  String _selectedPriority = 'medium';
  String _selectedCategory = 'General';
  DateTime? _selectedDueDate;
  String _selectedRecurrence = 'none';

  final List<String> _categories = [
    'General',
    'Work',
    'Personal',
    'Shopping',
    'Health',
  ];
  final List<String> _recurrences = ['none', 'daily', 'weekly', 'monthly'];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? "");
    _descController = TextEditingController(
      text: widget.task?.description ?? "",
    );
    _notesController = TextEditingController(text: widget.task?.notes ?? "");
    _tagsController = TextEditingController(
      text: widget.task?.tags.join(", ") ?? "",
    );

    if (widget.task != null) {
      _selectedPriority = widget.task!.priority;
      _selectedCategory = widget.task!.category;
      _selectedDueDate = widget.task!.dueDate;
      _selectedRecurrence = widget.task!.recurrence;
    }
  }

  Future<void> _pickDueDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (pickedTime != null) {
        setState(() {
          _selectedDueDate = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isEditing = widget.task != null;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color bgColor = isDark
        ? const Color(0xFF1E1E1E)
        : const Color(0xFFF8F9FA);
    final Color textColor = isDark ? Colors.white : Colors.black87;
    final Color hintColor = isDark ? Colors.grey[600]! : Colors.grey[400]!;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        centerTitle: false,
        title: Text(
          isEditing ? "Edit Task" : "New Task",
          style: GoogleFonts.poppins(
            color: textColor,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.close, color: textColor),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            TextField(
              controller: _titleController,
              autofocus: !isEditing,
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
              decoration: InputDecoration(
                hintText: "What do you need to do?",
                border: InputBorder.none,
                hintStyle: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: hintColor,
                ),
              ),
            ),

            Divider(color: isDark ? Colors.grey[800] : Colors.grey[300]),
            const SizedBox(height: 10),

            // Description
            TextField(
              controller: _descController,
              maxLines: null,
              style: GoogleFonts.poppins(fontSize: 15, color: textColor),
              decoration: InputDecoration(
                hintText: "Add details or description...",
                border: InputBorder.none,
                hintStyle: GoogleFonts.poppins(fontSize: 15, color: hintColor),
              ),
            ),
            const SizedBox(height: 30),

            // Due Date
            _buildOptionRow(
              icon: Icons.calendar_today_outlined,
              iconColor: const Color(0xFF4285F4),
              title: _selectedDueDate == null
                  ? "Set Due Date"
                  : DateFormat(
                      'MMM dd, yyyy • hh:mm a',
                    ).format(_selectedDueDate!),
              textColor: textColor,
              trailing: _selectedDueDate != null
                  ? IconButton(
                      icon: const Icon(Icons.clear, size: 20),
                      onPressed: () => setState(() => _selectedDueDate = null),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    )
                  : null,
              onTap: _pickDueDate,
            ),
            const SizedBox(height: 20),

            // Priority
            _buildOptionRow(
              icon: Icons.flag_outlined,
              iconColor: const Color(0xFFFB9C2B),
              title: "Priority",
              textColor: textColor,
              trailing: DropdownButton<String>(
                value: _selectedPriority,
                underline: const SizedBox(),
                icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
                style: GoogleFonts.poppins(
                  color: textColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                items: ['low', 'medium', 'high'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value.capitalizeFirst!),
                  );
                }).toList(),
                onChanged: (val) => setState(() => _selectedPriority = val!),
              ),
            ),
            const SizedBox(height: 20),

            // Category
            _buildOptionRow(
              icon: Icons.folder_outlined,
              iconColor: const Color(0xFFE040FB),
              title: "Category",
              textColor: textColor,
              trailing: DropdownButton<String>(
                value: _selectedCategory,
                underline: const SizedBox(),
                icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
                style: GoogleFonts.poppins(
                  color: textColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                items: _categories.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (val) => setState(() => _selectedCategory = val!),
              ),
            ),
            const SizedBox(height: 20),

            // Recurrence
            _buildOptionRow(
              icon: Icons.sync,
              iconColor: const Color(0xFF69F0AE),
              title: "Recurrence",
              textColor: textColor,
              trailing: DropdownButton<String>(
                value: _selectedRecurrence,
                underline: const SizedBox(),
                icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
                style: GoogleFonts.poppins(
                  color: textColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                items: _recurrences.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value.capitalizeFirst!),
                  );
                }).toList(),
                onChanged: (val) => setState(() => _selectedRecurrence = val!),
              ),
            ),

            const SizedBox(height: 35),

            Text(
              "Extra Details",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: textColor,
              ),
            ),
            const SizedBox(height: 15),

            // Tags
            TextField(
              controller: _tagsController,
              style: GoogleFonts.poppins(color: textColor, fontSize: 14),
              decoration: InputDecoration(
                hintText: "Tags (comma separated)",
                hintStyle: GoogleFonts.poppins(color: hintColor, fontSize: 14),
                prefixIcon: Icon(
                  Icons.tag,
                  color: isDark ? Colors.grey[400] : Colors.grey[700],
                ),
                filled: true,
                fillColor: isDark ? const Color(0xFF2C2C2C) : Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: isDark ? Colors.grey[700]! : Colors.grey[400]!,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: isDark ? Colors.grey[500]! : Colors.grey[600]!,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),

            // Notes
            TextField(
              controller: _notesController,
              maxLines: 4,
              style: GoogleFonts.poppins(color: textColor, fontSize: 14),
              decoration: InputDecoration(
                hintText: "Notes",
                hintStyle: GoogleFonts.poppins(color: hintColor, fontSize: 14),
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(
                    bottom: 60,
                  ), // Align icon with top line
                  child: Icon(
                    Icons.note,
                    color: isDark ? Colors.grey[400] : Colors.grey[700],
                  ),
                ),
                filled: true,
                fillColor: isDark ? const Color(0xFF2C2C2C) : Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: isDark ? Colors.grey[700]! : Colors.grey[400]!,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: isDark ? Colors.grey[500]! : Colors.grey[600]!,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 100), // Fab spacing
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _saveTask,
        backgroundColor: const Color(0xFF4285F4),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        label: Text(
          isEditing ? "Update Task" : "Save Task",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        icon: const Icon(Icons.check, color: Colors.white, size: 20),
      ),
    );
  }

  Widget _buildOptionRow({
    required IconData icon,
    required Color iconColor,
    required String title,
    required Color textColor,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 22),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: textColor,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          if (trailing != null) trailing,
        ],
      ),
    );
  }

  void _saveTask() {
    if (_titleController.text.trim().isEmpty) {
      Get.snackbar("Error", "Title cannot be empty");
      return;
    }

    final tags = _tagsController.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    if (widget.task != null) {
      _taskController.updateTask(
        _authController.user!.uid,
        widget.task!.copyWith(
          title: _titleController.text.trim(),
          description: _descController.text.trim(),
          priority: _selectedPriority,
          dueDate: _selectedDueDate,
          recurrence: _selectedRecurrence,
          category: _selectedCategory,
          tags: tags,
          notes: _notesController.text.trim(),
        ),
      );
    } else {
      final newTask = TaskEntity(
        title: _titleController.text.trim(),
        description: _descController.text.trim(),
        createdAt: DateTime.now(),
        priority: _selectedPriority,
        dueDate: _selectedDueDate,
        recurrence: _selectedRecurrence,
        category: _selectedCategory,
        tags: tags,
        notes: _notesController.text.trim(),
        orderIndex: _taskController.tasks.length,
      );
      _taskController.addTask(_authController.user!.uid, newTask);
    }
    Get.back();
  }
}
