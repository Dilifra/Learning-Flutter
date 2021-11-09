import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de Tarefas',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Minhas tarefas'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<String> _tarefas = <String>[];
  TextEditingController textControler = TextEditingController();

  void _adicionarTarefa(){
    textControler.clear();

    Widget cancelButton = TextButton(
      child: const Text("Cancelar"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    //region Função para adicionar o texto na lista
    submitText(){
      setState(() {
        if(textControler.text.isNotEmpty) {
          _tarefas.add(textControler.text);
          Navigator.of(context).pop();
        }
      });

    }
    submitString(String v){
      return submitText();
    }
    //endregion

    Widget addButton = TextButton(
      child: const Text("Adicionar"),
      onPressed: submitText,
    );

    AlertDialog alerta = AlertDialog(
      title: const Text("Informe sua tarefa"),
      content: TextField(
        autofocus: true,
        controller: textControler,
        onSubmitted: submitString,
      ),
      actions: [
        cancelButton,
        addButton
      ],
    );

    //region ShowDialog
    showDialog(
      context:  context,
      builder:  (BuildContext context) {
        return alerta;
      },
    );
    //endregion
  }

  void _editarTarefa(index) {
    textControler.clear();
    
    textControler.value = textControler.value.copyWith(
      text: _tarefas[index],
    );

    Widget cancelButton = TextButton(
      child: const Text("Cancelar"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    //region Função para mudar o texto
    submitEdit (){
      setState(() {
        if(textControler.text.isNotEmpty) {
          _tarefas[index] = textControler.text;
          Navigator.of(context).pop();
        }
      });
    }
    submitEditString(String v){
      return submitEdit();
    }
    //endregion

    Widget addButton = TextButton(
      child: const Text("Mudar"),
      onPressed: submitEdit,
    );

    AlertDialog alerta = AlertDialog(
      title: const Text("Informe sua tarefa"),
      content: TextField(
        autofocus: true,
        controller: textControler,
        onSubmitted: submitEditString,
        decoration: const InputDecoration(
            border: OutlineInputBorder()
        ),
      ),
      actions: [
        cancelButton,
        addButton
      ],
    );

    //region ShowDialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alerta;
      },
    );
    //endregion
  }

  void deleteDialog(index) {

    TextButton naoDeletar = TextButton(
        onPressed: ()=> Navigator.of(context).pop(),
        child: const Text('Cancelar')
    );

    TextButton deletar = TextButton(
        onPressed: (){
          setState(() {
            _tarefas.removeAt(index);
          });
          Navigator.of(context).pop();
        },
        child: const Text('Deletar')
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Quer mesmo deletar está tarefa?'),
          actions:[
            naoDeletar,
            deletar,
          ]
        );
      }
    );
  }

  Card createList(index){

    IconButton editButton = IconButton(
        onPressed: (){
          _editarTarefa(index);
        },
        icon: const Icon(Icons.edit));

    IconButton deleteButton = IconButton(
        onPressed: () {
          deleteDialog(index);
        },
        icon: const Icon(Icons.delete),
    );

    return Card(
      child: ListTile(
          title: Text(_tarefas[index]),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              editButton,
              deleteButton
            ],
          )
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: _tarefas.length,
          itemBuilder: (context,index) => createList(index),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _adicionarTarefa,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
