import 'dart:io';
import 'dart:typed_data';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_room/on_audio_room.dart';
import 'package:palette_generator/palette_generator.dart';
class MyConfig extends GetxController
{
  PaletteGenerator? paletteGenerator;
  static Color color=Colors.white;
  static OnAudioQuery _audioQuery = OnAudioQuery();
  static AudioPlayer player=AudioPlayer();
  RxInt cur_ind=0.obs;
  RxBool fav=false.obs;
  RxList<SongModel> song_list = RxList();
  RxList<Widget> img_list = RxList();
  RxList<FavoritesEntity> fav_list = RxList();
  RxBool isPlay=false.obs;
  RxDouble cur_duration=0.0.obs;
   get_songs() async {
    song_list.value = await _audioQuery.querySongs();
    return song_list;
  }
  Future<Widget> get_image(int pos) async {
   final metadata = await MetadataRetriever.fromFile(File(song_list[pos].data));
   Uint8List? albumArt = metadata.albumArt;
   paletteGenerator = await PaletteGenerator.fromImageProvider(
     albumArt!=null ? Image.memory(albumArt).image : Image.asset("assets/logo.png").image
   );
   color=paletteGenerator!.lightVibrantColor!.color;
   return albumArt!=null ? Image.memory(albumArt) : Icon(Icons.music_note_outlined) ;
  }
  getfavourites() async {
    fav_list.value = await OnAudioRoom().queryFavorites(
        limit: 100, //Default: 50
        reverse: true, //Default: false
        sortType: RoomSortType.TITLE //Default: null
    );
    return fav_list;
  }
  get_song_pos()
  {
    player.onPositionChanged.listen((Duration  p) {
    cur_duration.value=p.inMilliseconds.toDouble();});
  }
  check_fav() async {
    fav.value= await OnAudioRoom().checkIn(
        RoomType.FAVORITES,
        song_list.value[cur_ind.value].id
    );
  }
  String printDuration(Duration duration) {
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    if (duration.inHours > 0)
      return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
    else
      return "$twoDigitMinutes:$twoDigitSeconds";
  }



}