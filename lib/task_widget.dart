import 'package:flutter/material.dart';
import 'package:simplist/models.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Task extends StatefulWidget {
  final TaskData taskData;
  final void Function(dynamic) onCheckedChanged;
  final void Function() onDelete;
  final void Function() onOpen;
  final void Function(String) onEdit;

  Task({
    super.key,
    required this.taskData,
    required this.onCheckedChanged,
    required this.onDelete,
    required this.onEdit,
    required this.onOpen,
  });

  @override
  State<Task> createState() => _TaskState();
}

class _TaskState extends State<Task> {
  var readOnly = true;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      child: Row(
        children: [
          Checkbox(
              value: widget.taskData.checked,
              onChanged: (value) => {widget.onCheckedChanged.call(value)}),
          Expanded(
              child: readOnly
                  ? GestureDetector(
                      child: Text(widget.taskData.title),
                      onTap: () => {widget.onOpen.call()},
                      onLongPress: () => {
                            setState(() {
                              readOnly = false;
                            })
                          })
                  : TextField(
                      autofocus: true,
                      textCapitalization: TextCapitalization.sentences,
                      controller:
                          TextEditingController(text: widget.taskData.title),
                      onSubmitted: (value) => {
                        setState(() {
                          readOnly = true;
                          widget.onEdit.call(value);
                        })
                      },
                    )),
          IconButton(
              icon: const Icon(Icons.delete),
              tooltip: AppLocalizations.of(context)!.deleteItem,
              onPressed: () {
                widget.onDelete.call();
              })
        ],
      ),
    );
  }
}
