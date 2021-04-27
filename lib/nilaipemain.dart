import 'package:flutter/material.dart';
import 'main.dart';
import 'quiz.dart';

import 'package:shared_preferences/shared_preferences.dart';

String top_user;
int top_score;

class Nilaipemain extends StatelessWidget {
  Nilaipemain(this.nilaiPemain);
  int nilaiPemain;

  void doTopUser() async {
    top_user = user_aktif;
    //nantinya ada pengecekan master_user melalui webservice
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("top_user", top_user);
    main();
  }

  void doTopScore() async {
    top_score = nilaiPemain;
    print('nilai pemain adahal: $nilaiPemain');
    //nantinya ada pengecekan master_user melalui webservice
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt("top_score", top_score);
    main();
  }

  void removeTopUser() async {
    //nantinya ada pengecekan master_user melalui webservice
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("top_user");
    main();
  }

  void removeTopScore() async {
    //nantinya ada pengecekan master_user melalui webservice
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("top_score");
    main();
  }

  Widget tampilanSkor(BuildContext context) {
    Text("Nilai kamu adalah: " + nilaiPemain.toString());
    Text('Top_User adalah: ' + top_user.toString());
    Text('Top_score adalah: ' + top_score.toString());
    TextButton(
      onPressed: () {
        nilai = 0;
        print('Nilai setelah di nolkan= ' + nilai.toString());
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
        main();
      },
      child: Text("Home Page"),
    );
  }

  Widget aturSkor() {
    print(top_score.toString() +
        " top_score nilaiPemain " +
        nilaiPemain.toString() +
        ' 1');
    if (top_score == null) {
      doTopUser();
      doTopScore();
    }
    if (top_score < nilaiPemain) {
      removeTopUser();
      removeTopScore();
      doTopUser();
      doTopScore();
    }
    print(top_score.toString() +
        " top_score nilaiPemain " +
        nilaiPemain.toString() +
        ' 2');
  }

  @override
  Widget build(BuildContext context) {
    // nilaiPemain = nilaiPemain.toInt();
    // doTopScore();
    aturSkor();
    return Scaffold(
        appBar: AppBar(
          title: Text('Skor Pemain'),
        ),
        body: ListView(children: <Widget>[
          tampilanSkor(context),
        ]));
  }
}
