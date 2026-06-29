import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../Core/models/lecture.dart';
import '../../../../../Core/services/drive_link.dart';
import '../../../../../Core/translations/locale_keys.g.dart';
import '../../../../../Core/unit/app_routes.dart';

class AudioPlayerScreen extends StatefulWidget {
  final Lecture lecture;
  const AudioPlayerScreen({super.key, required this.lecture});

  @override
  State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  final AudioPlayer _player = AudioPlayer();
  final List<StreamSubscription> _subs = [];

  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  bool _playing = false;
  bool _looping = false;
  bool _error = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    _subs.add(_player.onDurationChanged.listen((d) {
      if (mounted) setState(() => _duration = d);
    }));
    _subs.add(_player.onPositionChanged.listen((p) {
      if (mounted) setState(() => _position = p);
    }));
    _subs.add(_player.onPlayerStateChanged.listen((s) {
      if (mounted) setState(() => _playing = s == PlayerState.playing);
    }));
    try {
      final url = DriveLink.toDirectDownload(widget.lecture.audioUrl ?? '');
      await _player.setSourceUrl(url);
    } catch (_) {
      if (mounted) setState(() => _error = true);
    }
  }

  @override
  void dispose() {
    for (final s in _subs) {
      s.cancel();
    }
    _player.dispose();
    super.dispose();
  }

  Future<void> _toggle() async {
    if (_playing) {
      await _player.pause();
    } else {
      await _player.resume();
    }
  }

  Future<void> _toggleLoop() async {
    _looping = !_looping;
    await _player.setReleaseMode(_looping ? ReleaseMode.loop : ReleaseMode.stop);
    setState(() {});
  }

  String _fmt(Duration d) {
    String two(int n) => n.toString().padLeft(2, '0');
    final m = two(d.inMinutes.remainder(60));
    final s = two(d.inSeconds.remainder(60));
    return d.inHours > 0 ? '${two(d.inHours)}:$m:$s' : '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final lecture = widget.lecture;
    return Scaffold(
      appBar: AppBar(
        title: Text(lecture.title),
        actions: [
          if (lecture.hasPdf)
            IconButton(
              tooltip: LocaleKeys.lectureText.tr(),
              icon: const Icon(Icons.menu_book_rounded),
              onPressed: () =>
                  context.push(AppRouter.kLecturePdf, extra: lecture),
            ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Center(
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(28),
                            color: scheme.primary.withValues(alpha: 0.12),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: (lecture.coverUrl != null &&
                                  lecture.coverUrl!.isNotEmpty)
                              ? Image.network(lecture.coverUrl!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Icon(
                                      Icons.music_note_rounded,
                                      size: 96,
                                      color: scheme.primary))
                              : Icon(Icons.music_note_rounded,
                                  size: 96, color: scheme.primary),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(lecture.title,
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 16),
                  if (_error)
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(LocaleKeys.mediaNotAvailable.tr(),
                          style: TextStyle(color: scheme.error)),
                    ),
                  Slider(
                    value: _position.inMilliseconds
                        .clamp(0, _duration.inMilliseconds)
                        .toDouble(),
                    max: (_duration.inMilliseconds == 0
                            ? 1
                            : _duration.inMilliseconds)
                        .toDouble(),
                    onChanged: (v) =>
                        _player.seek(Duration(milliseconds: v.toInt())),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_fmt(_position)),
                        Text(_fmt(_duration)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        iconSize: 30,
                        color: _looping ? scheme.primary : null,
                        icon: const Icon(Icons.repeat_rounded),
                        onPressed: _toggleLoop,
                      ),
                      const SizedBox(width: 12),
                      FloatingActionButton.large(
                        onPressed: _error ? null : _toggle,
                        child: Icon(
                          _playing
                              ? Icons.pause_rounded
                              : Icons.play_arrow_rounded,
                          size: 42,
                        ),
                      ),
                      const SizedBox(width: 12),
                      IconButton(
                        iconSize: 30,
                        icon: const Icon(Icons.stop_rounded),
                        onPressed: () async {
                          await _player.stop();
                          if (mounted) {
                            setState(() => _position = Duration.zero);
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
