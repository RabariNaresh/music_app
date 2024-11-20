import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Provider/media_provider.dart';

class PlayScreen extends StatefulWidget {
  const PlayScreen({super.key});

  @override
  State<PlayScreen> createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.sizeOf(context).width;
    double h = MediaQuery.sizeOf(context).height;
    final provider = Provider.of<MediaProvider>(context, listen: true);

    return Scaffold(
      backgroundColor:  Colors.black45,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: w * 0.05, vertical: h * 0.02),
          child: Column(
            children: [
              // App Bar Row
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.arrow_back_ios_new,
                      size: w * 0.07,
                      color: Colors.white,
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Now Playing',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: w * 0.06,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48), // Placeholder for alignment
                ],
              ),
              SizedBox(height: h * 0.03),

              // Song Image
              Container(
                width: w * 0.8,
                height: h * 0.4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      spreadRadius: 5,
                      offset: Offset(0, 5),
                    ),
                  ],
                  image: provider.musicModal!.data.results[provider.selectedSong].image.length > 2
                      ? DecorationImage(
                    image: NetworkImage(
                      provider.musicModal!.data.results[provider.selectedSong].image[2].url,
                    ),
                    fit: BoxFit.cover,
                  )
                      : null,
                ),
              ),
              SizedBox(height: h * 0.03),

              // Song Details
              Column(
                children: [
                  Text(
                    provider.musicModal!.data.results[provider.selectedSong].name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: w * 0.055,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: h * 0.01),
                  Text(
                    provider.musicModal!.data.results[provider.selectedSong].artists.primary != null &&
                        provider.musicModal!.data.results[provider.selectedSong].artists.primary!.isNotEmpty
                        ? provider.musicModal!.data.results[provider.selectedSong].artists.primary![0].name
                        : 'Unknown Artist',
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: w * 0.04,
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              SizedBox(height: h * 0.03),

              // Controls (Volume, Repeat, Shuffle)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    onPressed: () {
                      // Volume control logic
                    },
                    icon: Icon(
                      Icons.volume_up_outlined,
                      color: Colors.white,
                      size: w * 0.07,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      // Repeat song logic
                    },
                    icon: Icon(
                      Icons.repeat,
                      color: Colors.white,
                      size: w * 0.07,
                    ),
                  ),
                  IconButton(
                    onPressed: () => provider.shuffleSongs(),
                    icon: Icon(
                      Icons.shuffle,
                      color: Colors.white,
                      size: w * 0.07,
                    ),
                  ),
                ],
              ),
              SizedBox(height: h * 0.03),

              // Song Progress Slider
              StreamBuilder<Duration>(
                stream: provider.getCurrentPosition(),
                builder: (context, snapshot) {
                  final currentPosition = snapshot.data ?? Duration.zero;
                  final duration = provider.duration ?? Duration.zero;

                  return Column(
                    children: [
                      Slider(
                        value: currentPosition.inSeconds.toDouble(),
                        max: duration.inSeconds.toDouble(),
                        onChanged: (value) {
                          provider.jumpSong(Duration(seconds: value.toInt()));
                        },
                        activeColor: Colors.white,
                        inactiveColor: Colors.grey,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: w * 0.05),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              formatDuration(currentPosition),
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              formatDuration(duration),
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
              SizedBox(height: h * 0.03),

              // Playback Controls
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    onPressed: () => provider.backSong(),
                    icon: Icon(
                      CupertinoIcons.backward_end_fill,
                      color: Colors.white,
                      size: w * 0.1,
                    ),
                  ),
                  CircleAvatar(
                    radius: w * 0.08,
                    backgroundColor: Colors.white,
                    child: IconButton(
                      onPressed: () async => await provider.playSong(),
                      icon: Icon(
                        provider.isPlay ? CupertinoIcons.pause_fill : CupertinoIcons.play_fill,
                        color: Colors.black,
                        size: w * 0.08,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => provider.forwardSong(),
                    icon: Icon(
                      CupertinoIcons.forward_end_fill,
                      color: Colors.white,
                      size: w * 0.1,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper function for formatting durations
  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }
}
