import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){

    return const MaterialApp(
      home: Random(),
    );
  }
}

class Tarefas extends StatelessWidget {
  const Tarefas(
      {Key? key, required this.text})
      : super(key: key);
  final String text;
  final _biggerFonts = const TextStyle(fontSize: 18);
  final alreadySaved = true;


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          title: Text(text,
          style: _biggerFonts,
          ),
          trailing: Icon(
            alreadySaved ? Icons.favorite : Icons.favorite_border,
            color: alreadySaved ? Colors.red : Colors.blue,
          )
        ),
        const Divider(),
    ]);
  }
}

class Random extends StatefulWidget {
  const Random({Key? key}) : super(key: key);

  @override
  _RandomState createState() => _RandomState();
}

class _RandomState extends State<Random> {
  final _textController = TextEditingController();
  final List<Tarefas> _tarefas = [];
  final _saved = {};
  final alreadySaved = true;
  final _biggerFonts = const TextStyle(fontSize: 18);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text ('Tarefas'),
        actions: [
          IconButton(
            icon: Icon(Icons.list),
            iconSize: 30,
            padding: EdgeInsets.only(right:25),
            onPressed: _pushSaved,
          )
        ]
      ),
      body: _buildSuggestions(),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: (){
            showDialog(
                context: context,
                builder: (BuildContext context){
                  return AlertDialog(
                    title: const Text('Alert Title'),
                    content: TextField(
                      controller: _textController,
                      onSubmitted: _handleSubmitted,
                      decoration: const InputDecoration(
                        labelText:'Descripition',
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancelar')),
                      TextButton(
                          onPressed: (){
                            _handleSubmitted(_textController.text);
                            Navigator.pop(context);
                          },
                          child: const Text('Confirmar')),
                    ],
                  );
                }
            );
          }
      ),
    );
  }

  //Cria a lista e determina que ela adicione mais elementos da _buildRow caso
  //o index seja menor que o numero de sugestões carregadas
  Widget _buildSuggestions() {
    return ListView.builder(
      addAutomaticKeepAlives: false,
      padding: const EdgeInsets.all(16),
      itemBuilder: (_, int index) => _tarefas[index],
      itemCount: _tarefas.length,
    );
  }

  void _handleSubmitted(String text){
    _textController.clear();
    var tarefa = Tarefas (
      text: text,
    );
      setState((){
        _tarefas.insert(0,tarefa);
      });
  }
  void _pushSaved(){
    Navigator.of(context).push(
        MaterialPageRoute(
            builder: (BuildContext context){
              final tiles = _tarefas.map(
                  (text) {
                    return ListTile(
                      title:Text('text',
                      style: _biggerFonts ,),
                    );
                  },
              );
              final divided = ListTile.divideTiles(
                context: context,
                tiles: tiles,
              ).toList();

              return Scaffold(
                appBar: AppBar(
                  title:Text('Tarefas Salvas'),
                ),
                body: ListView(children:divided),
              );
            })
    );
  }
}


