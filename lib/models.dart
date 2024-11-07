
class UserData {
  final List<TodoListData> lists;
  UserData({required this.lists});

  factory UserData.fromJson(Map<String, dynamic> json) {
    List<dynamic> jlists = json["lists"] as List<dynamic>;
    List<TodoListData> newList = List<TodoListData>.empty(growable: true);
    for (var i = 0; i < jlists.length; i++) {
      Map<String, dynamic> jlist = jlists[i];
      newList.add(TodoListData.fromJson(jlist));
    }
    return UserData(lists: newList);
  }
  Map<String, dynamic> toJson() {
    return {
      'lists': lists,
    };
  }
}

class TaskData {
  String title = "";
  bool checked;
  TaskData({required this.title, required this.checked});
  factory TaskData.fromJson(Map<String, dynamic> json) {
    final title = json["title"] as String;
    final checked = json["checked"] as bool;
    return TaskData(title: title, checked: checked);
  }
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'checked': checked,
    };
  }
}

class TodoListData  {
  final List<TaskData> items;
  String title = "";
  bool favorite = false;
  TodoListData({required this.title, required this.items, this.favorite=false});

  factory TodoListData.fromJson(Map<String, dynamic> json) {
    final title = json["title"];
    final favorite = json["favorite"]??false;
    List<dynamic> jitems = json["items"] as List<dynamic>;
    List<TaskData> newList = List<TaskData>.empty(growable: true);
    for (var i = 0; i < jitems.length; i++) {
      Map<String, dynamic> jitem = jitems[i];
      newList.add(TaskData.fromJson(jitem));
    }
    return TodoListData(title: title, items: newList,favorite:favorite);
  }

  Map<String, dynamic> toJson() {
    return {'title': title, 'items': items, 'favorite':favorite};
  }
}
