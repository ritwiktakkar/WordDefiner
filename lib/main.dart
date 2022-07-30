import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iDefine/definition_model.dart' as definition_model;
import 'package:iDefine/api_requests.dart' as API;
import 'package:flutter/services.dart';
import 'package:string_validator/string_validator.dart';
import 'package:iDefine/dialogs.dart';
import 'package:share/share.dart';
import 'package:auto_size_text/auto_size_text.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
      ),
    );
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return new MaterialApp(
      debugShowCheckedModeBanner: false, // hide debug banner from top left
      theme:
          ThemeData(fontFamily: DefaultTextStyle.of(context).style.fontFamily),
      home: new HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<definition_model.iDefinition> iDefinition;

  // Create a text controller and use it to retrieve the current value of the TextField.
  final inputController = TextEditingController();

  // final ScrollController _scrollController =
  //     ScrollController(initialScrollOffset: 50.0);

  String wordToDefine;
  definition_model.iDefinition definition;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.black, // make background color black
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 50,
                bottom: 20,
              ),
              child: CupertinoSearchTextField(
                placeholder: 'Look up a word',
                controller: inputController,
                onChanged: (String value) {
                  debugPrint('The text has changed to: $value');
                },
                onSubmitted: ((String value) async {
                  debugPrint('Submitted text: $value');
                  definition = await API.getiDefinition(wordToDefine);
                }),
                style: TextStyle(
                  color: CupertinoColors.white,
                ),
                itemColor: CupertinoColors.inactiveGray,
              ),
            ),
            Expanded(
              child: RawScrollbar(
                thumbColor: CupertinoColors.systemGrey,
                thickness: 4,
                radius: Radius.circular(5),
                // thumbVisibility: true,
                child: SingleChildScrollView(
                  // controller: _scrollController,
                  // contains ALL widgets (scrollable)
                  child: Column(
                    children: [
                      Column(
                        // first half widgets columns
                        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text(
                            "Input URL",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.w700),
                          ),
                          Text(
                            "Enter a URL to shorten",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            "Reloaded 1 of 681 libraries in 129ms.\nReloaded 1 of 681 libraries in 134ms.Reloaded 1 of 681 libraries in 129ms.\nReloaded 1 of 681 libraries in 134ms.Reloaded 1 of 681 libraries in 129ms.\nReloaded 1 of 681 libraries in 134ms.Reloaded 1 of 681 libraries in 129ms.\nReloaded 1 of 681 libraries in 134ms.Reloaded 1 of 681 libraries in 129ms.\nReloaded 1 of 681 libraries in 134ms.",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 40,
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
