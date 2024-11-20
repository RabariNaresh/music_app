import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../Api Helper/api_helper.dart';
import '../Modal/media_modal.dart';




class MediaProvider extends ChangeNotifier {
  MusicModal? musicModal;
  Result? result;
  AudioPlayer player =AudioPlayer();
  Duration? duration;
  bool isPlay = false;
  int selectedSong = 1;
  bool isShuffled = false;
  String? search;
  List<MusicModal> favouriteList = [];
  TextEditingController txtSearch = TextEditingController();

  Future<void> getSong() async {
    ApiHelper apiHelper = ApiHelper();
    Map<String, dynamic> json = await apiHelper.fetchApi();
    musicModal = MusicModal.fromJson(json);
    notifyListeners();
  }

  void searchSong(String search)
  {
    search = search;
    notifyListeners();
  }

  void selectSong(int selectedSong)
  {
    this.selectedSong = selectedSong;
    notifyListeners();
  }

  Future<void> setSong(String url)
  async {
    duration = await player.setUrl(url);
    notifyListeners();
  }

  Future<void> playSong()
  async {
    isPlay = !isPlay;
    if (isPlay) {
      player.play();
    } else {
      player.pause();
    }
    notifyListeners();
  }

  Stream<Duration> getCurrentPosition()
  {
    return player.positionStream;
  }

  Future<void> jumpSong(Duration position)
  async {
    await player.seek(position);
    notifyListeners();
  }

  void forwardSong() {
    selectedSong = selectedSong + 1;
    player.setUrl(musicModal!.data.results[selectedSong].downloadUrl[1].url);
    notifyListeners();
  }

  void backSong() {
    selectedSong = selectedSong - 1;
    player.setUrl(musicModal!.data.results[selectedSong].downloadUrl[1].url);
    notifyListeners();
  }

  Future<void> shuffleSongs() async {
    await player.shuffle();
    isShuffled = true;
    notifyListeners();
  }

  void repeatSong() {
    if (player.loopMode == LoopMode.one) {
      player.setLoopMode(LoopMode.off);
    } else {
      player.setLoopMode(LoopMode.one);
    }
    notifyListeners();
  }

  MediaProvider() {
    getSong();
  }
}