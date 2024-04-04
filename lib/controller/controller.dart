import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:wetherapp/services/api_services.dart';

class  MainController extends GetxController{

  var curWeatherData;
  var hrWeatherData;

  @override
  void onInit() async
  {
    await getUserLocation();
    curWeatherData=getCurWeather(latitude.value,longitutde.value);
    hrWeatherData=getHrWeather(latitude.value,longitutde.value);
    super.onInit();
  }

  var isDark=false.obs;
  var latitude=0.0.obs;
  var longitutde=0.0.obs;
  var islodedd=false.obs;

  changeTheme(){

    isDark.value=!isDark.value;
    Get.changeThemeMode(isDark.value ? ThemeMode.dark : ThemeMode.light);

  }
  getUserLocation() async
  {
    bool isLocationEnabled;
    LocationPermission userPermision;
    isLocationEnabled =await Geolocator.isLocationServiceEnabled();

    if(!isLocationEnabled)
      {
        return Future.error("Location is not enabled");
      }

    userPermision =await Geolocator.checkPermission();
    if(userPermision==LocationPermission.deniedForever)
      {
        return Future.error("Permission denied forever");
      }
    else if(userPermision==LocationPermission.denied)
      {
        userPermision=await Geolocator.requestPermission();
        if(userPermision==LocationPermission.denied) {
          return Future.error("Permission is denied");
        }
      }
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high).then((value) {
      latitude.value=value.latitude;
      longitutde.value=value.longitude;
      islodedd.value=true;
    });

  }


}