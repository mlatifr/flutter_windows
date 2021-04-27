import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class Animasi extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AnimasiState();
  }
}

bool animated = false;

class _AnimasiState extends State<Animasi> {
  Timer _timer;

  double _opacity = 1.0;
  int _posisi = 1;
  double _left = 0;
  double _right = 0;
  double _bottom = 0;
  double _top = 0;

  @override
  void initState() {
    super.initState();
    _timer = new Timer.periodic(new Duration(milliseconds: 1000), (timer) {
      setState(() {
        animated = !animated;
        _opacity = 1.0 - _opacity;
        _posisi++;
        if (_posisi > 4) _posisi = 1;
        if (_posisi == 1) {
          _left = 300;
          _right = 0;
          _bottom = 300;
          _top = 0;
        }
        if (_posisi == 2) {
          _left = 0;
          _right = 300;
          _bottom = 300;
          _top = 0;
        }
        if (_posisi == 3) {
          _left = 0;
          _right = 300;
          _bottom = 0;
          _top = 300;
        }
        if (_posisi == 4) {
          _left = 300;
          _right = 0;
          _bottom = 0;
          _top = 300;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('coba2 animasi'),
        ),
        body: ListView(children: <Widget>[
          TweenAnimationBuilder(
            child: Image.asset('assets/images/earth.png'),
            duration: const Duration(seconds: 5),
            tween: ColorTween(begin: Colors.blue, end: Colors.red),
            builder: (_, Color color, Widget child) {
              return ColorFiltered(
                colorFilter: ColorFilter.mode(color, BlendMode.modulate),
                child: child,
              );
            },
          ),
          Divider(color: Colors.black),
          TweenAnimationBuilder(
            duration: const Duration(seconds: 20),
            curve: Curves.easeInOutExpo,
            tween: Tween<double>(begin: 0, end: 50 * math.pi),
            builder: (_, double angle, __) {
              return Transform.rotate(
                angle: angle,
                child: Image.asset('assets/images/earth.png'),
              );
            },
          ),
          Divider(color: Colors.black),
          Stack(alignment: Alignment.center, children: [
            AnimatedOpacity(
              opacity: _opacity,
              duration: Duration(seconds: 1),
              child: Image.network(
                  'http://ubaya.prototipe.net/s160418012/images/2.jpg'),
            ),
            Divider(color: Colors.black),
            AnimatedOpacity(
              opacity: 1.0 - _opacity,
              duration: Duration(seconds: 1),
              child: Image.network(
                  'http://ubaya.prototipe.net/s160418012/images/1.jpg'),
            ),
            Divider(color: Colors.black),
            AnimatedPositioned(
              duration: const Duration(seconds: 1),
              curve: Curves.fastOutSlowIn,
              left: _left,
              top: _top,
              right: _right,
              bottom: _bottom,
              child: Image(
                  image: AssetImage(
                    "assets/images/ball.png",
                  ),
                  fit: BoxFit.scaleDown,
                  width: 30,
                  height: 30),
            ),
            Divider(color: Colors.black),
            AnimatedContainer(
              width: animated ? 10 : 500,
              child: Image.asset('assets/images/star.png'),
              duration: Duration(seconds: 1),
            ),
          ]),
          AnimatedDefaultTextStyle(
            child: Center(child: Text('Hello')),
            style: animated
                ? TextStyle(
                    color: Colors.blue,
                    fontSize: 60,
                  )
                : TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                  ),
            duration: Duration(milliseconds: 1000),
          ),
          TextButton(
            child: Text('Animate'),
            onPressed: () {
              setState(() {
                animated = !animated;
              });
            },
          ),
          Divider(color: Colors.black),
        ]));
  }
}
