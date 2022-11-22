import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:rmusic/config.dart';
import 'package:rmusic/playlist_file.dart';
import 'package:rmusic/songs_file.dart';
import 'package:on_audio_query/on_audio_query.dart';

import 'folder_file.dart';

class First extends StatefulWidget {
  const First({Key? key}) : super(key: key);

  @override
  State<First> createState() => _FirstState();
}

class _FirstState extends State<First> with TickerProviderStateMixin {
  TabController? tabController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    MyConfig m=Get.put(MyConfig());
    return Scaffold(
      drawer: Drawer(),
      appBar: AppBar(
        backgroundColor: Color(0xff5e2563),
        // elevation: 0.0,
        title: Text("Music Player"),
        actions: [
          Padding(
              padding: EdgeInsets.only(right: 20),
              child: Icon(
                Icons.search_rounded,
              ))
        ],
        titleSpacing: 10,
        bottom: TabBar(
            indicatorColor: Colors.orange,
            labelColor: Colors.orange,
            unselectedLabelColor: Colors.white,
            isScrollable: true,
            controller: tabController,
            tabs: [
              Tab(
                child: Text("SONGS"),
              ),
              Tab(
                child: Text("PLAYLIST"),
              ),
              Tab(
                child: Text("FOLDERS"),
              ),
              // Tab(child: Text("ALBUMS"),),
              //  Tab(child: Text("ARTISTS"),),
              //  Tab(child: Text("GENRES"),),
            ]),
      ),
      // extendBodyBehindAppBar: true,
      body: Stack(
        alignment: Alignment.topLeft,
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xff5e2563), Color(0xff65799b)])),

          ),
          TabBarView(
              controller: tabController,
              children: [Songs_class(), Playlist_class(), Folders_class()])
        ],
      ),
      bottomNavigationBar: ListTile(
          leading: Icon(
        Icons.music_video
      ),
      title: Obx(() => m.song_list.length>0
          ? Obx(() => Text("${m.song_list.value[m.cur_ind.value].title}"))
          :Text("Hello")),
        subtitle: Obx(() => Text("${m.song_list.value[m.cur_ind.value].artist}")),
        trailing: Wrap(children: [
          Obx(() => m.play.value?Icon(Icons.pause):Icon(Icons.play_arrow)),
          Icon(Icons.playlist_add_check_rounded)
        ],),
      ),
    );
  }
}
