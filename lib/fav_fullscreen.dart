import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_room/on_audio_room.dart';
import 'package:rmusic/config.dart';
import 'package:rmusic/fullscreen.dart';
class fav_fullscreen extends StatelessWidget {
  MyConfig m=Get.put(MyConfig());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff5e2563),
        elevation: 0.0,),
      body: Stack(
        alignment: Alignment.topLeft,
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [Color(0xff5e2563), Color(0xff65799b)])),

          ),
          FutureBuilder(future:m.getfavourites() ,builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              List<FavoritesEntity> list = snapshot.data as List<FavoritesEntity>;
              return Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.shuffle),
                    title: Text("Shuffle All (${list.length})"),
                  ),
                  Expanded(child: ReorderableListView.builder(itemCount: list.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: () async {
                          m.isPlay.value=true;
                          for(int i=0;i<m.song_list.value.length;i++)
                          {
                            if(m.song_list.value[i].id==list[index].id)
                            {
                              if(i==m.cur_ind.value){
                                Navigator.push(context, MaterialPageRoute(builder: (context) {
                                  return FullScreen();
                                },));
                              }else
                              {
                                print("yes");
                                m.cur_ind.value=i;
                                await MyConfig.player.play(DeviceFileSource(m.song_list.value[m.cur_ind.value].data));
                              }
                            }
                          }
                           m.get_song_pos();
                        },
                        key: ValueKey(index),
                        leading: Icon(Icons.ac_unit_outlined),
                        title: Text("${list[index].title}"),
                        trailing:Wrap(children: [
                          Obx(() => m.song_list.value[m.cur_ind.value].id==list[index].id && m.isPlay==true ? Image.network("https://i.pinimg.com/originals/cb/17/b8/cb17b80a942d7c317a35ff1324fae12f.gif",width: 40,height: 40,) : Text("")),
                          Icon(Icons.more_vert_outlined)
                        ],)
                      );
                    },
                    onReorder: (oldIndex, newIndex) {
                      if(newIndex>oldIndex)
                      {
                        newIndex=newIndex-1;
                      }
                      FavoritesEntity w=list.removeAt(oldIndex);
                      list.insert(newIndex, w);
                    },
                    buildDefaultDragHandles: true,
                  )
                  )
                ],
              );
            }
            else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },)
        ],
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
                activeTrackColor: Colors.yellow,
                thumbColor: Colors.yellow,
                thumbShape: RoundSliderThumbShape(enabledThumbRadius: 3),
                overlayShape: RoundSliderOverlayShape(overlayRadius: 3),
                trackHeight: 1
            ),
            child: Obx(() => Slider(
              value: m.cur_duration.value,
              min: 0,
              max: m.song_list.value.length>0?m.song_list[m.cur_ind.value].duration!.toDouble():0,
              onChanged: (double value) {},
            )),
          ),
          ListTile(
            onTap: () {
              m.isPlay.value=true;
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return FullScreen();
              },));
            },
            leading: Obx(() => FutureBuilder(future: m.get_image(m.cur_ind.value),builder: (context, snapshot) {
              if(snapshot.hasData){
                return snapshot.data!;
              }else
              {
                return Icon(Icons.music_note_outlined);
              }
            },)),

            title: Obx(() => m.song_list.value.isNotEmpty ? Obx(() => Text("${m.song_list[m.cur_ind.value].title}")) :Text("")),
            subtitle: Obx(() => m.song_list.value.isNotEmpty ? Obx(() => Text("${m.song_list.value[m.cur_ind.value].artist}")) : Text("")),
            trailing: Wrap(children: [
              Obx(() =>    m.isPlay.value ? IconButton(onPressed: () async {
                await MyConfig.player.pause();
                m.isPlay.value=!m.isPlay.value;
              }, icon: Icon(Icons.pause)) : IconButton(onPressed: () async {
                await MyConfig.player.play(DeviceFileSource(m.song_list.value[m.cur_ind.value].data));
                m.isPlay.value=!m.isPlay.value;
              }, icon: Icon(Icons.play_arrow))),
              Icon(Icons.playlist_add_check_rounded)
            ],),

          )
        ],
      ),
    );
  }
}
