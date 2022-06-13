import 'package:flutter/material.dart';
import 'package:meteo_app/db/data.dart';
import 'package:meteo_app/models/openweathermap.dart';
import 'package:meteo_app/models/daily.dart';
import 'package:meteo_app/models/weekly.dart';
import 'package:meteo_app/services/api_openweathermap.dart';

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
  late Data database;
  late List<City> cities;
  late int length;
  @override
  void initState() {
    super.initState;
    Data.instance.initDB("./db");
    refreshCities();
  }

  Future refreshCities() async {
    cities = await Data.instance.readAllCities();
    length = await Data.instance.readAllCities().then((value) {
      return value.length;
    });
  }

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
                      setState(() {
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
                                        setState(() {
                                          Data.instance
                                              .create(City(name: value));
                                          Navigator.pop(context);
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ));
                            });
                      });
                    },
                    child: const Text('Add a city'),
                  ),
                  const SizedBox(height: 30),
                ]),
              ),
              FutureBuilder<List<City>>(
                future: Data.instance.readAllCities(),
                builder: (ctx, snapshot) {
                  // Checking if future is resolved
                  // If we got an error
                  String data = "None";
                  // Extracting data from snapshot object
                  if (snapshot.hasData) {
                    return ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            hoverColor:
                                const Color.fromARGB(255, 135, 135, 136),
                            textColor: const Color.fromARGB(255, 255, 255, 255),
                            title: Text(snapshot.data![index].name),
                            onTap: () {},
                            leading: IconButton(
                              icon:
                                  const Icon(Icons.delete, color: Colors.white),
                              onPressed: () {
                                setState(() {
                                  Navigator.pop(context);
                                  Data.instance
                                      .delete(snapshot.data![index].id!);
                                });
                              },
                            ),
                          );
                        });
                  }
                  return Container();
                },
              ),
            ],
          ),
        ),
        body: Center(
          child: FutureBuilder<Daily>(
            future: getDailyDataAPI("Brest"),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: Text("Chargement en cours..."));
              } else if (snapshot.connectionState == ConnectionState.done) {
                return Stack(children: <Widget>[
                  Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/chilly_night.jpg"),
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                  Row(children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.fromLTRB(10, 80, 0, 0),
                    ),
                    IconButton(
                      icon:
                          const Icon(Icons.menu, color: Colors.white, size: 40),
                      onPressed: () {
                        _scaffoldState.currentState!.openDrawer();
                      },
                    )
                  ]),
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
                      Text(
                        "Test",
                        //snapshot.data!.name.toString(),
                        style: const TextStyle(
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
                      Text(
                        snapshot.data!.main!.temp.toString(),
                        style: const TextStyle(
                            color: Colors.white, fontSize: 70.0),
                      ),
                    ]),
                  ),
                  FutureBuilder<Weekly>(
                      future: getWeeklyDataAPI(
                          snapshot.data!.coord!.lat!.toDouble(),
                          snapshot.data!.coord!.lon!.toDouble()),
                      builder: (context1, snapshot1) {
                        if (snapshot1.hasData) {
                          return Container(
                            margin:
                                const EdgeInsets.only(top: 400.0, bottom: 136),
                            padding: const EdgeInsets.all(3.0),
                            decoration: const BoxDecoration(
                                color: Color.fromARGB(126, 46, 46, 46),
                                border: Border(
                                    top: BorderSide(
                                        color: Color.fromARGB(255, 0, 0, 0)),
                                    bottom: BorderSide(
                                        color: Color.fromARGB(255, 0, 0, 0)))),
                            child: Row(children: <Widget>[
                              const SizedBox(width: 10),
                              Column(children: <Widget>[
                                const Text(
                                  "Tomorrow",
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 25.0),
                                ),
                              ]),
                              const Spacer(),
                              Column(children: <Widget>[
                                Text(
                                  "Test",
                                  //snapshot1.data!.daily![0].temp!.day
                                  //    .toString(),
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 25.0),
                                ),
                                Text(
                                  "Test",
                                  //snapshot1.data!.daily![0].weather![0].main
                                  //    .toString(),
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15.0),
                                )
                              ]),
                              const SizedBox(width: 10),
                            ]),
                          );
                        }
                        return Container();
                      })
                ]);
              } else {
                return const Text("Une erreur est survenue");
              }
            },
          ),
        ));
  }

  Widget buildCities() {
    return FutureBuilder(
      builder: (ctx, snapshot) {
        // Checking if future is resolved
        if (snapshot.connectionState == ConnectionState.done) {
          // If we got an error
          if (snapshot.hasError) {
            return Center(
              child: Text(
                '${snapshot.error} occurred',
                style: TextStyle(fontSize: 18),
              ),
            );

            // if we got our data
          } else if (snapshot.hasData) {
            // Extracting data from snapshot object
            final data = snapshot.data as String;
            return Center(
              child: Text(
                '$data',
                style: TextStyle(fontSize: 18),
              ),
            );
          }
        }
        throw new Error();
      },
      future: Data.instance.readAllCities(),
    );
  }
}
