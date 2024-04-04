import 'package:just_audio/just_audio.dart';
import 'package:audio_service/audio_service.dart';

class MyAudioHandler extends BaseAudioHandler
    with QueueHandler, // mix in default queue callback implementations
    SeekHandler { // mix in default seek callback implementations
  
  static final _item = MediaItem(
    id: 'https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3',
    album: "Science Friday",
    title: "A Salute To Head-Scratching Science",
    artist: "Science Friday and WNYC Studios",
    duration: const Duration(milliseconds: 5739820),
    artUri: Uri.parse(
        'https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg'),
  );

  final _player = AudioPlayer();

  /// Initialise our audio handler.
  MyAudioHandler() {
    // So that our clients (the Flutter UI and the system notification) know
    // what state to display, here we set up our audio handler to broadcast all
    // playback state changes as they happen via playbackState...
    _player.playbackEventStream.map(_transformEvent).pipe(playbackState);
    // ... and also the current media item via mediaItem.
    mediaItem.add(_item);

    // Load the player.
    _player.setAudioSource(AudioSource.uri(Uri.parse(_item.id)));
  }

  // In this simple example, we handle only 4 actions: play, pause, seek and
  // stop. Any button press from the Flutter UI, notification, lock screen or
  // headset will be routed through to these 4 methods so that you can handle
  // your audio playback logic in one place.

  int _currentQueueIndex = 0; // Track the current index in the queue


  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> stop() => _player.stop();

  @override
  Future<void> playFromUrl(String url) async {
    try {
      await _player.setUrl(url);
      await _player.play();
    } catch (e) {
      print('Error playing audio from URL: $e');
    }
  }

  Future<void> playNewMedia(
  String url,
  String title,
  String artist,
  String album,
  String imageUrl,
  int duration
) async {
  try {
    // Set the new media item
    MediaItem item = MediaItem(
      id: url,
      album: album,
      title: title,
      artist: artist,
      duration: Duration(milliseconds: duration), // Adjust the duration as needed
      artUri: Uri.parse(imageUrl),
    );

    // Update the media item
    mediaItem.add(item);

    // Play the new media
    await playFromUrl(url);
  } catch (e) {
    print('Error playing new media: $e');
  }
}

@override
  Future<void> deleteall() async {
    try {
      for (int i = 0; i < queue.value.length; i++) {
        
        await removeQueueItemAt(i);
      }
      
    } catch (e) {
      print('Error clearing queue: $e');
    }
  }

  Future<void> skipToQueueItem(int i) => _player.seek(Duration.zero, index: i);


@override
Future<void> skipToNext() async {
  try {
    _currentQueueIndex = (_currentQueueIndex + 1) % queue.value.length;
     mediaItem.add(queue.value[_currentQueueIndex]);
    await skipToQueueItem(_currentQueueIndex);
    await _player.setAudioSource(AudioSource.uri(Uri.parse(queue.value[_currentQueueIndex].id)));
    await _player.play();
    //await skipToQueueItem(_currentQueueIndex);
    //await _player.seekToNext();
  } catch (e) {
    print('Error skipping to next item: $e');
  }
}

@override
Future<void> skipToPrevious() async {
  try {
    _currentQueueIndex = _currentQueueIndex > 0 ? _currentQueueIndex - 1 : queue.value.length - 1;
    mediaItem.add(queue.value[_currentQueueIndex]);
    await skipToQueueItem(_currentQueueIndex);
    await _player.setAudioSource(AudioSource.uri(Uri.parse(queue.value[_currentQueueIndex].id)));
    await _player.play();
   
  } catch (e) {
    print('Error skipping to previous item: $e');
  }
}



 Future<void> customskipToNext(currentIndex) async{
    try {
      if (currentIndex + 1 < queue.value.length) {
      
        
        mediaItem.add(queue.value[currentIndex+1]);
        await _player.setAudioSource(AudioSource.uri(Uri.parse(queue.value[currentIndex+1].id)));
        await _player.play();
        await skipToQueueItem(currentIndex+1);

        //await skipToNext();
      } else {
        // If we're at the end of the queue, stop the player
        await stop();
      }
    } catch (e) {
      print('Error skipping to next item: $e');
    }
 }
 

  Future<void> customskipToPrevious(currentIndex) async{
    try {
      if (currentIndex + 1 < queue.value.length) {
        
        
        mediaItem.add(queue.value[currentIndex]);
        await _player.setAudioSource(AudioSource.uri(Uri.parse(queue.value[currentIndex].id)));
        await _player.play();
        await skipToQueueItem(currentIndex);
        //await skipToPrevious();
      } else {
        // If we're at the end of the queue, stop the player
        await stop();
      }
    } catch (e) {
      print('Error skipping to next item: $e');
    }
 }

  Future<void> mediaplay(MediaItem item) async {
    try {
       playFromUrl('https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3');
    // So that our clients (the Flutter UI and the system notification) know
    // what state to display, here we set up our audio handler to broadcast all
    // playback state changes as they happen via playbackState...
    _player.playbackEventStream.map(_transformEvent).pipe(playbackState);
    // ... and also the current media item via mediaItem.
    mediaItem.add(_item);

    // Load the player.
    _player.setAudioSource(AudioSource.uri(Uri.parse(_item.id)));
    } catch (e) {
      print('Error playing audio from URL: $e');
    }
  }

  /// Transform a just_audio event into an audio_service state.
  ///
  /// This method is used from the constructor. Every event received from the
  /// just_audio player will be transformed into an audio_service state so that
  /// it can be broadcast to audio_service clients.
  PlaybackState _transformEvent(PlaybackEvent event) {
    return PlaybackState(
      controls: [
        
        if (_player.playing) MediaControl.pause else MediaControl.play,
        MediaControl.stop,
       
        MediaControl.skipToNext,
        MediaControl.skipToPrevious,
      ],
      systemActions: const {
        MediaAction.seek,
        MediaAction.seekForward,
        MediaAction.seekBackward,
      },
      androidCompactActionIndices: const [0, 1, 3],
      processingState: const {
        ProcessingState.idle: AudioProcessingState.idle,
        ProcessingState.loading: AudioProcessingState.loading,
        ProcessingState.buffering: AudioProcessingState.buffering,
        ProcessingState.ready: AudioProcessingState.ready,
        ProcessingState.completed: AudioProcessingState.completed,
      }[_player.processingState]!,
      playing: _player.playing,
      updatePosition: _player.position,
      bufferedPosition: _player.bufferedPosition,
      speed: _player.speed,
      queueIndex: event.currentIndex,
    );
  }
}