import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:rmusic/config.dart';
import 'artistpage.dart';
class ArtistClass extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    MyConfig m=Get.put(MyConfig());
    return FutureBuilder(
      builder: (context, snapshot) {
        if(snapshot.connectionState==ConnectionState.done)
        {
          List<ArtistModel> list=snapshot.data as List<ArtistModel>;
          return ListView.separated(itemBuilder: (context, index) {
            ArtistModel artistModel=list[index];
            return ListTile(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return artistpage(artistModel);
                },));
              },
              title: Text("${artistModel.artist}"),
              subtitle: Text("${artistModel.numberOfAlbums} album | ${artistModel.numberOfTracks} song"),
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
      future: m.getartistsongs(),
    );
  }
}
