
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_room/on_audio_room.dart';
import 'package:rmusic/config.dart';
import 'fav_fullscreen.dart';
class Playlist_class extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MyConfig m=Get.put(MyConfig());
    return Column(
      children: [
        FutureBuilder(future:m.getfavourites() ,builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            List<FavoritesEntity> list = snapshot.data as List<FavoritesEntity>;
            return ListTile(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return fav_fullscreen();
                },));
              },
              leading: Icon(Icons.favorite),
              title: Text("My Favourite",style: TextStyle(color: Colors.white)),
              subtitle: Text("${list.length} songs",style: TextStyle(color: Colors.white)),
            );
          }
          else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },),
      ],
    );
  }
}

