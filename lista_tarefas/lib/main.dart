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

class Random extends StatefulWidget {
  const Random({Key? key}) : super(key: key);

  @override
  _RandomState createState() => _RandomState();
}

class _RandomState extends State<Random> {
  final _suggestions = <WordPair> [];
  final _biggerFonts = const TextStyle(fontSize: 18);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _buildSuggestions(),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: (){
            showDialog(
                context: context,
                builder: (BuildContext context){
                  return const AlertDialog(
                    title: Text('Alert Title'),
                    content: TextField(
                      decoration: InputDecoration(
                        labelText:'Descripition',
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                          onPressed: null,
                          child: Text('Confirmar')),
                      TextButton(
                          onPressed: null,
                          child: Text('Cancelar')),
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
      itemBuilder: (BuildContext _context, int i) {
        if (i.isOdd) {
          return const Divider();
        }
        final int index = i ~/ 2;

        if (index >= _suggestions.length) {
          _suggestions.addAll(generateWordPairs().take(10));
        }
        return _buildRow(_suggestions[index]);
      },
    );
  }

  //Cria os elementos da lista com a função WordPair do pacote english_words
  Widget _buildRow(WordPair pair){
    return ListTile(
      title: Text(
        pair.asPascalCase,
        //asPacalCase = UpperCamelCase
        style: _biggerFonts,
      ),
    );
  }
}
