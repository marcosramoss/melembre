import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:melembre/models/tarefa.dart';

class TarefaItem extends StatefulWidget {
  const TarefaItem({
    Key? key,
    required this.tarefa,
    required this.removerTarefa,
  }) : super(key: key);
  final Tarefa tarefa;
  final Function(Tarefa) removerTarefa;

  @override
  State<TarefaItem> createState() => _TarefaItemState();
}

class _TarefaItemState extends State<TarefaItem> {
  final List<Tarefa> selecionada = [];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 14, right: 14, top: 10),
      child: Material(
        elevation: 6.0,
        borderRadius: BorderRadius.circular(8),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: selecionada.contains(widget.tarefa)
                ? Colors.green.shade50
                : Colors.white,
            border: Border.all(
                width: 1,
                color: selecionada.contains(widget.tarefa)
                    ? Colors.green
                    : Colors.white),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListTile(
            title: Text(
              widget.tarefa.titulo,
              style: TextStyle(
                decoration: selecionada.contains(widget.tarefa)
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
                color: Colors.deepPurple[900],
              ),
            ),
            subtitle: Text(
              DateFormat('d MMMM y - HH:mm', 'pt-BR')
                  .format(widget.tarefa.data),
              style: TextStyle(color: Colors.deepPurple[200]),
            ),
            trailing: selecionada.contains(widget.tarefa)
                ? IconButton(
                    onPressed: () {
                      widget.removerTarefa(widget.tarefa);
                    },
                    icon: CircleAvatar(
                      backgroundColor: Colors.red[100],
                      child: const Icon(
                        Icons.delete,
                        color: Colors.red,
                        size: 20,
                      ),
                    ),
                  )
                : const Text(''),
            leading: selecionada.contains(widget.tarefa)
                ? Material(
                    elevation: 6,
                    borderRadius: BorderRadius.circular(50),
                    child: CircleAvatar(
                      backgroundColor: Colors.green[100],
                      child: Icon(
                        Icons.check_rounded,
                        color: Colors.green[400],
                        size: 20,
                      ),
                    ),
                  )
                : Material(
                    elevation: 6,
                    borderRadius: BorderRadius.circular(50),
                    child: CircleAvatar(
                      backgroundColor: Colors.deepPurple[50],
                      child: const Text(
                        '···',
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
            selected: selecionada.contains(widget.tarefa),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            onTap: () {
              setState(
                () {
                  (selecionada.contains(widget.tarefa))
                      ? selecionada.remove(widget.tarefa)
                      : selecionada.add(widget.tarefa);
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
