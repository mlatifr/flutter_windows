import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'nilaipemain.dart';
import 'main.dart';
int hitung = 10;
int nomor_pertanyaan = 0;
int nilai = 0;


class PertanyaanObj {
  String pertanyaan;
  String pilihan_a;
  String pilihan_b;
  String pilihan_c;
  String pilihan_d;
  String jawaban,url;

  PertanyaanObj(this.pertanyaan, this.pilihan_a, this.pilihan_b, this.pilihan_c,
      this.pilihan_d, this.jawaban, this.url);
}

List<PertanyaanObj> pertanyaans = [];


class Quiz extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    pertanyaans.add(PertanyaanObj("1 Siapakah nama artis ini? ",'ana', 'nasi', 'sina', 'nisa sabyan', 'nisa sabyan','https://cdn0-production-images-kly.akamaized.net/VTHvVO4Ir9BLt7G92YaeJrQEsVY=/640x360/smart/filters:quality(75):strip_icc():format(jpeg)/kly-media-production/medias/2262942/original/004909000_1530233351-aaa.jpg'));
    pertanyaans.add(PertanyaanObj("2 Apakah judul yang tepat untuk film ini", 'supriman','supirman', 'superman', 'surpriseman', 'superman','https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTk1RqOebSCC5emGHeU8ITVG0zxf5_xkD1XYw&usqp=CAU'));
    pertanyaans.add(PertanyaanObj("3 Apa jenis hewan dalam tokoh Barney", 'Terong ungu','terong-terongan', 'dinosaurus', 'kadal', 'dinosaurus','https://i.pinimg.com/564x/69/36/a8/6936a88475c5073a5c10aacedcc24584.jpg'));
    pertanyaans.add(PertanyaanObj("4 Jenis robot apakahdoraemon itu?",'anjing', 'kucing', 'musang', 'rubah', 'kucing','https://s0.bukalapak.com/img/59365611631/large/data.png'));
    pertanyaans.add(PertanyaanObj("5 Ranger apa yang tidak ada di foto?", 'kuning','putih', 'biru', 'merah', 'putih','https://assets.pikiran-rakyat.com/crop/0x0:0x0/x/photo/2020/08/07/1909320029.jpg'));
    pertanyaans.add(PertanyaanObj("6 Apa yang dilakukan kedua orang ini?", 'terbang','bermain layang-layang', 'berdiri diujung kapal', 'mengeringkan baju', 'berdiri diujung kapal','https://img.cinemablend.com/filter:scale/quill/7/f/f/2/d/c/7ff2dca8b628deb838445a3dc2561d9889047620.jpg?mw=600'));
    pertanyaans.add(PertanyaanObj("7 Siapa nama kembaran upin?",'afin', 'ipan', 'ipin', 'apin', 'ipin','https://assets.pikiran-rakyat.com/crop/190x94:735x545/x/photo/2020/07/04/3944835781.jpg'));
    pertanyaans.add(PertanyaanObj("8 Apakah judul film ini?", 'detective conan','enola holmes', 'detektif masa kini', 'sherlockholmes', 'detective conan','https://www.gramedia.com/blog/content/images/2018/10/Fakta-Conan-Edogawa-4.jpg'));
    pertanyaans.add(PertanyaanObj("9 Apa namadesa yang ditempati naruto?", 'rungkut','margorejo', 'bratang', 'konoha', 'konoha','https://akcdn.detik.net.id/visual/2020/07/06/naruto-1_169.png?w=650'));
    pertanyaans.add(PertanyaanObj("10 Apa nama mainan dari film diatas?",'crush gear', 'gangsing', 'tamiya', 'RC Drift', 'tamiya','http://imageshack.com/a/img924/9083/E7SUWp.jpg'));
    pertanyaans.add(PertanyaanObj("", '','', '', '', '',''));
    return _QuizState();
  }
}

class _QuizState extends State<Quiz> {
  Timer _timer;
  @override
  void initState() {
    super.initState();
    _timer = new Timer.periodic(new Duration(milliseconds: 1000), (timer) {
      setState(() {
        hitung--;
        if (hitung == 0) {
          nomor_pertanyaan++;
          hitung = 10;
          if(nomor_pertanyaan==10){
            _timer.cancel();
            showAlertDialog(context);
            }
        }
      });
    });
  }

  void cekjawaban(String s) {
    setState(() {
      if (s == pertanyaans[nomor_pertanyaan].jawaban) {
        nilai += 100;
      }
      nomor_pertanyaan++;
      hitung = 10;
      if(nomor_pertanyaan==10){
        _timer.cancel();
        showAlertDialog(context);
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    hitung = 10;
    super.dispose();
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget OkButton = TextButton(
      child: Text("Ok"),
      onPressed: () {
        // Navigator.of(context).pop();
        nomor_pertanyaan=0;
        print('nilai = '+nilai.toString());
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Nilaipemain(nilai)));
        
        print('nomor_pertanyaan = '+nomor_pertanyaan.toString()+ ' nilai = '+nilai.toString());
        
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Skor: "+nilai.toString()),
      content: Text("Quiz telah selesai !"),
      actions: [
        OkButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  String formatTime(int hitung) {
    var secs = hitung;
    var hours = (secs ~/ 3600).toString().padLeft(2, '0');
    var minutes = ((secs % 3600) ~/ 60).toString().padLeft(2, '0');
    var seconds = (secs % 60).toString().padLeft(2, '0');
    return "$hours:$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz'),
      ),
      body: Center(
          child: Column(children: <Widget>[
        Text(formatTime(hitung), style: TextStyle(fontSize: 30)),
        Image.network(pertanyaans[nomor_pertanyaan].url, width: 180,),
        Text(pertanyaans[nomor_pertanyaan].pertanyaan),        
        TextButton(
            onPressed: () {
              cekjawaban(pertanyaans[nomor_pertanyaan].pilihan_a);
            },
            child: Text("A. " + pertanyaans[nomor_pertanyaan].pilihan_a)),
        TextButton(
            onPressed: () {
              cekjawaban(pertanyaans[nomor_pertanyaan].pilihan_b);
            },
            child: Text("B. " + pertanyaans[nomor_pertanyaan].pilihan_b)),
        TextButton(
            onPressed: () {
              cekjawaban(pertanyaans[nomor_pertanyaan].pilihan_c);
            },
            child: Text("C. " + pertanyaans[nomor_pertanyaan].pilihan_c)),
        TextButton(
            onPressed: () {
              cekjawaban(pertanyaans[nomor_pertanyaan].pilihan_d);
            },
            child: Text("D. " + pertanyaans[nomor_pertanyaan].pilihan_d)),
      ])),
    );
  }
}
