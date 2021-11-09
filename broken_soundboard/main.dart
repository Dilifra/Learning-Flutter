import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  //API de audio para tocar os audios de cada botão
  late final AudioCache _audioCache;

  @override
  void initState() {
    super.initState();
    _audioCache = AudioCache(
      fixedPlayer: AudioPlayer()..setReleaseMode(ReleaseMode.STOP),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style =
        ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
                flex: 1,
                child: Center(
                    child: GridView.count(
                        padding:const EdgeInsets.all(10),
                        shrinkWrap: true,
                        crossAxisCount: 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        children: <Widget>[
                      ElevatedButton(
                        onPressed: () => _audioCache.play('key01.mp3'),
                        onLongPress: ()=> _audioCache.play('key02.mp3'),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blue[900],
                          enableFeedback: false,
                          shape:CircleBorder(),
                        ),
                        child: const Text(''),
                      ),
                      ElevatedButton(
                        onPressed: () => _audioCache.play('key04.mp3'),
                        onLongPress: ()=> _audioCache.play('key05.mp3'),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red,
                          enableFeedback: false,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)),
                        ),
                        child: const Text(''),
                      ),
                      ElevatedButton(
                        onPressed: () => _audioCache.play('key07.mp3'),
                        onLongPress: ()=> _audioCache.play('key08.mp3'),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.yellow,
                          enableFeedback: false,
                        ),
                        child: const Text(''),
                      ),
                      ElevatedButton(
                        onPressed: () => _audioCache.play('key10.mp3'),
                        onLongPress: ()=> _audioCache.play('key11.mp3'),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.green,
                          enableFeedback: false,
                        ),
                        child: const Text(''),
                      ),
                      ElevatedButton(
                        onPressed: () => _audioCache.play('key13.mp3'),
                        onLongPress: ()=> _audioCache.play('key14.mp3'),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.purple,
                          enableFeedback: false,
                        ),
                        child: const Text(''),
                      ),
                      ElevatedButton(
                        onPressed: () => _audioCache.play('key16.mp3'),
                        onLongPress: ()=> _audioCache.play('key17.mp3'),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.cyanAccent,
                          enableFeedback: false,
                        ),
                        child: const Text(''),
                      ),
                      ElevatedButton(
                        onPressed: () => _audioCache.play('key19.mp3'),
                        onLongPress: ()=> _audioCache.play('key20.mp3'),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.brown,
                          enableFeedback: false,
                        ),
                        child: const Text(''),
                      ),
                      ElevatedButton(
                        onPressed: () => _audioCache.play('key13.mp3'),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          enableFeedback: false,
                        ),
                        child: const Text(''),
                      ),
                      ElevatedButton(
                        onPressed: () => _audioCache.play('key15.mp3'),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.pink,
                          enableFeedback: false,
                        ),
                        child: const Text(''),
                      ),
                    ]))),
	   ]
        ),
      ),
    ); // This trailing comma makes auto-formatting nicer for build methods.
  }
}
