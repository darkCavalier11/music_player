import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:music_player/screens/home_screen/widgets/search_text_field.dart';

class MusicSearchScreen extends StatefulWidget {
  const MusicSearchScreen({Key? key}) : super(key: key);

  static const routeScreen = "/musicSearchScreen";

  @override
  State<MusicSearchScreen> createState() => _MusicSearchScreenState();
}

class _MusicSearchScreenState extends State<MusicSearchScreen> {
  late TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.of(context).pop();
      }),
      body: Padding(
        padding: const EdgeInsets.only(left: 24, right: 24, top: 64),
        child: Material(
          child: Column(
            children: [
              Hero(
                tag: 'search',
                child: SearchTextField(
                  textEditingController: _textEditingController,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
