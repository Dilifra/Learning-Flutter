import 'dart:convert';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Album> fetchAlbum() async {
  final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));

  if (response.statusCode == 200){
    return Album.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load album');
  }
}

class Album{
  final int userId;
  final int id;
  final String title;

  Album({
    required this.userId,
    required this.id,
    required this.title,
});

  factory Album.fromJson(Map<String, dynamic> json){
    return Album(
      userId: json['userId'],
      id: json['id'],
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
      home: const MyAlbum(taitoru: 'A-album'),
    );
  }
}


class MyAlbum extends StatefulWidget {
  const MyAlbum({Key? key, required this.taitoru}) : super(key: key);
  final String taitoru;

  @override
  _MyAlbumState createState() => _MyAlbumState();
}

class _MyAlbumState extends State<MyAlbum> {
  late Future<Album> futureAlbum;

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.taitoru),
      ),
      body: Center(
        child: Card(
          elevation: 10,
          child:Padding(
            padding: EdgeInsets.all(10),
            child:FutureBuilder<Album>(
            future: futureAlbum,
            builder: (context, snapshot){
              if (snapshot.hasData){
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
              } else if (snapshot.hasError){
                return Text('${snapshot.error}');
              }

              return const CircularProgressIndicator();
            }),))
      ),
    );
  }
}
