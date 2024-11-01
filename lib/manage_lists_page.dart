import 'package:flutter/material.dart';
import 'package:simplist/manage_tasks_page.dart';
import 'package:simplist/models.dart';
import 'package:simplist/todo_list_widget.dart';

class ManageListsPage extends StatefulWidget {
  final String title;
  final UserData data;
  final void Function() onNeedSave;

  const ManageListsPage(
      {super.key,
      required this.title,
      required this.data,
      required this.onNeedSave});
  @override
  State<ManageListsPage> createState() => _ManageListsPageState();
}

class _ManageListsPageState extends State<ManageListsPage> {
  final searchInputController = TextEditingController();
  void addButtonClick() {
    if (searchInputController.text.isNotEmpty) {
      setState(() {
        widget.data.lists.add(TodoListData(
            title: searchInputController.text,
            items: List.empty(growable: true)));
        widget.onNeedSave.call();
        searchInputController.text = "";
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Type a title"), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // appBar: AppBar(
        //   backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        //   title: Text(widget.title),
        // ),
        body: Column(
          children: <Widget>[
            //TOOLBAR
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color.fromARGB(255, 30, 50, 50),
                ),
                child: Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
                  Flexible(
                    child: TextField(
                      textCapitalization: TextCapitalization.sentences,
                      controller: searchInputController,
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                        border: InputBorder.none,
                        hintText: "Search or add list",
                        
                      ),
                      onChanged: (value) => {setState(() {})},
                      onEditingComplete: addButtonClick,
                    ),
                  ),
                  SizedBox(width: 10),
                  SizedBox(
                    height: 50,
                    width: 50,
                    child: IconButton(
                        //color: Colors.blue,
                        //backgroundColor:Colors.gray,
                        onPressed: addButtonClick,
                        icon: Icon(Icons.add)),
                  ),
                ]),
              ),
            ),

            //LIST
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                    itemCount: widget.data.lists.length,
                    itemBuilder: (context, index) {
                      final todoList = getSortedList(widget.data.lists)[index];
                      if (todoList.title.contains(searchInputController.text)) {
                        return TodoList(
                          todoList: todoList,
                          onOpen: () => {
                            //Navigator.pushNamed(context, '/tasks', arguments: todoList)
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ManageTasksPage(
                                        title: todoList.title,
                                        todoList: todoList,
                                        onNeedSave: () =>
                                            {widget.onNeedSave.call()},
                                      )),
                            )
                          },
                          onDelete: () => {
                            setState(() {
                              widget.data.lists.remove(todoList);
                              widget.onNeedSave.call();
                            })
                          },
                          onEdit: (value) => {
                            setState(() {
                              todoList.title = value;
                              widget.onNeedSave.call();
                            })
                          },
                        );
                      } else {
                        return Container();
                      }
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<TodoListData> getSortedList(list) {
    list.sort((TodoListData a, TodoListData b) {
      return a.title.compareTo(b.title);
    });
    return list;
  }
/*
  void saveUserData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("data", jsonEncode(widget.data));
  }*/
}
