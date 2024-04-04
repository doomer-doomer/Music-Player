import 'dart:math';
import 'dart:ui';
import 'dart:io';
import 'package:audio_session/audio_session.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image/image.dart';
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testz/pages/AudioPlayerHandler.dart';
import 'package:testz/pages/home.dart';
import 'package:testz/pages/lyrics.dart';
import 'package:testz/pages/model/lyric.dart';
import 'package:testz/pages/route/customPush.dart';
import 'package:testz/pages/songData.dart';
import 'package:wakelock/wakelock.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'dart:async';
import 'package:video_player/video_player.dart';
import 'package:spotify/spotify.dart' as music;
import 'package:animate_gradient/animate_gradient.dart';
import 'package:video_player/video_player.dart';
import 'package:audio_service/audio_service.dart';
import 'package:http/http.dart' as http;


class PlaySong extends StatefulWidget {
  SongData songData;
  List<SongData> songList;
  int currentIndex;
  final AudioHandler audioHandler;

   PlaySong({super.key, required this.songData, required this.songList, 
   required this.currentIndex,
   required this.audioHandler
   });

  @override
  State<PlaySong> createState() => _PlaySongState();
}


class _PlaySongState extends State<PlaySong> with TickerProviderStateMixin, WidgetsBindingObserver{
  final AudioPlayer _audioPlayer = AudioPlayer();
   
  bool _isPlaying = true;
  bool _isLiked = false;
  double _sliderValue = 0.0;
  var dominantColor;
  //late StreamSubscription<Duration> _positionSubscription;
  late Duration duration;
  late var cred = music.SpotifyApiCredentials('d96f4905b91247d8b38c24e3a77155bd', 'd86c9dead5084cada0ed5cd37073c14c');
   late var spotify = music.SpotifyApi(cred);
   late AnimationController _controller;
   Timer? _timer;
  var lyrics = <lyric>[];
   String id = '';
  String _searchResults = '';
  String _searchResults2 = '';
  String _searchResults3 = '';
  String market = '';
  String artistID = '';
  List<String> genre = [];
  String audio = '';
  int durationsong = 0;
  VideoPlayerController _controller2 = VideoPlayerController.networkUrl(Uri.parse('https://www.youtube.com/watch?v=6JnGBs88sL0'));
  bool _controlsVisible = true;
  final MyAudioHandler instance = MyAudioHandler();
  final StreamController<String> _imageUrlController = StreamController<String>();
  late int currentSong;
  bool isNext = false;
bool _isDominantColorFetched = false;
bool isLyric = false;


// Method to add image URLs to the stream
void addImageUrl(String imageUrl) {
  _imageUrlController.add(imageUrl);
}

// Close the stream when no longer needed
void disposeImageUrlStream() {
  _imageUrlController.close();
}

// Access the stream
Stream<String> get imageUrlStream => _imageUrlController.stream;

void _startTimer() {
  const duration = Duration(seconds: 1);
  _timer = Timer.periodic(duration, (timer) {
    // Cancel the timer if the controller or its duration is not initialized
    if (!_controller2.value.isInitialized || _controller2.value.duration == null) {
      return;
    }
    
    // Check if the slider value has reached the end of the track
    if (_sliderValue >= (_controller2.value.duration!.inMilliseconds.toDouble() - 1000)) {
      // Call your function here
      if (mounted) {
        if (widget.currentIndex != widget.songList.length - 1) {
          Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context)=> PlaySong(
            songData: SongData(
              id: id, 
              imageUrl: _searchResults2, 
              title: _searchResults, 
              singer:  _searchResults3, 
              artistID: artistID, 
              genre: genre,
              duration: durationsong,
              audioUrl: ''
            ),
            songList: widget.songList,
            currentIndex: widget.currentIndex + 1,
            audioHandler: widget.audioHandler,
          ))).then((_){
            _audioPlayer.dispose();
            _controller2.dispose();
            
            _timer?.cancel();
            return;
          });
        } else {
          setState(() {
            widget.songList.add(SongData(
              id: id, 
              imageUrl: _searchResults2,
              title: _searchResults, 
              singer: _searchResults3,
              artistID: artistID, 
              genre: genre,
              duration: durationsong,
              audioUrl: ''
              ));
          });
          Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context)=> PlaySong(
            songData: SongData(
              id: id, 
              imageUrl: _searchResults2, 
              title: _searchResults, 
              singer:  _searchResults3, 
              artistID: artistID, 
              genre: genre,
              duration: durationsong,
              audioUrl: ''
            ),
            songList: widget.songList,
            currentIndex: widget.currentIndex + 1,
            audioHandler: widget.audioHandler,
          ))).then((_){
            _audioPlayer.dispose();
            _controller2.dispose();
            _timer?.cancel();
            return;
          });
        }
      }
    }
  });
}

   @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    
    switch (state) {
      case AppLifecycleState.resumed:
        //_audioPlayer.play();
        _startTimer();
        //_controller2.play();
       
        break;
      case AppLifecycleState.paused:
       
        _timer?.cancel();
        //_controller2.pause();
        break;
      case AppLifecycleState.inactive:
      
        break;
      case AppLifecycleState.detached:
       
        break;
      default:
        break;
    }
  }


  

  @override
  void initState() {
    super.initState();
    Wakelock.enable();
    currentSong = widget.currentIndex;
    
    WidgetsBinding.instance?.addObserver(this);
    if(widget.songList.length == 0){
      setState(() {
        widget.songList.add(widget.songData);
        widget.currentIndex = 0;
      });
  
    }
    widget.audioHandler.updateQueue([]);
    if(widget.songList.length > 1){
      setState(() {
        widget.songList.removeAt(0);
      });
    }
    // if(widget.songList.length == 0){
    //   _fetchDominantColor(widget.songList[0].imageUrl);
    // }else{
    //   _fetchDominantColor(widget.songList[widget.currentIndex].imageUrl);
    // }
    
    _initPlayer();
    // fetchLyrics();
    _startTimer();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    //instance.stop();
    //_positionSubscription.cancel();
    (widget.audioHandler as MyAudioHandler).deleteall();
    _timer?.cancel();
    _controller2.dispose();
    //widget.audioHandler.updateQueue([]);
    //widget.audioHandler.stop();
    Wakelock.disable();
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  
  Future<void> _fetchDominantColor(String item) async {
  try {
    final paletteGenerator = await PaletteGenerator.fromImageProvider(
      NetworkImage(item),
    );

    // Get the dominant color from the PaletteGenerator
    var newDominantColor = paletteGenerator.dominantColor?.color;

    // Check if the dominant color actually changes before updating the state
    if (newDominantColor != dominantColor) {
      setState(() {
        dominantColor = newDominantColor ?? Colors.white;
      });
    }
  } catch (e) {
    print('Error fetching dominant color: $e');
  }
}



  Future<void> _togglePlayback() async {
  if (_isPlaying) {
    setState(() {
      // _audioPlayer.pause();
      widget.audioHandler.play();
      //_controller2.play();
    });
  } else {
    setState(() {
      //_audioPlayer.play();
      widget.audioHandler.pause();
      //_controller2.pause();
    });
  }
  setState(() {
    _isPlaying = !_isPlaying;
  });
}

  Future<void> toggleLike() async {
    setState(() {
      _isLiked = !_isLiked;
    });
  }

  int _getVideoQualityValue(VideoQuality videoQuality) {
  switch (videoQuality) {
    case VideoQuality.unknown:
      return 0;
    case VideoQuality.low144:
      return 144;
    case VideoQuality.low240:
      return 240;
    case VideoQuality.medium360:
      return 360;
    case VideoQuality.medium480:
      return 480;
    case VideoQuality.high720:
      return 720;
    case VideoQuality.high1080:
      return 1080;
    default:
      return 0;
  }
}
Future<void> fetchLyrics( title,  singer) async {
  try {
    final response = await http.get(Uri.parse(
        'https://paxsenixofc.my.id/server/getLyricsMusix.php?q=$title%20$singer&type=default'));

    if (response.statusCode == 200) {
      final data = response.body;
      final parsedLyrics = <lyric>[];

      for (final line in data.split('\n')) {
        if (line.isNotEmpty) {
          final timeIndex = line.indexOf(']');
          if (timeIndex != -1) {
            final timeString = line.substring(1, timeIndex);
            final time = DateFormat("mm:ss.SS'").parse(timeString);
            final lyricsText = line.substring(timeIndex + 1).trim();
            parsedLyrics.add(
              lyric(
                words: lyricsText,
                time: time,
              ),
            );
          }
        }
      }

      // Check if lyrics actually change before updating the state
      if (parsedLyrics.isNotEmpty && parsedLyrics != lyrics) {
      
          lyrics = parsedLyrics;
          isLyric = true;
      } else if (parsedLyrics.isEmpty) {
       
          lyrics = ['Failed to load lyrics'] as List<lyric>;
        
        throw Exception('Failed to load lyrics');
      }
    } else {
    
        lyrics = ['Failed to load lyrics'] as List<lyric>;
   
      throw Exception('Failed to load lyrics');
    }
  } catch (error) {
    print('Error fetching lyrics: $error');
  }
}

  Future<void> _initPlayer() async {
  try {
    print(widget.currentIndex);
    print(widget.currentIndex);
    print(widget.currentIndex);
    //await widget.audioHandler.updateQueue([]);
    // final yt = YoutubeExplode();
    // final result = await yt.search.search((widget.songList[widget.currentIndex].title).toString() + ' ' + (widget.songList[widget.currentIndex].singer).toString() + 'audio',);
    
    // final videoId = result.first.id.value;
    // var manifest = await yt.videos.streamsClient.getManifest (videoId);
    // var audioUrl = manifest.audioOnly.first.url;
    // var video = await yt.videos.get(videoId);
    // var dur = video.duration?.inMilliseconds;
    // // // Get the duration of the video in seconds
    // print(dur);
    //   // Get the duration of the video in seconds
    //   var durationInSeconds = video.duration!.inSeconds;

    //   // Convert duration to milliseconds
    //   var durationInMilliseconds = durationInSeconds * 1000;


    // Uri? highestQualityVideoUrl;
    // if (manifest.muxed.isNotEmpty) {
    //   print(manifest.muxed);
    //   var highestQuality = -1;
    //   for (var streamInfo in manifest.muxed) {
    //     var videoQuality = streamInfo.videoQuality;
    //     if (videoQuality != null) {
    //       var videoQualityValue = _getVideoQualityValue(videoQuality);
    //       if (videoQualityValue > highestQuality) {
    //         highestQuality = videoQualityValue;
    //         print(highestQuality);
    //         highestQualityVideoUrl = streamInfo.url;
    //       }
    //     }
    //   }
    

    //   var videoUrl = manifest.muxed.first.url;
    //   print(videoUrl.toString());
    //     print(manifest.muxed.sortByVideoQuality().bestQuality.url);
    //   _controller2 = VideoPlayerController.networkUrl(manifest.muxed.sortByVideoQuality().first.url)
    //     ..initialize().then((_) {
    //       print(_controller2.value.duration);
    //       setState(() {});

    //       _controller2.play();
          
    //       _controller2.setVolume(0); // Adjust volume as needed
    //       _controller2.addListener(() {
    //       // Listen to the video player's position changes
    //       setState(() {
    //         _sliderValue = _controller2.value.position.inMilliseconds.toDouble() ?? 0.0;
    //       });
    //     });
    //     });
    // }

    //print(formatDuration(_controller2.value.duration ?? Duration(seconds: 0)),);
    
    // await _audioPlayer.setUrl(audioUrl.toString());
    //await _audioPlayer.setUrl(audioUrl.toString());
    print(await _audioPlayer.duration);

    await (widget.audioHandler as MyAudioHandler).playNewMedia(
      widget.songData.audioUrl,
      widget.songData.title,
      widget.songData.singer, 
      'Album name',
      widget.songData.imageUrl,
      widget.songData.duration,
      );

      if(widget.songList.length > 1){
        for (int i=0; i<widget.songList.length; i++){
          await (widget.audioHandler as MyAudioHandler).addQueueItems(
           [ MediaItem(
              id: widget.songList[i].audioUrl,
              album: widget.songList[i].title,
              title: widget.songList[i].title,
              artist: widget.songList[i].singer,
              duration: Duration(milliseconds: widget.songList[i].duration),
              artUri: Uri.parse(widget.songList[i].imageUrl),
            ),]
          );
        }
      }
    
    
    
    //await instance.addMedia(mediaItem);
    //final audio = AudioServiceBackground.setMediaItem(mediaItem);




    // await _audioPlayer.play();
    // _audioPlayer.setVolume(1);
    // _audioPlayer.playbackEventStream.listen((event) {
    //   setState(() {
    //     _sliderValue = event.position.inMilliseconds.toDouble();
    //   });
    //



    
    // setState(() {
    //   duration = result.first.duration ?? Duration(seconds: 0);
    // });
    // _positionSubscription = _audioPlayer.positionStream.listen((event) {
    //   setState(() {
    //     _sliderValue = event.inMilliseconds.toDouble();
    //   });
    // });
  
    //yt.close();
    
  } catch (e) {
    print('Error setting URL: $e');
  }
}




  Future<void> getRecommendations() async {
  try {
    print(widget.songData.title);
    print(widget.songData.singer);

    

     
    
     List<String> genres = widget.songData.genre;
    if (genres.length > 3) {
      genres = genres.sublist(0, 3);
    }
   final recommendations = await spotify.recommendations.get(
    limit: 1, 
    seedTracks: [widget.songData.id],
    seedGenres: genres,
    seedArtists: [widget.songData.artistID],
    market: music.Market.US,
    );

    final search = await spotify.search.get(recommendations.tracks!.first.name!).first(1);
    final yt = YoutubeExplode();
    final result = await yt.search.search((recommendations.tracks!.first.name!).toString() + ' ' + (recommendations.tracks!.first.artists!.first.name!).toString() + 'audio',);
    
    final videoId = result.first.id.value;
    var manifest = await yt.videos.streamsClient.getManifest (videoId);
    var audioUrl = manifest.audioOnly.first.url;

    search.forEach((pages) {
      if (pages.items == null) {
        print('Empty items');
      }
      pages.items!.forEach((item)async {
        if (item is music.Track) {
          print(item.name!);
          print(item.album!.images!.first.url!);
          print(item.artists!.first.name!);
          print(item.id!);
          setState(() {
            _searchResults = item.name!;
            _searchResults2 = item.album!.images!.first.url!;
            _searchResults3 = item.artists!.first.name!;
            market = item.availableMarkets!.first.toString();
            artistID = item.artists!.first.id!;
            // id = item.id!;
            id = audioUrl.toString();
            genres = item.artists!.first.genres!;
            durationsong = item.durationMs!;
            audio = audioUrl.toString();
          });
          yt.close();
          // await (widget.audioHandler as MyAudioHandler).addQueueItem(
          //   MediaItem(
          //     id: audioUrl.toString(),
          //     album: _searchResults,
          //     title: _searchResults,
          //     artist: _searchResults3,
          //     duration: Duration(milliseconds: durationsong),
          //     artUri: Uri.parse(_searchResults2),
          //   ),
          // );

    //        await (widget.audioHandler as MyAudioHandler).playNewMedia(
    //   audioUrl.toString(),
    //   widget.songList[currentSong].title,
    //   widget.songList[currentSong].singer,
    //   widget.songList[currentSong].id,
    //   widget.songList[currentSong].imageUrl,
    //   widget.songList[currentSong].duration, 
    // );
          

        }else if(item is music.Artist){
          print(item.genres);
        }
      }
      );
    });
    
  } catch (e) {
    print('Error fetching recommendations: $e');
    // Handle error
  }finally{
    setState(() {
      isNext = true;
      
    });
  }
}

String formatDuration(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  return '${duration.inMinutes}:${twoDigitSeconds}';
}


previosSong() async{
  if (widget.currentIndex == 0) {
      return;
    }
    // Navigator.pushReplacement(context, CupertinoSlideBackPageRoute(page:  PlaySong(
    // songData: SongData(
    //   id: id, 
    //   imageUrl: _searchResults2, 
    //   title: _searchResults, 
    //   singer:  _searchResults3, 
    //   artistID: artistID, 
    //   genre: genre,
    //   duration: durationsong
    //   ),
    //   songList: widget.songList,
    //   currentIndex: widget.currentIndex - 1,
    //   audioHandler: widget.audioHandler,
    // )));
    await (widget.audioHandler as MyAudioHandler).customskipToPrevious(widget.currentIndex);
    //widget.audioHandler.skipToPrevious();
   
}

nextSong() async{
  if(widget.currentIndex != widget.songList.length - 1){
  //                            Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context)=> PlaySong(
  //                             songData: SongData(
  //                               id: id, 
  //                               imageUrl: _searchResults2, 
  //                               title: _searchResults, 
  //                               singer:  _searchResults3, 
  //                               artistID: artistID, 
  //                               genre: genre,
  //                               duration: durationsong
                                
  //                               ),
  //                               songList: widget.songList,
  //                               currentIndex: widget.currentIndex + 1,
  //                               audioHandler: widget.audioHandler,
  //                             )));
  
await (widget.audioHandler as MyAudioHandler).customskipToNext(widget.currentIndex)
    .then((value) {
  if (mounted) {
    setState(() {
      // Update the here
      widget.currentIndex = widget.currentIndex + 1;
    });
  }
});
  
  //widget.audioHandler.skipToNext();
  
                             return;
                          }
                            await getRecommendations();
                            setState(() {
                              widget.songList.add(SongData(
                                id: id, 
                                imageUrl: _searchResults2,
                                title: _searchResults, 
                                singer: _searchResults3,
                                 artistID: artistID, 
                                 genre: genre,
                                 duration: durationsong,
                                audioUrl: audio                        
                                 ));
                                 
                            });

                              await (widget.audioHandler as MyAudioHandler).playNewMedia(
                                    id,
                                    _searchResults,
                                    _searchResults3,
                                    'Album name',
                                    _searchResults2,
                                    durationsong,
                                  );
                              
  //                           Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context)=> PlaySong(
  //                             songData: SongData(
  //                               id: id, 
  //                               imageUrl: _searchResults2, 
  //                               title: _searchResults, 
  //                               singer:  _searchResults3, 
  //                               artistID: artistID, 
  //                               genre: genre,
  //                               duration: durationsong
                                
  //                               ),
  //                               songList: widget.songList,
  //                               currentIndex: widget.currentIndex + 1,
  //                               audioHandler: widget.audioHandler,
  //                             )));
  // await (widget.audioHandler as MyAudioHandler).playNewMedia(
  //   id,
  //   _searchResults,
  //   _searchResults3,
  //   'Album name',
  //   _searchResults2,
  //   durationsong,
  // );
  
  
  
}


   Future<void> _seek(double value) async {
     widget.audioHandler.seek(Duration(milliseconds: value.toInt()));
     
  }
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
    extendBody: true,
    body: SingleChildScrollView(
      child: StreamBuilder<MediaItem?>(
        stream: widget.audioHandler.mediaItem,
        builder: (context, snapshot) {
          
          //_fetchDominantColor(mediaItem?.artUri.toString());
          if (snapshot.connectionState == ConnectionState.waiting) {
      // Return a loading indicator while fetching the dominant color
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          // Handle error case
          return Text('Error fetching dominant color');
        } else {
          var mediaItem = snapshot.data;
          MediaItem? _previousMediaItem;
          if (mediaItem != _previousMediaItem) {
        // Reset the flag when the mediaItem changes
        _isDominantColorFetched = false;

        _previousMediaItem = mediaItem;

        // Call your function here only if dominant color hasn't been fetched yet
        if (!_isDominantColorFetched && mediaItem?.artUri != null && mediaItem?.artist != null && mediaItem?.title != null) {
          _fetchDominantColor(mediaItem!.artUri.toString());
          fetchLyrics(mediaItem!.title, mediaItem!.artist!);
          _isDominantColorFetched = true; // Mark dominant color as fetched
        }
      }
           
       
       
          return 
           AnimatedContainer(
              duration: Duration(milliseconds: 500),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [dominantColor ?? Colors.black, dominantColor ?? Colors.black, Colors.black], // Change colors as needed
                ),
              ),
              child: Stack(
                children: [
                 
                  AnimatedOpacity(
                    duration: Duration(milliseconds: 500),
                    opacity: _controlsVisible ? 1.0 : 0.0,
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (MediaQuery.of(context).orientation == Orientation.portrait) SizedBox(height: 60.0),
                         Hero(
                                    tag: mediaItem?.id ?? '',
                                    child: Container(
                                      height: MediaQuery.of(context).orientation == Orientation.portrait ? 320 : MediaQuery.of(context).size.height * 0.3,
                                      width: MediaQuery.of(context).orientation == Orientation.portrait ? 320 : MediaQuery.of(context).size.width * 1,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        image: DecorationImage(
                                          image: NetworkImage(mediaItem?.artUri.toString() ?? widget.songList[widget.currentIndex].imageUrl),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                          
                          SizedBox(height: 40.0),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 22, vertical: 0),
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                            mediaItem?.title ?? '',
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontFamily: GoogleFonts.poppins().fontFamily,
                                            ),
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                    Text(
                                            mediaItem?.artist ?? '',
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w300,
                                              color: Colors.white,
                                              fontFamily: GoogleFonts.poppins().fontFamily,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          )
                                    ],
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    toggleLike();
                                  },
                                  icon: Icon(
                                    _isLiked ? Icons.favorite : Icons.favorite_border,
                                    size: 30,
                                    color: _isLiked ? Colors.red : Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 0.0),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.89,
                            child: Column(
                              children: [
                                StreamBuilder<MediaState>(
                                  stream: _mediaStateStream,
                                  builder: (context, snapshot) {
                                    final mediaState = snapshot.data;
                                    return SeekBar(
                                      activeColor: dominantColor ?? Colors.white,
                                      duration: mediaState?.mediaItem?.duration ?? Duration.zero,
                                      position: mediaState?.position ?? Duration.zero,
                                      onChangeEnd: (newPosition) {
                                        widget.audioHandler.seek(newPosition);
                                      },
                                    );
                                  },
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      StreamBuilder<MediaState>(
                                        stream: _mediaStateStream,
                                        builder: (context, snapshot) {
                                          final mediaState = snapshot.data;
                                          final position = mediaState?.position ?? Duration.zero;
                                          final minutes = position.inMinutes;
                                          final seconds = position.inSeconds.remainder(60);
            
                                          final formattedPosition = '$minutes:${seconds.toString().padLeft(2, '0')}';
            
                                          return Text(
                                            formattedPosition,
                                            style: TextStyle(
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: GoogleFonts.poppins().fontFamily,
                                              color: Colors.white,
                                            ),
                                          );
                                        },
                                      ),
                                      StreamBuilder<MediaState>(
                                        stream: _mediaStateStream,
                                        builder: (context, snapshot) {
                                          final mediaState = snapshot.data;
                                          final position = mediaState?.mediaItem?.duration ?? Duration.zero;
                                          final minutes = position.inMinutes;
                                          final seconds = position.inSeconds.remainder(60);
            
                                          final formattedPosition = '$minutes:${seconds.toString().padLeft(2, '0')}';
            
                                          return Text(
                                            formattedPosition,
                                            style: TextStyle(
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: GoogleFonts.poppins().fontFamily,
                                              color: Colors.white,
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10.0),
                          Container(
                            height: 75,
                            width: MediaQuery.of(context).size.width * 0.85,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    if (isLyric==true)
                                    Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                        builder: (context) => Lyrics(
                                          id: mediaItem?.id ?? '',
                                          songName: mediaItem?.title ?? '',
                                          artistName: mediaItem?.artist ?? '',
                                          //controller2: _controller2, // Pass duration here
                                          imagePath: mediaItem?.artUri.toString() ?? widget.songList[widget.currentIndex].imageUrl,
                                          lyrics: lyrics,
                                          dominantColor: dominantColor,
                                          audioHandler: widget.audioHandler,
                                        ),
                                      ),
                                    );
                                    else
                                    return;
                                  },
                                  icon: Icon(isLyric ?  Icons.lyrics : Icons.no_cell, color: isLyric ? Colors.white : Colors.grey, size: 32),
                                ),
                                IconButton(
                                  icon: Icon(Icons.skip_previous),
                                  color: widget.currentIndex == 0 ? Colors.grey : Colors.white,
                                  iconSize: 48.0,
                                  onPressed: () {
                                    previosSong();
                                  },
                                ),
                                StreamBuilder<bool>(
                                  stream: widget.audioHandler.playbackState.map((state) => state.playing).distinct(),
                                  builder: (context, snapshot) {
                                    final playing = snapshot.data ?? false;
                                    return IconButton(
                                      icon: playing ? Icon(Icons.pause) : Icon(Icons.play_arrow),
                                      iconSize: 56.0,
                                      onPressed: () => playing ? widget.audioHandler.pause() : widget.audioHandler.play(),
                                      color: Colors.white,
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.skip_next),
                                  iconSize: 48.0,
                                  color: Colors.white,
                                  onPressed: () {
                                    nextSong();
                                  },
                                ),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _controlsVisible = !_controlsVisible;
                                    });
                                  },
                                  icon: Icon(Icons.shuffle_sharp, color: Colors.white, size: 32),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20.0),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 100,
                      child: AppBar(
                        leading: IconButton(
                          icon: Icon(Icons.arrow_back_ios, color: Colors.white,),
                          onPressed: (){
                            Navigator.pop(context);
                          },
                        ),
                        title: Container(
                          padding: EdgeInsets.only(right: 30, top: 15),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Now Playing',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontFamily: GoogleFonts.poppins().fontFamily,
                                ),
                              ),
                            Text(
                                    mediaItem?.title ?? '',
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.white,
                                      fontFamily: GoogleFonts.poppins().fontFamily,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  )
                            ],
                          ),
                        ),
                        centerTitle: false,
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                      ),
                    ),
                  ),
                ],
              ),
            );  
            }
        
          
        
        },
      ),
    ),
  );
  }
  Stream<MediaState> get _mediaStateStream =>
      Rx.combineLatest2<MediaItem?, Duration, MediaState>(
          widget.audioHandler.mediaItem,
          AudioService.position,
          (mediaItem, position) => MediaState(mediaItem, position));

  IconButton _button(IconData iconData, VoidCallback onPressed) => IconButton(
        icon: Icon(iconData),
        iconSize: 64.0,
        onPressed: onPressed,
      );
      

}


class MediaState {
  final MediaItem? mediaItem;
  final Duration position;

  MediaState(this.mediaItem, this.position);
}

class SeekBar extends StatelessWidget {
  final Duration duration;
  final Duration position;
  final ValueChanged<Duration> onChangeEnd;
  final activeColor;

  SeekBar({
    required this.duration,
    required this.position,
    required this.onChangeEnd,
    required this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    double max = duration.inMilliseconds.toDouble();
    double value = position.inMilliseconds.toDouble();

    // Ensure that duration is valid and not null
    if (max <= 0) {
      max = 1.0; // Set a default maximum value to avoid division by zero
    }

    // Ensure that position is within bounds
    if (value < 0) {
      value = 0;
    } else if (value > max) {
      value = max;
    }

    return Slider(
      min: 0.0,
      max: max,
      value: value,
      activeColor: activeColor,
      onChanged: (value) {},
      onChangeEnd: (value) {
        onChangeEnd(Duration(milliseconds: value.toInt()));
      },
    );
  }
  
}

