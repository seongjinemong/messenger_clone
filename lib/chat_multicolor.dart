import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ChatmulticolorPage extends StatefulWidget {

  final ismine;

  ChatmulticolorPage({Key key, this.ismine}) : super(key: key);

  @override
  _ChatmulticolorPageState createState() => _ChatmulticolorPageState();
}

class _ChatmulticolorPageState extends State<ChatmulticolorPage> {
  var randomizer = new Random();
  final _chatController = TextEditingController();
  final databaseReference = Firestore.instance;
  final _scrollController = new ScrollController();


  @override
  void initState() {
    print("Selected " + (widget.ismine ? "Gradient" : "Grey"));
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _chatController.dispose();
    super.dispose();
  }

  void addChat() async {
    if (_chatController.text != "") {

      var _chat = _chatController.text;
      _chatController.text = "";

      _scrollController.jumpTo(0.0);

      await databaseReference
          .collection("message")
          .document(
              new DateFormat("yyyy-MM-dd HH:mm:ss").format(new DateTime.now()) +
                  DateTime.now().millisecondsSinceEpoch.toString())
          .setData({'chat': _chat, 'who': widget.ismine});

      print((widget.ismine ? "Gradient" : "Grey") +  " sent \"" + _chat + "\"");
    }
  }

  ColorFiltered _dumpspace(height) {
    return ColorFiltered(
      colorFilter: ColorFilter.mode(Colors.white, BlendMode.values[7]),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: height,
        color: Colors.transparent,
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
        width: MediaQuery.of(context).size.width,
        alignment: _ismine ? Alignment.centerLeft : Alignment.centerRight,
        color: Colors.transparent,
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
            padding: EdgeInsets.only(left: 15, right: 15, top: 7),
            child: Text(
              _chat,
              style: TextStyle(fontSize: 20),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _chatmulticolorbubbles(data) {
    List<Widget> list = [];

    list.add(_dumpspace(10.0));

    //print(data.documents[0]['chat'].toString());

    var _wasme;

    list.add(_chatbubble(
        data.documents[0]['chat'], data.documents[0]['who'], false));

    _wasme = data.documents[0]['who'];

    for (var i = 1; i < data.documents.length; i++) {
      if (data.documents[i]['who'] == true)
        _wasme
            ? list.add(_chatbubble(
                data.documents[i]['chat'], data.documents[i]['who'], true))
            : list.add(_chatbubble(
                data.documents[i]['chat'], data.documents[i]['who'], false));
      else
        _wasme
            ? list.add(_chatbubble(
                data.documents[i]['chat'], data.documents[i]['who'], true))
            : list.add(_chatbubble(
                data.documents[i]['chat'], data.documents[i]['who'], false));
    }

    list.add(_dumpspace(80.0));

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 20,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        title: Text(
          'Chat Gradient Study',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
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
          Center(
            child: Container(
              alignment: Alignment.topCenter,
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                controller: _scrollController,
                reverse: true,
                physics: ClampingScrollPhysics(),
                child: StreamBuilder(
                  stream: Firestore.instance.collection('message').snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Container(
                        padding: EdgeInsets.all(100),
                        color: Colors.transparent,
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.white,
                        ),
                      );
                    }
                    return Column(
                      children: _chatmulticolorbubbles(snapshot.data),
                    );
                  },
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 15,
            child: Container(
              alignment: Alignment.centerLeft,
              width: MediaQuery.of(context).size.width - 20,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black26,
                      blurRadius: 40,
                      offset: Offset(5, 12))
                ],
              ),
              child: Row(
                children: <Widget>[
                  Padding(padding: EdgeInsets.only(right: 20)),
                  Expanded(
                    child: TextField(
                      controller: _chatController,
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 45,
                    child: FlatButton(
                      child: Icon(Icons.send, color: Colors.black54),
                      onPressed: () {
                        addChat();
                      },
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(right: 15)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
