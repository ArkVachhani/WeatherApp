import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:intl/intl.dart';
import 'package:wetherapp/colors.dart';
import 'package:wetherapp/controller/controller.dart';
import 'package:wetherapp/images.dart';
import 'package:wetherapp/models/curWeather.dart';
import 'package:wetherapp/models/hrWeather.dart';
import 'package:wetherapp/services/api_services.dart';
import 'package:wetherapp/strings.dart';
import 'package:wetherapp/our_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: CustomTheme.lightTheme,
      darkTheme: CustomTheme.darkTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Weather App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    var date=DateFormat("yMMMMd").format(DateTime.now());
    var theme=Theme.of(context);
    var controller=Get.put(MainController());
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: "$date".text.color(theme.primaryColor).make(),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: [
          Obx((){return IconButton(onPressed: (){controller.changeTheme();}, icon: Icon(controller.isDark.value ? Icons.light_mode: Icons.dark_mode,color: theme.iconTheme.color,));}),
          IconButton(onPressed: (){}, icon: Icon(Icons.more_vert,color: theme.iconTheme.color,)),
        ],
      ),
      body: Obx(()=>
      controller.islodedd ==true ?
         Padding(
          padding: const EdgeInsets.all(12.0),
          child: FutureBuilder(
            future: controller.curWeatherData,
            builder: (BuildContext context,AsyncSnapshot snapshot) {
              if(snapshot.hasData)
                {
                  CurWeather data=snapshot.data;
                  return SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        "${data.name}".text.uppercase.fontFamily("poppins-bold").size(32).color(theme.primaryColor).letterSpacing(3).make(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.network("https://openweathermap.org/img/wn/${data.weather[0].icon.toString()}@2x.png",width: 90,height: 90,),
                            RichText(text: TextSpan(
                                children: [
                                  TextSpan(
                                      text: "${data.main!.temp}$degree",
                                      style: TextStyle(
                                          color: theme.primaryColor,
                                          fontSize: 64,
                                          fontFamily: "poppins-light"
                                      )),
                                  TextSpan(
                                      text: "${data.weather[0]!.main}",
                                      style: TextStyle(
                                          color: theme.primaryColor,
                                          fontSize: 14,
                                          letterSpacing: 2,
                                          fontFamily: "poppins"
                                      )
                                  ),
                                ]
                            ))
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton.icon(onPressed: null,
                                icon: Icon(Icons.expand_less_rounded,color: theme.iconTheme.color,),
                                label: "${data.main.tempMax}$degree".text.color(theme.iconTheme.color).size(18).make()),
                            TextButton.icon(onPressed: null,
                                icon: Icon(Icons.expand_more_rounded,color: theme.iconTheme.color,),
                                label: "${data.main.tempMin}$degree".text.color(theme.iconTheme.color).size(18).make())
                          ],
                        ),
                        10.heightBox,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children:
                          List.generate(3, (index){
                            var iconsList=[clouds,humidity,wind];
                            var values=["${data.clouds.all}%","${data.main.humidity}%","${data.wind.speed}Km/h"];
                            return Column(
                              children: [
                                Image.asset(iconsList[index],
                                  width: 60,
                                  height: 60,
                                ).box.gray200.padding(EdgeInsets.all(8.0)).roundedSM.make(),
                                10.heightBox,
                                values[index].text.gray400.make(),
                              ],
                            );
                          }),
                        ),
                        10.heightBox,
                        Divider(),
                        10.heightBox,
                        FutureBuilder(
                          future: controller.hrWeatherData,
                          builder: (BuildContext context,AsyncSnapshot snapshot) {
                          if(snapshot.hasData)
                            {
                              HrWeather hdata=snapshot.data;
                              return SizedBox(
                                height: 135,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  physics: const BouncingScrollPhysics(),
                                  itemCount:5,
                                  itemBuilder: (context, index) {

                                    var time=DateFormat.jm().format(DateTime.fromMillisecondsSinceEpoch(hdata.list[index].dt*1000));
                                    return Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: Vx.gray200,
                                      ),
                                      padding: EdgeInsets.all(10.0),
                                      margin: EdgeInsets.only(left: 10),
                                      child: Column(
                                        children: [
                                          "$time".text.make(),
                                          Image.network("https://openweathermap.org/img/wn/${hdata.list[index].weather[0].icon.toString()}@2x.png",width: 65,),
                                          "${hdata.list[index].main.temp.toInt()}  $degree".text.make(),
                                        ],
                                      ),
                                    );
                                  },),
                              );
                            }
                          else
                            {
                              return Center(child: CircularProgressIndicator(),);
                            }
                        },),
                        10.heightBox,
                        Divider(),
                        10.heightBox,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            "Next 7 Days".text.color(theme.primaryColor).semiBold.make(),
                            TextButton(onPressed: (){}, child: "View All".text.color(theme.primaryColor).make())
                          ],
                        ),
                        ListView.builder(
                          itemCount:7,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            var day=DateFormat("EEEE").format(DateTime.now().add(Duration(days: index+1)));
                            return Card(
                              color: theme.cardColor,
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 8,vertical: 12),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(child: day.text.semiBold.color(theme.primaryColor).make()),
                                    Expanded(
                                      child: TextButton.icon(onPressed: null,
                                          icon: Image.asset("assets/images/partly-cloudy-day.png",width: 40,),
                                          label: "32$degree".text.color(theme.primaryColor).size(13).make()),
                                    ),
                                    RichText(text: TextSpan(children: [
                                      TextSpan(text: "40$degree /",
                                          style: TextStyle(
                                              color: theme.primaryColor,
                                              fontFamily: "poppins",
                                              fontSize: 16
                                          )
                                      ),
                                      TextSpan(text: " 26$degree",
                                          style: TextStyle(
                                              color: theme.iconTheme.color,
                                              fontFamily: "poppins",
                                              fontSize: 16
                                          )
                                      )
                                    ]))
                                  ],
                                ),
                              ),
                            );
                          },),
                      ],
                    ),
                  );
                }
              else
                {
                  return Center(child: CircularProgressIndicator(),);
                }

          },)
        ):
          Center(child: CircularProgressIndicator(),)
      )
    );
  }
}
