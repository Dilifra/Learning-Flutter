import 'dart:convert';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Album> updateAlbum(String title) async {
  final response = await http.put(
    Uri.parse('https://jsonplaceholder.typicode.com/albums/1'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8'
    },
    body: jsonEncode(<String, String>{
      'title': title,
    }),
  );
  if (response.statusCode == 200) {
    return Album.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to update album');
  }
}

Future<Album> fetchAlbum() async {
  final response = await http
      .get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));

  if (response.statusCode == 200) {
    return Album.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load album');
  }
}

class Album {
  final String title;

  Album({
    required this.title,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      title: json['title'],
    );
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Album',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const MyAlbum(title: 'A-album'),
    );
  }
}

class MyAlbum extends StatefulWidget {
  const MyAlbum({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyAlbumState createState() => _MyAlbumState();
}

class _MyAlbumState extends State<MyAlbum> {
  late Future<Album> futureAlbum;
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
  }

  updateData(){
    futureAlbum = updateAlbum(_textController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(children: [
            Card(
                margin: EdgeInsets.only(top: 15),
                elevation: 10,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: FutureBuilder<Album>(
                      future: futureAlbum,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Text(
                            snapshot.data!.title,
                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                              color: Colors.deepPurple,
                              backgroundColor: Colors.white10,
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Text('${snapshot.error}');
                        }

                        return const CircularProgressIndicator();
                      }),
                )),
            Padding(
                padding: const EdgeInsets.all(25),
                child: TextField(
                  controller: _textController,
                  onSubmitted:(){
                    setState(() {
                      updateData();
                    });
                  }(),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Change the text',
                    fillColor: Colors.deepPurple,
                  ),
                )),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  updateData();
                });
              },
              child: const Text('Update data'),
              style: ElevatedButton.styleFrom(
                primary: Colors.deepPurple,
                elevation: 5,
              ),
            )
          ]),
        ));
  }
}
