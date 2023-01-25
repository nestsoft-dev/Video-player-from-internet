import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List info = [];
  bool _playingArea = false;
  late VideoPlayerController _controller;
  _initData() async{
   await DefaultAssetBundle.of(context).loadString("json/info.json").then((value) {
     setState(() {
       info = json.decode(value);
     });
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initData();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Videos course'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          colors: [Colors.blue, Colors.purple],
        )),
        child: Column(children: [
          _playingArea==false ?Container(
            padding: EdgeInsets.only(top: 30,left: 30,right: 30),
            width: MediaQuery.of(context).size.width,
            height: 300,
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                Icon(Icons.play_circle_fill,color: Colors.white,),
                Icon(Icons.info_outline,color: Colors.white,),
              ],),
              SizedBox(height: 30,),
              Text("Please Select the Course Videos \n to continue",style: TextStyle(color: Colors.white,fontSize: 30),),

            ],),
          ) :
          Container
            (
            child: Column(
              children: [
              Container(
                height: 100,
                padding: EdgeInsets.only(top: 50,left: 30,right: 30),
                child: Row(
                  children: [
                    InkWell(onTap: (){},
                    child: Icon(Icons.arrow_back_ios,size: 20,color: Colors.white,),),
                    Expanded(child: Container()),
                    InkWell(onTap: (){},
                      child: Icon(Icons.arrow_back_ios,size: 20,color: Colors.white,),)
                  ],
                ),
              ),
                _playView(context),
            ],),

          ),
          Expanded(child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topRight: Radius.circular(70))
            ),
            child: Column(
              children: [
                Expanded
                  (
                    child: ListView.builder(
                      itemCount:info.length,
                    itemBuilder: (_, index){
                  return GestureDetector(
                    onTap: (){
                     setState(() {
                       _onTapVideo(index);
                       print(info[index]["url"]);
                      if(_playingArea==false){
                        _playingArea = true;
                      }
                     });
                    },
                    child: Container(
                      height: 135,
                      // color: Colors.redAccent,
                      // width: 200,
                      child: Column(
                        children: [
                          Row(children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(image: AssetImage(info[index]["Image"]))
                              ),
                            ),
                            SizedBox(width: 10,),

                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(info[index]["title"],style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                                SizedBox(height: 10,),
                                Padding(padding: EdgeInsets.only(top: 3),
                                child: Text(info[index]["time"],style: TextStyle(color: Colors.grey[500])),),
                              ],
                            )
                          ],)
                        ],
                      ),
                    ),
                  );
                }))
            ],),
          ),
          )
        ],),
      ),
    );
  }

 Widget _playView(BuildContext context){
final controller = _controller;
if (controller!=null&&controller.value.isInitialized) {
  return AspectRatio(
    aspectRatio: 16/9,
    // height:300,
    // width: 300,
    child: VideoPlayer(controller),);
}  else{
return  Text("No controller");
}
  }

  _onTapVideo(int index){
   final controller = VideoPlayerController.network(info[index]["url"]);
   _controller = controller;
   setState(() {

   });
   controller..initialize().then((_) {
     controller.play();
     setState(() {

     });
   });
  }
}
