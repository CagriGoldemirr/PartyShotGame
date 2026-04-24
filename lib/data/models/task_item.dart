enum TaskType { single, group, joker } // joker eklendi

class TaskItem {
  final String text;
  final TaskType type;
  final int level; 

  TaskItem({required this.text, required this.type, required this.level});
}