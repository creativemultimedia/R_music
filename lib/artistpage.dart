import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:rmusic/artistpage.dart';
import 'package:rmusic/config.dart';
import 'package:rmusic/fullscreen.dart';

class artistpage extends StatelessWidget {
  ArtistModel artistModel;
  artistpage(this.artistModel);

  @override
  Widget build(BuildContext context) {
    MyConfig m=Get.put(MyConfig());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff5e2563),
        elevation: 0.0,),
      body: Column(
        children: [
          Text("${artistModel.artist}"),
          Text("${artistModel.numberOfAlbums}"),
          Expanded(child: FutureBuilder(builder: (context, snapshot) {
            List<SongModel> list=snapshot.data as List<SongModel>;
            return ListView.builder(
              itemBuilder: (context, index)  {
                SongModel songModel=list[index];
                print(songModel);
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
                  trailing:  Obx(() => m.isPlay==true && m.song_list.value[m.cur_ind.value].id==list[index].id?Image.network("https://i.pinimg.com/originals/cb/17/b8/cb17b80a942d7c317a35ff1324fae12f.gif",height: 50,width: 50,fit: BoxFit.fitHeight):
                  Text("")),
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
                  title: Text("${songModel.title}"),
                  subtitle: Text("${songModel.album}"),
                );
              },itemCount: list.length,);
          },future: m.getallsongbyartist(artistModel.id),))
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
