enum TaskType { single, group }

class TaskItem {
  final String text;
  final TaskType type;
  final int level; // 1: Soft, 2: Medium, 3: Hard

  TaskItem({
    required this.text,
    required this.type,
    required this.level,
  });
}