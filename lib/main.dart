import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldState,
        drawer: Drawer(
          backgroundColor: const Color.fromRGBO(40, 45, 53, 1),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Container(
                decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          color: Color.fromARGB(255, 135, 135, 135))),
                ),
                child: Column(children: <Widget>[
                  const SizedBox(height: 100),
                  const Text('My Cities',
                      style: TextStyle(
                          color: Colors.white, fontStyle: FontStyle.normal)),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                                child: Container(
                              height: 150.0,
                              width: 360.0,
                              child: ListView(
                                children: <Widget>[
                                  SizedBox(height: 20),
                                  const Center(
                                    child: Text(
                                      "Add a city",
                                      style: TextStyle(
                                        fontSize: 24,
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  TextField(
                                    onSubmitted: (String value) async {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ),
                            ));
                          });
                    },
                    child: const Text('Add a city'),
                  ),
                  const SizedBox(height: 30),
                ]),
              ),
              ListTile(
                hoverColor: const Color.fromARGB(255, 135, 135, 136),
                textColor: const Color.fromARGB(255, 255, 255, 255),
                title: Text.rich(
                  TextSpan(
                    style: const TextStyle(
                      fontSize: 17,
                    ),
                    children: [
                      const WidgetSpan(
                          child: SizedBox(
                        width: 110,
                      )),
                      const TextSpan(
                        text: 'Paris',
                      ),
                      const WidgetSpan(
                          child: SizedBox(
                        width: 70,
                      )),
                      WidgetSpan(
                        child: IconButton(
                          icon: const Icon(Icons.delete,
                              color: Color.fromARGB(255, 246, 246, 246)),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
        body: Center(
          child: Stack(children: <Widget>[
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/chilly_night.jpg"),
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            Container(
                child: Row(children: <Widget>[
              const Padding(
                padding: EdgeInsets.fromLTRB(10, 80, 0, 0),
              ),
              IconButton(
                icon: const Icon(Icons.menu, color: Colors.white, size: 40),
                onPressed: () {
                  _scaffoldState.currentState!.openDrawer();
                },
              )
            ])),
            Container(
              alignment: Alignment.topCenter,
              child: Row(children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      ((MediaQuery.of(context).size.width) / 2) - 40,
                      (MediaQuery.of(context).size.height) / 3,
                      0,
                      0),
                ),
                const Text(
                  'Paris',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 35.0),
                ),
              ]),
            ),
            Container(
              alignment: Alignment.topCenter,
              child: Row(children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      ((MediaQuery.of(context).size.width) / 2 - 15),
                      (MediaQuery.of(context).size.height) - 110,
                      0,
                      0),
                ),
                const Text(
                  '9 °',
                  style: TextStyle(color: Colors.white, fontSize: 70.0),
                ),
              ]),
            ),
            Container(
              margin: const EdgeInsets.only(top: 400.0, bottom: 136),
              padding: const EdgeInsets.all(3.0),
              decoration: const BoxDecoration(
                  color: Color.fromARGB(126, 46, 46, 46),
                  border: Border(
                      top: BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
                      bottom: BorderSide(color: Color.fromARGB(255, 0, 0, 0)))),
              child: Row(children: <Widget>[
                const SizedBox(width: 10),
                Column(children: const <Widget>[
                  Text(
                    'Tuesday',
                    style: TextStyle(color: Colors.white, fontSize: 25.0),
                  ),
                ]),
                const Spacer(),
                Column(children: const <Widget>[
                  Text(
                    '9°',
                    style: TextStyle(color: Colors.white, fontSize: 25.0),
                  ),
                  Text(
                    "Cloudy",
                    style: TextStyle(color: Colors.white, fontSize: 15.0),
                  )
                ]),
                const SizedBox(width: 10),
              ]),
            ),
          ]),
        ));
  }
}
