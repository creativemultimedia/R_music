import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:rmusic/first.dart';
import 'package:permission_handler/permission_handler.dart';
// Git Key
////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
void main() {
  runApp(GetMaterialApp(
    home: Home(),
  ));
}
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  AnimationController? controller;
  Animation<Offset>? offset;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get_permisssion();
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    offset = Tween<Offset>(begin: Offset.zero, end: Offset(0.0, -2.0))
        .animate(controller!);
    controller!.forward();
    Future.delayed(Duration(seconds: 2)).then((value) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return First();
      },));
    });
  }
  get_permisssion()
  async {
    var status = await Permission.camera.status;
    if(status.isDenied){
      Map<Permission, PermissionStatus> statuses = await [
        Permission.location,
        Permission.storage,
      ].request();
    }
  }
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fill, image: AssetImage("assets/backgound.png"))),
        child: Align(
            alignment: Alignment.bottomCenter,
            child: SlideTransition(
                position: offset!,
                child: SizedBox(
                  height: 50,
                  width: 50,
                  child: Image.asset("assets/logo.png"),
                ))),
      ),
    );
  }
}
