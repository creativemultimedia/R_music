import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rmusic/config.dart';

class FullScreen extends StatelessWidget {
  const FullScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MyConfig m=Get.put(MyConfig());
    m.get_song_pos();
    return Scaffold(appBar: AppBar(title: Text("Song | Lyrics")),
    body: Column(children: [
      Expanded(child: FutureBuilder(future: m.get_image(m.cur_ind.value),builder: (context, snapshot) {
        if(snapshot.hasData){
          return snapshot.data!;
        }else
          {
           return  Image.network("https://cdmi.in/companies/DS.png");
          }
      },)),
      Expanded(child: Column(children: [
        Text(m.song_list.value[m.cur_ind.value].title),
        Text(m.song_list.value[m.cur_ind.value].artist!),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(Icons.favorite_border),
            Icon(Icons.favorite_border),
            Icon(Icons.favorite_border),
            Icon(Icons.favorite_border),
          ],
        ),
       Row(children: [
         Obx(() => Text(m.printDuration(Duration(milliseconds: m.cur_duration.value.toInt()))),),
         Expanded(child:  Obx(() => Slider(value: m.cur_duration.value,min: 0,max: m.song_list.value[m.cur_ind.value].duration!.toDouble(), onChanged: (value) async {
           await MyConfig.player.seek(Duration(milliseconds: value.toInt()));
         },))),
         Text(m.printDuration(Duration(milliseconds: m.song_list.value[m.cur_ind.value].duration!.toInt())))
       ],),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(onPressed: () {

            }, icon: Icon(Icons.skip_previous_outlined)),
            Obx(() =>    m.isPlay.value ? IconButton(onPressed: () async {
              await MyConfig.player.pause();
              m.isPlay.value=!m.isPlay.value;
            }, icon: Icon(Icons.pause)) : IconButton(onPressed: () async {
              await MyConfig.player.play(DeviceFileSource(m.song_list.value[m.cur_ind.value].data));
              m.isPlay.value=!m.isPlay.value;
            }, icon: Icon(Icons.play_arrow))),
            IconButton(onPressed: () {

            }, icon: Icon(Icons.skip_next))
          ],
        )

      ],))

    ]),


    );
  }
  @override
  void dispose() {
    // TODO: implement dispose

    MyConfig.player.stop();
  }
}
