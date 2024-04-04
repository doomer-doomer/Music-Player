import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:testz/pages/model/lyric.dart';
import 'package:video_player/video_player.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:palette_generator/palette_generator.dart';

class Lyrics extends StatefulWidget {
  final String songName;
  final String artistName;
  //final VideoPlayerController controller2;
  final AudioHandler audioHandler;
  final String imagePath;
  final String id;
  final List<lyric>? lyrics;
  final Color? dominantColor;

  const Lyrics({
    Key? key,
    required this.id,
    required this.songName,
    required this.artistName,
    //required this.controller2,
    required this.imagePath,
    required this.lyrics,
    this.dominantColor,
    required this.audioHandler
  }) : super(key: key);

  @override
  State<Lyrics> createState() => _LyricsState();
}

class _LyricsState extends State<Lyrics> {
  List<lyric>? lyrics;
  final ItemScrollController itemScrollController = ItemScrollController();
  int currentIndex = 0;
  late StreamSubscription<PlaybackState> _playbackStateSubscription;
  //Color? dominantColor;

  @override
  void initState() {
    super.initState();
    
    //_fetchDominantColor();
    //widget.controller2.addListener(_scrollLyricsToCurrentPosition);
    _playbackStateSubscription= widget.audioHandler.playbackState.listen((state) {
      if (state?.playing ?? false) {
        _scrollLyricsToCurrentPosition();
      }
    });
  }

  @override
  void dispose() {
    //widget.controller2.removeListener(_scrollLyricsToCurrentPosition);
     _playbackStateSubscription.cancel();
    super.dispose();
  }

  Future<void> _fetchDominantColor() async {
    try {
      final paletteGenerator = await PaletteGenerator.fromImageProvider(
        NetworkImage(
          widget.imagePath, // Replace with your image URL
        ),
      );

      setState(() {
        //dominantColor =
            //paletteGenerator.dominantColor?.color ?? Colors.white;
       
      });
    } catch (e) {
      print('Error fetching dominant color: $e');
     
    }
  }

 void _scrollLyricsToCurrentPosition() {
    if (widget.lyrics != null) {
        AudioService.position.listen((Duration position) { 
          print(position);
         });

        AudioService.position.listen((Duration position) { 
           
            if (position != null) {
                int newIndex = 0;
                for (int i = 0; i < widget.lyrics!.length; i++) {
                    Duration lyricDuration = widget.lyrics![i].time.difference(DateTime(1970, 1, 1));
                    Duration nextLyricDuration = i < widget.lyrics!.length - 1
                        ? widget.lyrics![i + 1].time.difference(DateTime(1970, 1, 1))
                        : Duration(hours: 24); // Assume the next lyric is very far in the future
                    if (position.inMilliseconds >= lyricDuration.inMilliseconds && position.inMilliseconds < nextLyricDuration.inMilliseconds) {
                        newIndex = i;
                        break; // Exit the loop once we find the correct index
                    }
                }
                if (newIndex != currentIndex) {
                    if (mounted) { // Check if the State object is still mounted
                        setState(() {
                            currentIndex = newIndex;
                        });
                        itemScrollController.scrollTo(
                            index: currentIndex - 1,
                            duration: Duration(milliseconds: 1500),
                            curve: Curves.easeInOut,
                        );
                    }
                }
            }
        });
    }
}



 
  @override
Widget build(BuildContext context) {
  const colorizeColors = [
    Colors.white70,
  Colors.white60,
  Colors.white,
  Colors.white,
  Colors.white60,
  Colors.white70,
];

TextStyle colorizeTextStyle = TextStyle(
  fontSize: 18.0,
  fontFamily: GoogleFonts.poppins().fontFamily,

);
  return 
    Scaffold(
      
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [widget.dominantColor ?? Colors.black,widget.dominantColor ?? Colors.black, Colors.black], // Change colors as needed
            ),
          ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
              
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                 Hero(
                  tag: widget.id,
                   child: Image.network(
                                 widget.imagePath,
                                 fit: BoxFit.cover,
                                 width: double.infinity,
                                 height: MediaQuery.of(context).orientation == Orientation.portrait? 240 : 120, // Adjust height as needed
                               ),
                 ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.songName,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 24.0,
                        color: Colors.white,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontWeight: FontWeight.bold,
                        
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '${widget.artistName}',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.white60,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                      ),
                    ),
                  ],
                ),
              ),
                ],
              ),
            
            Expanded(
              child: widget.lyrics != null
                  ? LayoutBuilder(
                      builder: (context, constraints) {
                        // Calculate the total height occupied by lyrics
                        double totalLyricsHeight = widget.lyrics!.length * 26.0; // Assuming 26 is the average line height
            
                        // Check if the total lyrics height is greater than the available screen height
                        bool isScrollable = totalLyricsHeight > constraints.maxHeight;
            
                        return isScrollable
                            ? ScrollablePositionedList.builder(
                                itemCount: widget.lyrics!.length,
                                itemBuilder: (context, index) {
                                  if (index >= 0 && index < widget.lyrics!.length) {
        final lyric = widget.lyrics![index];
        final lines = lyric.words.split('\n');
        return Stack(
        alignment: Alignment.centerLeft,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: lines.map((line) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: currentIndex == index ?
                  Text(
                    line,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                     fontWeight: FontWeight.bold
                    ),
                  )
                   : Text(
                    line,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white60,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
            );
            } else {
        // Return an empty container if index is out of bounds
        return Container();
            }
                                },
                                
                                itemScrollController: itemScrollController,
                                itemPositionsListener: ItemPositionsListener.create(),
        
                              )
                            : Container();
                      },
                    )
                  : Center(
                      child: LoadingAnimationWidget.staggeredDotsWave(color:  Colors.white, size: 56)
                       
                    ),
            ),
          ],
        ),
      ),
    
  );
}

}
