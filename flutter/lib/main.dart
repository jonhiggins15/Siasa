import 'package:flutter/material.dart';
import 'package:siasa/Player.dart';
import 'package:siasa/game.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Siasa',
      theme: new ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: new MyHomePage(title: 'Siasa'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _name = "";

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _startGame() async{
    if(_name.isEmpty){
      return;
    }

    FirebaseUser user = await _auth.signInAnonymously();
    String id = await user.getIdToken();

    Firestore.instance.collection('Users').document(id)
        .setData({ 'name': _name, 'uid': id});
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GameScreen(Player(_name, id))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Text(
                'Enter your name',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              new TextField(
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.black,
                ),
                onChanged: (s){
                  setState(() {
                    _name = s;
                  });
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _startGame,
        tooltip: 'Start game',
        child: new Icon(Icons.check),
      ),
    );
  }
}
