import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:p12_evaluasi/weather.dart';

class WeatherView extends StatelessWidget {
  final String cityName;

  const WeatherView({Key? key, required this.cityName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Weather>(
      future: _fetchWeather(cityName),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
              child: Text("${snapshot.error}",
                  style: TextStyle(color: Colors.red, fontSize: 18)));
        } else if (snapshot.hasData) {
          Weather? data = snapshot.data;
          return _weatherView(data);
        }
        return const Center(
          child: Text('No data available', style: TextStyle(fontSize: 18)),
        );
      },
    );
  }

  Future<Weather> _fetchWeather(String cityName) async {
    var uri = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=d7729ca0c7371c091f4a6a491a12b64f');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      return Weather.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load weather data from API');
    }
  }

  Widget _weatherView(Weather? data) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        color: Colors.blue.shade50,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'City: ${data?.cityName}',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Cuaca: ${data?.main} - ${data?.description}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'Suhu: ${data?.tempCelsius.toStringAsFixed(2)}°C',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'Terasa: ${data?.feelsLikeCelsius.toStringAsFixed(2)}°C',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'Suhu Minimum: ${data?.tempMinCelsius.toStringAsFixed(2)}°C',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'Suhu Maksimum: ${data?.tempMaxCelsius.toStringAsFixed(2)}°C',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'Tekanan: ${data?.pressure} hPa',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'Kelembapan: ${data?.humidity}%',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'Kecepatan angin: ${data?.windSpeed} m/s',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
