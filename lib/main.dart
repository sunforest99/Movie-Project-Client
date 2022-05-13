import 'package:flutter/material.dart';
import 'package:ftpconnect/ftpconnect.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '영끌',
      debugShowCheckedModeBanner: true,
      home: MyWidget(),
    );
  }
}

class MyWidget extends StatefulWidget {
  const MyWidget({Key? key}) : super(key: key);

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('영끌'),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.cyan,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20))),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              print("object");
            },
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              print("object");
            },
          ),
        ],
      ),
      drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
            new Container(
              height: 50.0,
              color: Colors.cyan,
              ),
          ListTile(
            leading: Icon(Icons.movie),
            title: const Text('영화 예매하기'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.access_time),
            title: const Text('상영 예정작'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.leaderboard),
            title: const Text('영화 랭킹'),
            onTap: () {},
          )
        ],
      )),
      body: Padding(
        padding: EdgeInsets.fromLTRB(160.0, 0.0, 0.0, 0.0),
        child: ListView(
          children: <Widget>[],
        ),
      ),
    );
  }
}
