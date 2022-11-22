import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';

import 'config.dart';

class Songs_class extends StatefulWidget {
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
          print(list);
          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () {
                  m.cur_ind.value = index;
                  m.play.value=true;
                  if(m.cur_ind.value==index)
                    {

                    }
                },
                title: Text(list[index].title),
                subtitle: Text("${list[index].artist!}"),
                trailing:Wrap(children: [
                  Icon(Icons.more_vert_outlined),
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