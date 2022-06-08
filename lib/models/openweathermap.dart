class Openweathermap {
  final ChildWeather weather;
  final ChildMain main;

  Openweathermap(this.weather, this.main);
}

class ChildWeather {
  final String main;

  ChildWeather(this.main);
}

class ChildMain {
  final double temp;

  ChildMain(this.temp);
}

const String tableCities = 'cities';

class CityFields {
  static const String id = '_id';
  static const String name = '_name';

  static final List<String> values = [id, name];
}

class City {
  final int? id;
  final String name;

  const City({this.id, required this.name});

  Map<String, Object?> toJson() => {
        CityFields.id: id,
        CityFields.name: name,
      };

  City copy({
    int? id,
    String? name,
  }) =>
      City(
        id: id ?? this.id,
        name: name ?? this.name,
      );

  static City fromJson(Map<String, Object?> json) => City(
      id: json[CityFields.id] as int?, name: json[CityFields.name] as String);
}
