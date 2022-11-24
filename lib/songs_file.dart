import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rmusic/fullscreen.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'config.dart';

class Songs_class extends StatefulWidget {
  const Songs_class({Key? key}) : super(key: key);
  @override
  State<Songs_class> createState() => _Songs_classState();
}

class _Songs_classState extends State<Songs_class> {
  @override
  Widget build(BuildContext context) {
    MyConfig m=Get.put(MyConfig());
    return FutureBuilder(
      future: m.get_songs(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          List<SongModel> list = snapshot.data as List<SongModel>;
          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index)  {
              return ListTile(
                onTap: () async {
                  m.get_song_pos();
                  m.isPlay.value=true;
               if(index==m.cur_ind.value){
                 Navigator.push(context, MaterialPageRoute(builder: (context) {
                   return FullScreen();
                 },));
               }else {
                 m.cur_ind.value=index;
                 await MyConfig.player.play(DeviceFileSource(m.song_list.value[m.cur_ind.value].data));
               }
                },
                leading:FutureBuilder(future: m.get_image(index),builder: (context, snapshot) {
                 if(snapshot.hasData)
                  {
                    return snapshot.data!;
                  }
                else
                  {
                    return Icon(Icons.music_note);
                  }
                },),
                title: Text(list[index].title),
                subtitle: Text("${list[index].artist!}"),
                trailing:Wrap(children: [
                  Obx(() => m.cur_ind.value==index && m.isPlay==true ? Image.network("https://i.pinimg.com/originals/cb/17/b8/cb17b80a942d7c317a35ff1324fae12f.gif",width: 40,height: 40,) : Text("")),
                  Icon(Icons.more_vert_outlined)
                ],),
              );
            },
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}