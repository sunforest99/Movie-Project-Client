import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movie_project_app/config.dart';
import 'package:movie_project_app/movie_rank.dart';

void main() {
  runApp(MyApp());
}

class Movie {
  final String? grade;
  final String? movie_name;
  final String? movie_time;
  final String? thumbnailUrl ;

  Movie({this.grade, this.movie_name, this.movie_time, this.thumbnailUrl});

  // 사진의 정보를 포함하는 인스턴스를 생성하여 반환하는 factory 생성자
  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      grade: json['grade'] as String,
      movie_name: json['movie_name'] as String,
      movie_time: json['movie_time'] as String,
      thumbnailUrl: json['img_url'] as String,
    );
  }
}

Future<List<Movie>> fetchPhotos(http.Client client) async {
  // 해당 URL로 데이터를 요청하고 수신함
  Config con = new Config();
  final response =
      await client.get(Uri.parse(con.list));

  // parsePhotos 함수를 백그라운도 격리 처리
  return compute(parsePhotos, response.bodyBytes);
}

List<Movie> parsePhotos(Uint8List responseBody) {
  // 수신 데이터를 JSON 포맷(JSON Array)으로 디코딩
  final parsed = jsonDecode(utf8.decode(responseBody)).cast<Map<String, dynamic>>();

  // JSON Array를 List<Photo>로 변환하여 반환
  return parsed.map<Movie>((json) => Movie.fromJson(json)).toList();
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
        title: Text('상영중인 영화'),
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
            // padding: EdgeInsets.zero,
            children: <Widget>[
            new Container(
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 12.5, 0.0, 0.0),
                  child: Text(
                    "영끌",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15
                    ),
                  ),
              ),
              height: 50.0,
              color: Colors.cyan,
              ),
          ListTile(
            leading: Icon(Icons.movie),
            title: const Text('영화 예매하기'),
            onTap: () {
             
            },
          ),
          ListTile(
            leading: Icon(Icons.access_time),
            title: const Text('상영 예정작'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.leaderboard),
            title: const Text('영화 랭킹'),
            onTap: () {
               Navigator.push(context, MaterialPageRoute(builder: (_) => Rank()));
            },
          )
        ],
      )),
      body: FutureBuilder<List<Movie>>(
        // future 항목에 fetchPhotos 함수 설정. fetchPhotos는 Future 객체를 결과값으로 반환
        future: fetchPhotos(http.Client()),
        // Future 객체를 처리할 빌더
        builder: (context, snapshot) {
          // 에러가 발생하면 에러 출력
          if (snapshot.hasError) print(snapshot.error);
          // 정상적으로 데이터가 수신된 경우
          return snapshot.hasData
              ? MovieList(movies: snapshot.data) // PhotosList를 출력
              : Center(
                  child: CircularProgressIndicator()); // 데이터 수신 전이면 인디케이터 출력
        },
      ),
    );
  }
}


class MovieList extends StatelessWidget {
  final List<Movie>? movies;

  MovieList({Key? key, this.movies }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 그리드뷰를 builder를 통해 생성. builder를 이용하면 화면이 스크롤 될 때 해당 앨리먼트가 랜더링 됨
    return GridView.builder(
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemCount: movies?.length,
      itemBuilder: (context, index) {
        var movie = movies?[index];
        // 컨테이너를 생성하여 반환
        return Container(
          child: Column(
            children: <Widget>[
              // 이미지의 albumId와 ID 값을 출력
              Text("${movie?.movie_name}"),
              Text("${movie?.movie_time}"),
              // thumbnailUrl에 해당하는 이미지를 온라인으로부터 다운로드하여 출력
              Image.network(movie?.thumbnailUrl ?? "null")
            ],
          ),
        );
      },
    );
  }
}