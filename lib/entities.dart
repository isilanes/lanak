class TaskLoad {
  double nTasks;
  double totalHours;
  double behindHours;

  TaskLoad({
    this.nTasks = 0,
    this.totalHours = 0,
    this.behindHours = 0,
  });

  void reset() {
    nTasks = 0;
    totalHours = 0;
    behindHours = 0;
  }

  void addTask(Map<String, dynamic> task) {
    nTasks += 1;
    totalHours += task["hours"] ?? 0;
    behindHours += task["lag"] ?? 0;
  }
}


