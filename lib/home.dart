import 'package:flutter/material.dart';

import 'package:messenger_clone/chat_multicolor.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        margin:
            EdgeInsets.only(top: MediaQuery.of(context).size.height / 2 - 50),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Text(
                'Select your side',
                style: TextStyle(fontSize: 23),
              ),
            ),
            Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Positioned(
                  top: MediaQuery.of(context).size.height / 2 - 100,
                  child: Text('Select your side'),
                ),
                Container(
                  width: 200,
                  height: 55,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.pinkAccent,
                        Colors.deepPurpleAccent,
                        Colors.lightBlue,
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _chatbubble("Grey", false, false),
                    _chatbubble("Gradient", true, false),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  ColorFiltered _chatbubble(_chat, _ismine, _issame) {
    /*var width =
        (randomizer.nextInt(MediaQuery.of(context).size.width.toInt() - 200) +
                40)
            .toDouble();*/

    _ismine = !_ismine;

    return ColorFiltered(
      colorFilter: ColorFilter.mode(
          Colors.white, _ismine ? BlendMode.values[4] : BlendMode.values[7]),
      child: Container(
        //alignment: _ismine ? Alignment.centerLeft : Alignment.centerRight,
        color: Colors.transparent,
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) =>
                    ChatmulticolorPage(ismine: !_ismine),
              ),
            );
          },
          child: Container(
            //width: width > 300 ? 300 - randomizer.nextInt(150).toDouble() : width,
            height: 40,
            //height: randomizer.nextInt(5) == 1 ? 80 : 40,
            margin: EdgeInsets.only(top: _issame ? 5 : 15, right: 10, left: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: Colors.grey.withOpacity(0.3),
            ),
            child: Container(
              height: 40,
              padding: EdgeInsets.only(left: 15, right: 15, top: 7),
              child: Text(
                _chat,
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
