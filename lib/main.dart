import 'package:flutter/material.dart';
import 'package:flutter_application_1/listactor.dart';
import 'package:flutter_application_1/popularmovie.dart';
import 'animasi.dart';
import 'nilaipemain.dart';
import 'genremovie.dart';
import 'detailmovie.dart';
import 'quiz.dart';
import 'login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'popularmovie.dart';

String tulisan = "";
String user_aktif = "";
bool pembuka = true;

Future<String> cekLogin() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    String user_id = prefs.getString("user_id") ?? '';
    return user_id;
  } catch (e) {
    print('error karena $e');
  }
}

Future<int> getTopScore() async {
  //nantinya ada pengecekan master_user melalui webservice
  try {
    final prefs = await SharedPreferences.getInstance();

    int top_score = prefs.getInt('top_score') ?? '';
    print(top_score.runtimeType);
    return top_score;
  } catch (e) {
    // print('error top skor $e');
  }
}

class Makanan {
  String nama;
  String foto;
  String deskripsi;
  Makanan(String _nama, String _foto, String _deskripsi) {
    nama = _nama;
    foto = _foto;
    deskripsi = _deskripsi;
  }
}

class MovieObj {
  String title;
  String genre;
  String synopsis;
  String photo;
  MovieObj(this.title, this.genre, this.synopsis, this.photo);
}

List<Makanan> MenuMakanSiang = [];
List<MovieObj> movies = [];

void main() {
  MenuMakanSiang.add(Makanan(
      'Sup Bola Daging Sapi',
      'https://www.masakapahariini.com/wp-content/uploads/2019/04/Sup-bola-daging-780x440.jpg',
      'Semangkuk sup bola daging sapi sayuran hangat yang susah ditolak. '));
  MenuMakanSiang.add(Makanan(
      'Cumi Crispy Saos Madu',
      'https://www.masakapahariini.com/wp-content/uploads/2019/04/cumi-crispy-saus-madu-780x440.jpg',
      'Cumi Crispy Saus Madu, paling tepat dipadukan dengan beragam sup saat makan siang.'));

  movies.add(MovieObj(
      'Avenger Infinity War',
      'action',
      'Iron Man, Thor, the Hulk and the rest of the Avengers unite to battle their most powerful enemy yet -- the evil Thanos. On a mission to collect all six Infinity Stones, Thanos plans to use the artifacts to inflict his twisted will on reality. ',
      'http://ubaya.prototipe.net/s160418012/images/5.jpg'));
  movies.add(MovieObj(
      'Joker',
      'action',
      'Forever alone in a crowd, failed comedian Arthur Fleck seeks connection as he walks the streets of Gotham City. Arthur wears two masks -- the one he paints for his day job as a clown, and the guise he projects in a futile attempt to feel like he is part of the world around him. ',
      'http://ubaya.prototipe.net/s160418012/images/5.jpg'));
  movies.add(MovieObj(
      'OnWard',
      'comedy',
      'Teenage elf brothers Ian and Barley embark on a magical quest to spend one more day with their late father. Like any good adventure, their journey is filled with cryptic maps, impossible obstacles and unimaginable discoveries.',
      'http://ubaya.prototipe.net/s160418012/images/5.jpg'));
  movies.add(MovieObj(
      'Knives Out',
      'action',
      'The circumstances surrounding the death of crime novelist Harlan Thrombey are mysterious, but there is one thing that renowned Detective Benoit Blanc knows for sure -- everyone in the wildly dysfunctional Thrombey family is a suspect. ',
      'http://ubaya.prototipe.net/s160418012/images/5.jpg'));
  movies.add(MovieObj(
      'The Invisible Man',
      'horror',
      'After staging his own suicide, a crazed scientist uses his power to become invisible to stalk and terrorize his ex-girlfriend. When the police refuse to believe her story, she decides to take matters into her own hands and fight back ',
      'http://ubaya.prototipe.net/s160418012/images/7.jpg'));
  movies.add(MovieObj(
      'Despicable Me 3',
      'comedy',
      'The mischievous Minions hope that Gru will return to a life of crime after the new boss of the Anti-Villain League fires him. Instead, Gru decides to remain retired and travel to Freedonia to meet his long-lost twin brother for the first time',
      'http://ubaya.prototipe.net/s160418012/images/8.jpg'));

  WidgetsFlutterBinding.ensureInitialized();
  cekLogin().then((String result) {
    if (result == '')
      runApp(MyLogin());
    else {
      user_aktif = result;
      runApp(MyApp());
    }
  });
  getTopScore().then((int result) {
    if (result == null) {
      // print('result = ' + result.toString() + ' nilai= ' + nilai.toString());
      result = 0;
    } else {
      print('ini jalan di main. result= ' + result.toString());
    }
  });

  // runApp(MyApp());
// runApp(MyLogin());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String _newNamaMakanan;
  String _newFotoMakanan;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  void tambahTulisan(Runes r) {
    setState(() {
      tulisan += String.fromCharCodes(r);
    });
  }

  Widget widgetweek2() {
    return Container(
        height: 2000,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              //widget2 di week sebelumnya
              Divider(),
              Image(
                  image: AssetImage(
                    "assets/images/logo.png",
                  ),
                  fit: BoxFit.cover,
                  width: 100,
                  height: 100),
              Divider(),
              Container(
                  height: 200,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      //isikan row disini
                      Row(
                        children: <Widget>[
                          Image.network(
                              'http://ubaya.prototipe.net/s160418012/images/1.jpg',
                              width: 100),
                          Image.network(
                              'http://ubaya.prototipe.net/s160418012/images/2.jpg',
                              width: 100),
                          Image.network(
                              'http://ubaya.prototipe.net/s160418012/images/3.jpg',
                              width: 100),
                          Image.network(
                              'http://ubaya.prototipe.net/s160418012/images/4.jpg',
                              width: 100),
                          Image.network(
                              'http://ubaya.prototipe.net/s160418012/images/5.jpg',
                              width: 100),
                          Image.network(
                              'http://ubaya.prototipe.net/s160418012/images/6.jpg',
                              width: 100),
                        ],
                      ),
                    ],
                  )),
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 300,
                    width: 300,
                    margin: EdgeInsets.all(40),
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius:
                            BorderRadius.all(Radius.elliptical(50, 50)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            spreadRadius: 5,
                            blurRadius: 3,
                            offset: Offset(0, 1), // changes position of shadow
                          ),
                        ],
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                                'http://ubaya.prototipe.net/s160418012/images/2.jpg'))),
                  ),
                  Image.network(
                    'http://ubaya.prototipe.net/soldout.png',
                  )
                ],
              ),
              Image.network(
                'http://ubaya.prototipe.net/s160418012/images/1.jpg',
              ),
            ]));
  }

  Widget _generateCardMakanan(index) {
    return new Card(
        elevation: 10,
        margin: EdgeInsets.all(20),
        child: Container(
            padding: EdgeInsets.all(20),
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              Text(MenuMakanSiang[index].nama, style: TextStyle(fontSize: 30)),
              Image.network(MenuMakanSiang[index].foto, width: 300),
              Text(MenuMakanSiang[index].deskripsi,
                  style: TextStyle(fontSize: 16)),
            ])));
  }

  Widget week3() {
    return Container(
      // Center is a layout widget. It takes a single child and positions it
      // in the middle of the parent.
      child: Column(
        // Column is also a layout widget. It takes a list of children and
        // arranges them vertically. By default, it sizes itself to fit its
        // children horizontally, and tries to be as tall as its parent.
        //
        // Invoke "debug painting" (press "p" in the console, choose the
        // "Toggle Debug Paint" action from the Flutter Inspector in Android
        // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
        // to see the wireframe for each widget.
        //
        // Column has various properties to control how it sizes itself and
        // how it positions its children. Here we use mainAxisAlignment to
        // center the children vertically; the main axis here is the vertical
        // axis because Columns are vertical (the cross axis would be
        // horizontal).
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            '$tulisan',
            style: TextStyle(fontSize: 30),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FlatButton(
                onPressed: () {
                  tambahTulisan(Runes('\u{1F44D}'));
                },
                child: Text(String.fromCharCodes(Runes('\u{1F44D}')),
                    style: TextStyle(fontSize: 30)),
              ),
              FlatButton(
                  minWidth: 8.0,
                  onPressed: () {
                    tambahTulisan(Runes('\u{2764}'));
                  },
                  child: Text(String.fromCharCodes(Runes('\u{2764}')),
                      style: TextStyle(fontSize: 30))),
              FlatButton(
                minWidth: 8.0,
                onPressed: () {
                  tambahTulisan(Runes('\u{1F606}'));
                },
                child: Text(String.fromCharCodes(Runes('\u{1F606}')),
                    style: TextStyle(fontSize: 30)),
              ),
              FlatButton(
                minWidth: 8.0,
                onPressed: () {
                  tambahTulisan(Runes('\u{1F62E}'));
                },
                child: Text(String.fromCharCodes(Runes('\u{1F62E}')),
                    style: TextStyle(fontSize: 30)),
              ),
              FlatButton(
                minWidth: 8.0,
                onPressed: () {
                  tambahTulisan(Runes('\u{1F625}'));
                },
                child: Text(String.fromCharCodes(Runes('\u{1F625}')),
                    style: TextStyle(fontSize: 30)),
              ),
              FlatButton(
                minWidth: 8.0,
                onPressed: () {
                  tambahTulisan(Runes('\u{1F621}'));
                },
                child: Text(String.fromCharCodes(Runes('\u{1F621}')),
                    style: TextStyle(fontSize: 30)),
              ),
            ],
          ),
          TextFormField(
            decoration: const InputDecoration(
              icon: Icon(Icons.new_releases),
              labelText: 'Nama Makanan',
            ),
            onChanged: (value) {
              _newNamaMakanan = value;
            },
          ),
          TextFormField(
            decoration: const InputDecoration(
              icon: Icon(Icons.new_releases),
              labelText: 'Foto Makanan',
            ),
            onChanged: (value) {
              _newFotoMakanan = value;
            },
          ),
          FlatButton(
              onPressed: () {
                print(_newNamaMakanan);
              },
              child: Text("Tambah Makanan")),
          Expanded(
              child: ListView.builder(
                  itemCount: MenuMakanSiang.length,
                  itemBuilder: (BuildContext ctxt, int index) {
                    return _generateCardMakanan(index);
                  }))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text("My Movie App"),
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.movie)),
              Tab(icon: Icon(Icons.theaters)),
              Tab(icon: Icon(Icons.shopping_cart)),
              Tab(icon: Icon(Icons.person)),
            ],
          ),
        ), //body nanti ditaruh sini

        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Text('Welcome: ' + user_aktif),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('assets/images/bg.jpg'),
                  ),
                ),
              ),
              ListTile(
                title: Text('Popular Movies'),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => PopularMovie()));
                },
              ),
              ListTile(
                title: Text('List Actor'),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => actorList()));
                },
              ),
              // ListTile(
              //   title: Text('Action Movies'),
              //   onTap: () {
              //     Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //             builder: (context) => GenreMovie('action')));
              //   },
              // ),
              // ListTile(
              //   title: Text('Horror Movies'),
              //   onTap: () {
              //     Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //             builder: (context) => GenreMovie('horror')));
              //   },
              // ),
              // ListTile(
              //   title: Text('Comedy Movies'),
              //   onTap: () {
              //     Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //             builder: (context) => GenreMovie('comedy')));
              //   },
              // ),
              // ListTile(
              //   title: Text('Quiz'),
              //   onTap: () {
              //     Navigator.push(
              //         context, MaterialPageRoute(builder: (context) => Quiz()));
              //   },
              // ),
              // ListTile(
              //   title: Text('Animasi'),
              //   onTap: () {
              //     Navigator.push(context,
              //         MaterialPageRoute(builder: (context) => Animasi()));
              //   },
              // ),
              // ListTile(
              //   title: Text('Top user & score'),
              //   onTap: () {
              //     Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //             builder: (context) => Nilaipemain(nilai)));
              //   },
              // ),
              ListTile(
                title: Text('Logout'),
                onTap: () {
                  doLogout();
                },
              ),
            ],
          ),
        ),

        body: TabBarView(
          children: [
            // Tab 1
            GridView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: movies.length,
                gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                      elevation: 5,
                      margin: EdgeInsets.all(5),
                      child: Column(children: <Widget>[
                        GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          DetailMovie(index)));
                            },
                            child: Text("data")
                            // Image.network(
                            //     'http://ubaya.prototipe.net/emertech160416073/1.png',
                            //     // movies[index].photo,
                            //     height: 150)
                            ),
                        Text(movies[index].title)
                      ]));
                }),
            // Tab 2
            week3(),
            // Tab 3
            Text("ini isi tab ketiga"),
            // Tab 4
            Text("ini isi tab keempat"),
          ],
        ),
      ),
    );
  }
}
