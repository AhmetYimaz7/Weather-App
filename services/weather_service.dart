import 'package:dio/dio.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/models/weather_model.dart';

class WeatherService {
  Future<String?> _getLocation() async {
    //kullanıcı konumu açık mı onu kontrol ettik
    final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {//eğer açmamaışsa error mesajı !!
      Future.error("Konum servisiniz kapalı ");
    }
    
    LocationPermission permission = await Geolocator.checkPermission();//kullanıcı konumu açık mı onu kontrol ettik
    if (permission == LocationPermission.denied) {
      //Konum izni vermemişse tekrar kontrol ettik
      permission = await Geolocator.requestPermission();// burada istek atıyoruz 

      if (permission == LocationPermission.denied) {
        //Yine vermemişse hata döndürüdk

        Future.error("Konum izni vermelisiniz");
      }
    }
    //kullanıcının pozisyonunu aldık
    final Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    //kullanıcı pozisyonundan yerleşim noktası bulduk
    final List<Placemark> placemark = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    //Sehrimizi yerleşim noktasından kaydettik

    final String? city = placemark[0].administrativeArea;

    if (city == null) Future.error("Bir sorun oluştu");

    return city;
  }

  Future<List<WeatherModel>?> getWeatherData() async {
    final String? city = await _getLocation();

    String url =
        "https://api.collectapi.com/weather/getWeather?lang=tr&city=$city";

    const Map<String, dynamic> headers = {
      "authorization": "apikey 1EemvPxERLaIN2n3yyA6mE:26cKBWt1bYZmzIZQ5Q4HEE",
      "content-type": "application/json",
    };

    final dio = Dio();

    final response = await dio.get(url, options: Options(headers: headers));

    if (response.statusCode != 200) {
      return Future.error("Bir sorun oluştu");
    }

    final List list = response.data as List;
    final List<WeatherModel> weatherList = list
        .map((e) => WeatherModel.fromJson(e))
        .toList();

    return weatherList;
  }
}
