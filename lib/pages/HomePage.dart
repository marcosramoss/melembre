// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:melembre/components/tarefa_item.dart';
import 'package:melembre/data/tarefa_repository.dart';
import 'package:melembre/models/tarefa.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Tarefa> listaDeTarefas = [];
  Tarefa? tarefaRemovida;
  int? posicaoDatarefaRemovida;

  final tarefaController = TextEditingController();
  final TarefaRepository tarefaRepository = TarefaRepository();

  adicionarTarefa() {
    String texto = tarefaController.text;
    setState(() {
      if (texto.isEmpty) {
        return;
      }
      final novaTarefa = Tarefa(
        titulo: texto,
        data: DateTime.now(),
      );
      listaDeTarefas.add(novaTarefa);
    });
    tarefaController.clear();
    tarefaRepository.salvarListaDeTarefas(listaDeTarefas);
  }

  removerTarefa(Tarefa tarefa) {
    tarefaRemovida = tarefa;
    posicaoDatarefaRemovida = listaDeTarefas.indexOf(tarefa);
    setState(() {
      listaDeTarefas.remove(tarefa);
    });
    tarefaRepository.salvarListaDeTarefas(listaDeTarefas);
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Tarefa ${tarefa.titulo} removida com sucesso!'),
      backgroundColor: Colors.deepPurple[900],
      action: SnackBarAction(
          label: 'Desfazer',
          textColor: Colors.white,
          onPressed: () {
            setState(() {
              listaDeTarefas.insert(posicaoDatarefaRemovida!, tarefaRemovida!);
            });
          }),
    ));
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    tarefaRepository.lerListaDeTarefas().then((value) {
      setState(() {
        listaDeTarefas = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Melembre'),
      ),
      backgroundColor: Colors.deepPurple[50],
      body: listaDeTarefas.isEmpty
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Por enquanto não há tarefas no momento. ',
                    style:
                        TextStyle(fontSize: 17, color: Colors.deepPurple[900])),
                Image.asset('images/sem_notas.png'),
              ],
            )
          : ListView(
              children: [
                for (Tarefa tarefa in listaDeTarefas)
                  TarefaItem(
                    tarefa: tarefa,
                    removerTarefa: removerTarefa,
                  ),
                const SizedBox(height: 10),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Me lembre de ...'),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    autofocus: true,
                    onSubmitted: (_) {
                      adicionarTarefa();
                      Navigator.of(context).pop();
                    },
                    controller: tarefaController,
                    decoration: const InputDecoration(
                      hintText: 'Escreva uma nota',
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      adicionarTarefa();
                      Navigator.of(context).pop();
                    },
                    child: const Text('Salvar'),
                  ),
                ],
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}