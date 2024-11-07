import 'package:flutter/material.dart';
import 'package:simplist/manage_tasks_page.dart';
import 'package:simplist/models.dart';
import 'package:simplist/todo_list_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(AppLocalizations.of(context)!.errMsgMissingTitle),
          backgroundColor: Colors.red));
    }
  }

  void deleteList(todoList) {
    setState(() {
      widget.data.lists.remove(todoList);
      widget.onNeedSave.call();
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Color.fromARGB(255, 30, 50, 50),
      content: Text(
          style: TextStyle(color: Colors.white),
          AppLocalizations.of(context)!.listDeleted),
      action: SnackBarAction(
        textColor: Colors.white,
        label: AppLocalizations.of(context)!.undo,
        onPressed: () {
          setState(() {
            widget.data.lists.add(todoList);
            widget.onNeedSave.call();
          });
        },
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                        hintText: AppLocalizations.of(context)!.searchOrAddList,
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
                        tooltip: AppLocalizations.of(context)!.addList,
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
                          onDelete: () => {deleteList(todoList)},
                          onFavorite: (value) => {
                            setState(() {
                              todoList.favorite = value;
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
      if (a.favorite == b.favorite) {
        return a.title.toLowerCase().compareTo(b.title.toLowerCase());
      } else if (b.favorite && !a.favorite) {
        return 1;
      } else {
        return -1;
      }
    });

    return list;
  }
}
