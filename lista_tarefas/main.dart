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
  //Criar uma lista de String(textControler não pode ser passado para uma List<Widget>) para armazenar as tarefas
  final List<String> _tarefas = <String>[];
  //Controlador que armazena o texto, depois de armazenado o texto pode ser usado em outros lugares
  TextEditingController textControler = TextEditingController();

  //Método usado no floatingButton: Abre um diálogo com um textfield e botões para inserir uma tarefa nova na lista
  void _adicionarTarefa(){
    textControler.clear();

    //Botão com Navigator que fecha o Dialog e é chamdo no AlertDialog
    Widget cancelButton = TextButton(
      child: const Text("Cancelar"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    //region submitText: Método para adicionar o texto na lista e fechar o Dialog
    submitText(){
      setState(() {
        //Se o TextField estiver vazio não adiciona uma nova tarefa nem fecha o dialogo
        if(textControler.text.isNotEmpty) {
          _tarefas.add(textControler.text);
          Navigator.of(context).pop();
        }
      });

    }
    //Método convertido para string para usar no OnSubmitted do TextField
    submitString(String v){
      return submitText();
    }
    //endregion

    //Botão que ativa o método submitText e é chamado no AlertDialog
    Widget addButton = TextButton(
      child: const Text("Adicionar"),
      onPressed: submitText,
    );

    //Contrução do AlertDialog que é chamado no showDialog
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

  //Método chamado no icone de editar: Abre um Dialog que usa o parametro index para editar o texto da tarefa
  void _editarTarefa(index) {
    textControler.clear();

    //Define o valor do textControler a partir do index da tarefa selecionada para aparecer no TextField do Dialog
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

  //Método chamado no icone de deletar: Abre um dialogo de confirmação e deleta tarefa pelo index
  void deleteDialog(index) {

    //Fecha dialog
    TextButton naoDeletar = TextButton(
        onPressed: ()=> Navigator.of(context).pop(),
        child: const Text('Cancelar')
    );

    TextButton deletar = TextButton(
        onPressed: (){
          setState(() {
            //Remove tarefa selecionada
            _tarefas.removeAt(index);
          });
          Navigator.of(context).pop();
        },
        child: const Text('Deletar')
    );

    //region Mostra Dialog pra confirmar deletação
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
    //endregion
  }

  //Class Card que faz a construção do item da lista e seus botões
  Card createList(index){

    //region IconButtons de editar e deletar usados no trailing da listTile
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
    //endregion

    return Card(
      child: ListTile(
        //quando uma nova tarefa é adionada na lista é mostrada com base no index
          title: Text(_tarefas[index]),
          //Row permite botar dois botões
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
          //Passa o parametro index para o Card que cria o item da lista
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
