import 'dart:convert';

import 'package:avatar_glow/avatar_glow.dart';

import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:speech_to_text/speech_to_text.dart';

class bot extends StatefulWidget {
  const bot({super.key});

  @override
  State<bot> createState() => _botState();
}

class _botState extends State<bot> {
  bool ispressed = false;
  bool islisting = false;
  SpeechToText speech = SpeechToText();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    make();
  }

  make() async {
    islisting = await speech.initialize();
    setState(() {});
  }

  ChatUser myself = ChatUser(id: "1", firstName: "sinoj");
  ChatUser bot = ChatUser(id: "2", firstName: "jesvin");

  List<ChatMessage> allmessage = [];
  List<ChatUser> typing = [];

  setMeassage(ChatMessage m) async {
    typing.add(bot);
    allmessage.insert(0, m);

    const url =
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=AIzaSyD3DMiSWbkGf3rKOdisfKq43u8TBWy44Ds';
    var header = {
      'Content-Type': ' application/json',
    };

    var data = {
      "contents": [
        {
          "parts": [
            {"text": m.text}
          ]
        }
      ]
    };
    setState(() {});

    try {
      await http
          .post(Uri.parse(url), headers: header, body: jsonEncode(data))
          .then((value) {
        if (value.statusCode == 200) {
          var result = jsonDecode(value.body);

          ChatMessage m1 = ChatMessage(
              text: result['candidates'][0]['content']['parts'][0]['text'],
              user: bot,
              createdAt: DateTime.now());
          allmessage.insert(0, m1);
          setState(() {});
        }
      });
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
    typing.remove(bot);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DashChat(
          typingUsers: typing,
          inputOptions: InputOptions(
            leading: [Voice()],
            autocorrect: true,
            alwaysShowSend: true,
            inputToolbarMargin: EdgeInsets.all(15),
            inputTextStyle: TextStyle(color: Colors.black),
          ),
          currentUser: myself,
          onSend: (ChatMessage m) {
            setMeassage(m);
          },
          messages: allmessage),
    );
  }

  Voice() {
    return AvatarGlow(
      animate: ispressed,
      child: GestureDetector(
        onTapDown: (value) {
          setState(() {
            ispressed = true;
          });

          if (islisting) {
            speech.listen(onResult: (value) {
              setState(() {
                String audio_to_text = value.recognizedWords;
                setMeassage(ChatMessage(
                    user: ChatUser(id: "1"),
                    createdAt: DateTime.now(),
                    text: audio_to_text));
              });
            });
          }
        },
        onTapUp: (value) {
          setState(() {
            ispressed = false;
          });
        },
        child: Container(
          child: Icon(Icons.mic),
        ),
      ),
    );
  }
}
