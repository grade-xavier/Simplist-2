import 'package:flutter/material.dart';
import 'package:simplist/models.dart';
import 'package:simplist/task_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ManageTasksPage extends StatefulWidget {
  final String title;
  final TodoListData todoList;
  final void Function() onNeedSave;

  const ManageTasksPage(
      {super.key,
      required this.title,
      required this.todoList,
      required this.onNeedSave});
  @override
  State<ManageTasksPage> createState() => _ManageTasksPageState();
}

class _ManageTasksPageState extends State<ManageTasksPage> {
  final searchInputController = TextEditingController();
  void backButtonClick() {
    Navigator.pop(context);
  }

  void addButtonClick() {
    if (searchInputController.text.isNotEmpty) {
      setState(() {
        widget.todoList.items.add(TaskData(
          title: searchInputController.text,
          checked: false,
        ));
        widget.onNeedSave.call();
        searchInputController.text = "";
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(AppLocalizations.of(context)!.errMsgMissingTitle),
          backgroundColor: Colors.red));
    }
  }

  void deleteTask(item) {
    setState(() {
      widget.todoList.items.remove(item);
      widget.onNeedSave.call();
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Color.fromARGB(255, 30, 50, 50),

      content: Text(
          style: TextStyle(color: Colors.white),
          AppLocalizations.of(context)!.taskDeleted), //Text(AppLocalizations.of(context)!.errMsgMissingTitle),

      action: SnackBarAction(
        textColor: Colors.white,
        label: AppLocalizations.of(context)!.undo,
        onPressed: () {
          setState(() {
            widget.todoList.items.add(item);
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
                  SizedBox(
                    height: 50,
                    width: 50,
                    child: IconButton(
                        tooltip: AppLocalizations.of(context)!.goBack,
                        onPressed: backButtonClick,
                        icon: Icon(Icons.arrow_back)),
                  ),
                  Flexible(
                    child: TextField(
                      textCapitalization: TextCapitalization.sentences,
                      controller: searchInputController,
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                        border: InputBorder.none,
                        hintText: AppLocalizations.of(context)!.searchOrAddItem,
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
                        tooltip: AppLocalizations.of(context)!.addItem,
                        onPressed: addButtonClick,
                        icon: Icon(Icons.add)),
                  ),
                ]),
              ),
            ),

            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
              child: Text(widget.title),
            ),

            //LIST
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 0,horizontal: 8.0),
                child: widget.todoList.items.isEmpty?Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(AppLocalizations.of(context)!.emptyTaskList),
                ):ListView.builder(
                    itemCount: widget.todoList.items.length,
                    itemBuilder: (context, index) {
                      final item = getSortedList(widget.todoList.items)[index];
                      if (item.title.contains(searchInputController.text)) {
                        return Task(
                          taskData: item,
                          onCheckedChanged: (value) => {
                            setState(() {
                              item.checked = value;
                              searchInputController.text = "";
                              widget.onNeedSave.call();
                            })
                          },
                          onOpen: () => {},
                          onDelete: () => {deleteTask(item)},
                          onEdit: (value) => {
                            setState(() {
                              item.title = value;
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

  List<TaskData> getSortedList(list) {
    list.sort((TaskData a, TaskData b) {
      if (a.checked == b.checked) {
        return a.title.compareTo(b.title);
      } else if (a.checked && !b.checked) {
        return 1;
      } else {
        return -1;
      }
    });
    return list;
  }
}
