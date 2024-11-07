import 'package:flutter/material.dart';
import 'package:simplist/models.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TodoList extends StatefulWidget {
  final TodoListData todoList;
  final void Function() onDelete;

  final void Function() onOpen;
  final void Function(String) onEdit;
  final void Function(bool) onFavorite;

  TodoList({
    super.key,
    required this.todoList,
    required this.onDelete,
    required this.onEdit,
    required this.onOpen,
    required this.onFavorite,
  });

  @override
  State<TodoList> createState() => _ListItemState();
}

class _ListItemState extends State<TodoList> {
  var readOnly = true;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 0),
      child: Row(
        children: [
          Expanded(
              child: readOnly
                  ? GestureDetector(
                      child: Text(widget.todoList.title),
                      onTap: () => {widget.onOpen.call()},
                      onLongPress: () => {
                            setState(() {
                              readOnly = false;
                            })
                          })
                  : TextField(
                      textCapitalization: TextCapitalization.sentences,
                      autofocus: true,
                      controller:
                          TextEditingController(text: widget.todoList.title),
                      onSubmitted: (value) => {
                        setState(() {
                          readOnly = true;
                          widget.onEdit.call(value);
                        })
                      },
                    )),
          IconButton(
              icon: widget.todoList.favorite
                  ? const Icon(Icons.star)
                  : const Icon(Icons.star_border),
              tooltip: AppLocalizations.of(context)!.favorite,
              onPressed: () {
                print(widget.todoList.favorite);
                widget.onFavorite.call(!widget.todoList.favorite);
              }),
          IconButton(
              icon: const Icon(Icons.delete),
              tooltip: AppLocalizations.of(context)!.deleteList,
              onPressed: () {
                widget.onDelete.call();
              }),
        ],
      ),
    );
  }
}
