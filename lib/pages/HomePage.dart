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
      tarefaController.clear();
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
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(systemNavigationBarColor: Colors.deepPurple[50]));
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
                Text('Sem lembretes no momento. ',
                    style: TextStyle(
                      fontFamily: 'DancingScript',
                      fontSize: 30,
                      color: Colors.deepPurple[900],
                    )),
                Image.asset('images/sem_notas.png'),
              ],
            )
          : ListView(
              children: [
                MaterialBanner(
                  content: Row(
                    children: [
                      const Text('Lembretes'),
                      Chip(
                        backgroundColor: Colors.deepPurple.shade100,
                        label: Text('${listaDeTarefas.length}'),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Apagar tudo?'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      'Deseja apagar todos os seus lembretes?',
                                    ),
                                    const SizedBox(height: 50),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                          height: 35,
                                          width: 70,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              color:
                                                  Colors.deepPurple.shade100),
                                          child: TextButton(
                                            onPressed: () =>
                                                Navigator.of(context).pop(),
                                            child: const Text('Não'),
                                          ),
                                        ),
                                        const SizedBox(width: 15),
                                        Container(
                                          height: 35,
                                          width: 85,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              color: Colors.red.shade100),
                                          child: TextButton(
                                            onPressed: () {
                                              setState(() {
                                                listaDeTarefas.clear();
                                              });
                                              Navigator.of(context).pop();
                                              tarefaRepository
                                                  .salvarListaDeTarefas(
                                                      listaDeTarefas);
                                            },
                                            child: const Text(
                                              'Limpar',
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        child: const Text('Limpar'))
                  ],
                ),
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
              title: const Text('Me lembre de...'),
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
