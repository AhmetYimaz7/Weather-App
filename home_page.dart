import 'package:flutter/material.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/services/weather_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<WeatherModel> _weathers = [];
  bool _isLoading = true;

  void _getWeatherData() async {
    try {
      final weathers = await WeatherService().getWeatherData();
      if (weathers != null) {
        setState(() {
          _weathers =
              weathers; //null gelmzese diyor eski boş listeyi dolu listeye değiştir.
          _isLoading =
              false; //false yapacağız çünkü yükleme bitecek veri geldiği için
        });
      }
    } catch (e) {
      print("❌ Hata: $e");
      setState(() => _isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _getWeatherData(); //sayfa ilk açıldığında veri çekmeyi başlatır !!!
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _weathers.isEmpty
          ? const Center(
              child: Text("Veri bulunamadı"),
            ) //veri boşsa bunu yazacağız
          : ListView.builder(
              itemCount: _weathers.length, //listenini uzunluğuı kadar
              itemBuilder: (context, index) {
                final WeatherModel weather = _weathers[index];
                return Container(
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Image.network(weather.ikon, width: 100),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        child: Text(
                          " ${weather.gun}\n ${weather.durum.toUpperCase()} ${weather.derece}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Min: ${weather.min}"
                                "",
                              ),
                              Text(
                                "Max: ${weather.max}"
                                "",
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Min: ${weather.min}"
                                "",
                              ),
                              Text(
                                "Max: ${weather.max}"
                                "",
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
