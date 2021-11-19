import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

void main() {
  runApp(const FriendlyChatApp());
}

//region Android and Iphone themes
final ThemeData kIOSTheme = ThemeData(
  primarySwatch: Colors.orange,
  primaryColor: Colors.grey[100],
  primaryColorBrightness: Brightness.light,
);

final ThemeData kDefaultTheme = ThemeData(
  colorScheme: ColorScheme.fromSwatch
    (primarySwatch: Colors.purple).copyWith
    (secondary: Colors.orangeAccent[400]),
);
//endregion

String _name = 'Diogo';

class FriendlyChatApp extends StatelessWidget {
  const FriendlyChatApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Friendly Chat',
      theme: defaultTargetPlatform == TargetPlatform.iOS//change theme based on platform
        ? kIOSTheme
        : kDefaultTheme,
      home: const ChatScreen(),
    );
  }
}

//Creates the message container
class ChatMessage extends StatelessWidget {
  const ChatMessage(
      {Key? key, required this.text, required this.animationController})
      : super(key: key);
  final String text;
  final AnimationController animationController;

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor:
          CurvedAnimation(parent: animationController, curve: Curves.easeOut),
      axisAlignment: 0,
      child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(right: 16),
                child: CircleAvatar(child: Text(_name[0])),//Avatar takes the first letter of the name
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_name, style: Theme.of(context).textTheme.headline4),//Name of who sent the message
                    Container(
                      margin: const EdgeInsets.only(top: 5),
                      child: Text(text),
                    )
                  ],
                ),
              )
            ],
          )),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {//ticker provider necessary for the animation
  final List<ChatMessage> _messages = [];
  final _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isComposing = false;

  //Builds textField to write the message
  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: kDefaultTheme.colorScheme.primary),//android's theme
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Flexible(//text field occupies the whole container apart from the icon
              child: TextField(
                controller: _textController,
                onSubmitted: _isComposing ? _handleSubmitted: null,//Sends text if container is not empty
                decoration:
                    const InputDecoration.collapsed(hintText: 'Send a message'),
                focusNode: _focusNode,//defines place to return focus
                onChanged:(String text){
                  setState(() {
                    _isComposing = text.isNotEmpty;//sets _isComposing to enable send icon
                  });
                }
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                icon: const Icon(
                  Icons.send_outlined,
                ),
                onPressed: _isComposing//prevents from sending blank texts
                  ? () => _handleSubmitted(_textController.text)
                  :null,//disables button when text is empty
              ),
            )
          ],
        ),
      ),
    );
  }

  void _handleSubmitted(String text) {
    _textController.clear();//clear the text written on TextField
    setState(() {
      _isComposing = false;
    });
    
    ChatMessage message = ChatMessage(
      text: text,
      animationController: AnimationController(
        duration: const Duration(milliseconds: 300),//duration of the animation of the message appearing
        vsync: this,//sync animation with text..?
      ),
    );
    setState(() {
      _messages.insert(0, message);//insert text from ChatMessage into _messages list
    });
    _focusNode.requestFocus();//send focus back to the BuildTextComposer
    message.animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Friendly Chat'),
        elevation:
          Theme.of(context).platform == TargetPlatform.iOS ? 0 : 4,
        ),
        body: Column(children: [
          Flexible(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              reverse: true,
              itemBuilder: (_, int index) => _messages[index],//build listView based on list of messages
              itemCount: _messages.length,
            ),
          ),
          const Divider(height: 1),//divides items of the list
          Container(
            decoration: BoxDecoration(color: Theme.of(context).cardColor),//change text field if not empty
            child: _buildTextComposer(),
          )
        ]));
  }

  @override
  void dispose() {//dispose of animations so they don't overload the app
    for (var message in _messages) {
      message.animationController.dispose();
    }
    super.dispose();
  }
}
