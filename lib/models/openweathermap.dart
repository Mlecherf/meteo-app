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
