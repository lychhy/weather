import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'consts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _weatherData;
  bool _loading = true;
  final TextEditingController _cityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchWeather('Sihanoukville');
  }

  Future<void> fetchWeather(String city) async {
    setState(() {
      _loading = true;
    });
    final response = await http.get(Uri.parse('$apiUrl?q=$city&appid=$apiKey'));
    if (response.statusCode == 200) {
      setState(() {
        _weatherData = json.decode(response.body);
        _loading = false;
      });
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("lib/images/2.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _cityController,
                    decoration: const InputDecoration(
                      labelText: 'Enter city name',
                      labelStyle: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.search,color: Colors.white),
                  onPressed: () {
                    fetchWeather(_cityController.text);
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : WeatherDisplay(weatherData: _weatherData),
            ),
          ],
        )
      ),
    );
  }
}

class WeatherDisplay extends StatelessWidget {
  final Map weatherData;

  const WeatherDisplay({super.key, required this.weatherData});

  @override
  Widget build(BuildContext context) {
    String iconCode = weatherData['weather'][0]['icon'];
    String iconUrl = 'http://openweathermap.org/img/wn/$iconCode@2x.png';

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.network(iconUrl, ),
            const SizedBox(height: 10),
            Text(
              '${(weatherData['main']['temp'] - 273.15).toStringAsFixed(2)}°C',
              style: const TextStyle(
                color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              '${weatherData['weather'][0]['description']}'.toUpperCase(),
              style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              '${weatherData['name']}',
              style: const TextStyle(color: Colors.white,fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const Divider(
              thickness: 1,
              color: Colors.white,
              indent: 140,
              endIndent: 140,
            ),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Feel like',
                            style: const TextStyle(
                              color: Color.fromRGBO(255,255,255,0.8),
                              fontSize: 21,
                            ),
                          ),
                          Text(
                            '${(weatherData['main']['feels_like'] - 273.15).toStringAsFixed(2)}°C',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(height: 50),
                          const Text(
                            'Pressure',
                            style: TextStyle(
                              color: Color.fromRGBO(255,255,255,0.8),
                              fontSize: 21,
                            ),
                          ), 
                          Text(
                            '${weatherData['main']['pressure']} hPa',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),                                const SizedBox(height: 50),
                          const Text(
                            'Wind Direction',
                            style: const TextStyle(
                              color: Color.fromRGBO(255,255,255,0.8),
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            '${weatherData['wind']['deg']}°',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(width: 16),
                              const Text(
                                'Humidity',
                                style: const TextStyle(
                                  color: Color.fromRGBO(255,255,255,0.8),
                                  fontSize: 20,
                                ),
                              ),
                               Text(
                                '${weatherData['main']['humidity']}%',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                              const Divider(
                                height: 50,
                                color: Colors.black,
                                thickness: 1,
                                indent: 5,
                                endIndent: 5,
                              ),
                              const Text(
                                'Wind Speed',
                                style: TextStyle(
                                  color: Color.fromRGBO(255,255,255,0.8),
                                  fontSize: 20,
                                ),
                              ),
                              Text(
                                '${weatherData['wind']['speed']} m/s',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
