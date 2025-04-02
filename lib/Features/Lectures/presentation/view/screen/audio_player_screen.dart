import 'package:audioplayers/audioplayers.dart';
//import 'package:just_audio/just_audio.dart';
import 'package:deacon_school_admin/Core/helper/loading_app_custom.dart';
import 'package:deacon_school_admin/Core/unit/color_data.dart';
import 'package:deacon_school_admin/Core/unit/style_data.dart';
import 'package:deacon_school_admin/generated/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class AudioPlayerScreen extends StatefulWidget {
  const AudioPlayerScreen({super.key});

  @override
  State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {

  final audioPlayer = AudioPlayer();
  bool isPlaying = false;
  bool loadingAudio = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  bool showPositionTime = true;
  bool showPhoto = true;

  @override
  void initState() {
    super.initState();

    setUpAudio();
  }

  Future setUpAudio () async {
    setState(() {
      loadingAudio = true;
    });

    await audioPlayer.setReleaseMode(ReleaseMode.loop);
    await audioPlayer.setSource(UrlSource('https://dl.espressif.com/dl/audio/ff-16b-2c-44100hz.mp3'));
    duration = (await audioPlayer.getDuration())??Duration.zero;

    audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.playing;
      });
    },);

    audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    },);

    audioPlayer.onPositionChanged.listen((newPosition) {
      setState(() {
        position = newPosition;
      });
    },);

    setState(() {
      loadingAudio = false;
    });
  }

  @override
  Future<void> dispose() async {
    audioPlayer.onPlayerStateChanged.listen((state) {},).cancel();
    audioPlayer.onDurationChanged.listen((newDuration) {},).cancel();
    audioPlayer.onPositionChanged.listen((newPosition) {},).cancel();

    await audioPlayer.pause();
    await audioPlayer.stop();
    setUpAudio().ignore();
    await audioPlayer.dispose();
    super.dispose();
  }

  String formatTime(Duration time) {
    int hours = time.inHours;
    int minutes = time.inMinutes;
    int seconds = time.inSeconds.remainder(60);
    return "${hours > 0 ? '${minutes.toString().padLeft(2, '0')}:' : ''}${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorData.whiteColor,
        appBar: AppBar(
          backgroundColor: ColorData.whiteColor,
          title: Text(
            'بصالتس',
            textDirection: TextDirection.rtl,
            style: StyleData.textStyleBlackTextColorSB22,
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_rounded, color: ColorData.primaryColor),
            onPressed: () {
              context.pop();
            },
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(6),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    showPhoto = !showPhoto;
                  });
                },
                child: Container(
                  height: 44,
                  width: 44,
                  decoration: BoxDecoration(
                      color: ColorData.secondaryBackgroundColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: ColorData.primaryBorderColor,
                          width: 1
                      )
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Icon(
                    Icons.swap_horiz_rounded,
                    size: 22,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              showPhoto ? ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  Assets.imageChurchMelodyIcon,
                  width: double.infinity,
                  height: 350,
                  fit: BoxFit.cover,
                ),
              ) : Expanded(
                child: PDF(
                  enableSwipe: true,
                  swipeHorizontal: false,
                  autoSpacing: false,
                  pageFling: false,
                  onError: (error) {
                    print(error.toString());
                  },
                  onPageError: (page, error) {
                    print('$page: ${error.toString()}');
                  },
                  onPageChanged: (page, total) {
                    print('page change: $page/$total');
                  },
                ).cachedFromUrl(
                  'https://gbihr.org/images/docs/test.pdf',
                  placeholder: (progress) => Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(child: LoadingAppCustom()),
                      Gap(10),
                      Center(child: Text('$progress %', style: StyleData.textStyleBlackTextColorB24,)),
                    ],
                  ),
                  errorWidget: (error) => Center(child: Icon(Icons.broken_image_rounded, size: 65, color: ColorData.dangerColor,)),
                ),
              ),
              const Gap(32),
              Text(
                'بصالتس',
                textDirection: TextDirection.rtl,
                style: StyleData.textStyleBlackTextColorB24,
              ),
              const Gap(4),
              Text(
                'يقال في الفترة كذا من السنة ......',
                textDirection: TextDirection.rtl,
                style: StyleData.textStyleBlackTextColorSB22,
                maxLines: 1,
              ),
              Slider(
                min: 0,
                max: duration.inSeconds.toDouble(),
                value: position.inSeconds.toDouble(),
                onChanged: (value) async {
                  final position = Duration(seconds: value.toInt());
                  await audioPlayer.seek(position);

                  await audioPlayer.resume();
                },
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          showPositionTime = !showPositionTime;
                        });
                      },
                      child: Text(
                        showPositionTime ? formatTime(position) : formatTime(duration-position),
                        style: StyleData.textStyleBlackTextColorSB22,
                      ),
                    ),
                    Text(
                      formatTime(duration),
                      style: StyleData.textStyleBlackTextColorSB22,
                    ),
                  ],
                ),
              ),
              const Gap(8),
              loadingAudio ? LoadingAppCustom(size: 35,) : CircleAvatar(
                radius: 35,
                child: IconButton(
                  icon: Icon(
                      isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                      color: ColorData.primaryLightColor
                  ),
                  iconSize: 50,

                  onPressed: () async {
                    if (isPlaying) {
                      setState(() {
                        isPlaying =false;
                      });
                      await audioPlayer.pause();
                    } else {
                      setState(() {
                        isPlaying =true;
                      });
                      await audioPlayer.resume();
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
