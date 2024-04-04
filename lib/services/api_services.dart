import 'package:http/http.dart' as http;
import 'package:wetherapp/models/curWeather.dart';
import 'package:wetherapp/models/hrWeather.dart';

import '../strings.dart';



getCurWeather(lat,long) async{
  var link="https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$long&appid=$apikey&units=metric";
  var res=await http.get(Uri.parse(link));
  if(res.statusCode==200)
    {
      var data=curWeatherFromJson(res.body.toString());
      return data;
    }
}

getHrWeather(lat,long) async{
  var hrlink="https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$long&appid=$apikey&units=metric";
  var res=await http.get(Uri.parse(hrlink));
  if(res.statusCode==200)
  {
    var data=hrWeatherFromJson(res.body.toString());
    return data;
  }
}