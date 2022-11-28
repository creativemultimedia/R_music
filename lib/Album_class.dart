
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:rmusic/albumpage.dart';
import 'package:rmusic/config.dart';
import 'artistpage.dart';
class albumclass extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MyConfig m=Get.put(MyConfig());
    return FutureBuilder(
      builder: (context, snapshot) {
        if(snapshot.connectionState==ConnectionState.done)
        {
          List<AlbumModel> list=snapshot.data as List<AlbumModel>;
          return ListView.separated(itemBuilder: (context, index) {
            AlbumModel albumModel=list[index];
            return ListTile(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return albumpage(albumModel);
                },));
              },
              title: Text("${albumModel.album}"),
              subtitle: Text("${albumModel.artist} | ${albumModel.numOfSongs}"),
            );
          }, separatorBuilder: (context, index) {
            return Divider();
          }, itemCount: list.length);
        }
        else
        {
          return Center(child: CircularProgressIndicator(),);
        }
      },
      future: m.getalbum(),
    );
  }
}
