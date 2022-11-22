import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
class MyConfig extends GetxController {
  static OnAudioQuery _audioQuery = OnAudioQuery();
  RxInt cur_ind = 0.obs;
  RxBool play = false.obs;
  RxList<SongModel> song_list = RxList();
  current_song(int val) {
    print(val);
    cur_ind.value = val;
  }
  get_songs() async {
    song_list.value = await _audioQuery.querySongs();
    return song_list.value;
  }
}