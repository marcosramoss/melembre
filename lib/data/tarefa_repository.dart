import 'dart:convert';
import 'package:melembre/models/tarefa.dart';
import 'package:pro_shered_preference/pro_shered_preference.dart';

class TarefaRepository {
  late SharedPreferences sharedPreferences;

  Future<List<Tarefa>> lerListaDeTarefas() async {
    sharedPreferences = await SharedPreferences.getInstance();
    final String jsonString =
        sharedPreferences.getString('tarefas_lista') ?? '[]';
    final List jsonDecode = json.decode(jsonString) as List;
    return jsonDecode.map((e) => Tarefa.fromJson(e)).toList();
  }

  void salvarListaDeTarefas(List<Tarefa> tarefas) {
    final String jsonString = json.encode(tarefas);
    sharedPreferences.setString('tarefas_lista', jsonString);
  }
}
