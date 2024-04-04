import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spotify/spotify.dart' as music;
import 'package:testz/pages/home.dart';
import 'package:testz/pages/playlist.dart';
import 'package:testz/pages/route/customPush.dart';
import 'package:testz/pages/song.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:testz/pages/songData.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class SearchScreen extends StatefulWidget {
  final AudioHandler audioHandler;
  const SearchScreen({Key? key, 
   required this.audioHandler
   }) : super(key: key);
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _searchQuery = '';
  List<String> id = [];
  List<String> _searchResults = [];
  List<String> _searchResults2 = [];
  List<String> _searchResults3 = [];
  List<String> market = [];
  List<String> artistID = [];
  List<List<String>> genre = [];

  List<String> playlistname = [];
  List<String> playlistID = [];
  List<String> playlistImage = [];
  List<String> playlistOwner = [];
  List<String> playlistDescription = [];
  List<String> playlistartistID = [];
  List<String> type = [];
  List<int> duration = [];
  List<String> audio = [];

  bool isload = true;
  late GlobalKey<AnimatedListState> global;



  late var cred = music.SpotifyApiCredentials('d96f4905b91247d8b38c24e3a77155bd', 'd86c9dead5084cada0ed5cd37073c14c');
   late var spotify = music.SpotifyApi(cred);

  


  @override
  void initState() {
    global = GlobalKey<AnimatedListState>();
    super.initState();
  }
  
  
void _search(String? query) async {
  if (query == null || query.isEmpty) {
    setState(() {
      // Clear state when query is empty
      // (omitted for brevity)
    });
    return;
  }

  setState(() {
    // Set loading state
    // (omitted for brevity)
  });

  try {
    var search = await spotify.search.get(query).first(15);
    

    // Clear previous search results
    setState(() {
      _searchResults.clear();
      _searchResults2.clear();
      _searchResults3.clear();
      artistID.clear();
      market.clear();
      genre.clear();
      id.clear();
      duration.clear();
      playlistID.clear();
      playlistname.clear();
      playlistImage.clear();
      playlistOwner.clear();
      playlistDescription.clear();
      playlistartistID.clear();
      type.clear();
      audio.clear();
    });

    for (var pages in search) {
      if (pages.items == null) {
        print('Empty items');
        continue;
      }

      for (var item in pages.items!) {
        if (item is music.Track) {
          final yt = YoutubeExplode();
          final result = await yt.search.search(item.name! + " " + item.artists!.first.name! + ' audio');
          final videoId = result.first.id.value;
          var manifest = await yt.videos.streamsClient.getManifest(videoId);
          var audioUrl = manifest.audioOnly.first.url;
          yt.close();
          setState(() {
            // Update state with search results
            _searchResults.add(item.name != '' ? item.name! : '');
            _searchResults2.add(item.album!.images!.first.url != "" ? item.album!.images!.first.url! : '');
            _searchResults3.add(item.artists!.first.name! ?? '');
            artistID.add(item.artists!.first.id!);
            type.add(item.type!);
            duration.add(item.durationMs!);
            id.add(item.id!);
            audio.add(audioUrl.toString());
            
          });
          global.currentState!.insertItem(_searchResults.length - 1,duration: Duration(milliseconds: 500));
        } else if (item is music.Artist) {
          setState(() {
            genre.add(item.genres!);
          });
        } else if (item is music.PlaylistSimple) {
          setState(() {
            playlistID.add(item.id!);
            playlistname.add(item.name!);
            playlistImage.add(item.images!.first.url!);
            playlistOwner.add(item.owner!.id!);
            playlistDescription.add(item.description!);
            playlistartistID.add(item.owner!.id!);
            type.add(item.type!);
          });
          global.currentState!.insertItem(playlistID.length - 1,duration: Duration(milliseconds: 500));
        }
      }
    }

    setState(() {
      // Clear loading state
      // (omitted for brevity)
    });
  } catch (e) {
    print('Error during search: $e');
  }finally{
    setState(() {
      isload = false;
    });
  }
}




  @override
  Widget build(BuildContext context) {
    return 
    PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) {
          
        }
      
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: TextField(
            
            onChanged: (value) {
              _searchQuery = value;
              _search(value);
            },
            style: TextStyle(
              color: Colors.white,
              
              fontSize: 16,
              fontFamily: GoogleFonts.poppins().fontFamily,
            ),
            decoration: InputDecoration(
              hintText: 'Search...',
              border: InputBorder.none,
              hintStyle: TextStyle(
                color: Colors.grey,
                fontSize: 16,
                fontFamily: GoogleFonts.poppins().fontFamily,
              ),
              
              
            ),
          ),
        ),
        body:isload? Center(child: CircularProgressIndicator(color: Colors.greenAccent,),) :
        AnimatedList(
  key: global,
  initialItemCount: _searchResults.length + playlistID.length,
  itemBuilder: (context, index, animation) {
    if (index.isEven) {
      // Even index represents track tiles
      final trackIndex = index ~/ 2;
      if (trackIndex >= _searchResults.length) {
        return SizedBox(); // This means we have more albums than tracks, so we ignore it
      }
      return FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: Tween<Offset>( begin: Offset(0, 0.25), end: Offset(0, 0)).animate(animation), 
          
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            horizontalTitleGap: 15,
            title: Text(
              _searchResults[trackIndex],
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: GoogleFonts.poppins().fontFamily,
              ),
            ),
            subtitle: Text(
              _searchResults3[trackIndex],
              style: TextStyle(fontSize: 12, color: Colors.grey[400]),
            ),
            leading: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${(trackIndex + 1) * 2 - 1}. ',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
                SizedBox(width: 8),
                Hero(
                  tag: audio[trackIndex],
                  child: CachedNetworkImage(
                    imageUrl: _searchResults2[trackIndex],
                    placeholder: (context, url) => LoadingAnimationWidget.flickr(
                      size: 30,
                      leftDotColor: Colors.pinkAccent,
                      rightDotColor: Colors.blueAccent,
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => PlaySong(
                    songData: SongData(
                      id: id[trackIndex],
                      imageUrl: _searchResults2[trackIndex],
                      title: _searchResults[trackIndex],
                      singer: _searchResults3[trackIndex],
                      artistID: artistID[trackIndex],
                      genre: genre[trackIndex],
                      duration: duration[trackIndex],
                      audioUrl: audio[trackIndex],
                    ),
                    songList: [],
                    currentIndex: 0,
                    audioHandler: widget.audioHandler,
                  ),
                ),
              );
            },
          ),
        ),
      );
    } else {
      // Odd index represents album tiles
      final albumIndex = (index - 1) ~/ 2;
      if (albumIndex >= playlistID.length) {
        return SizedBox(); // This means we have more tracks than albums, so we ignore it
      }
      return FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: Tween<Offset>( begin: Offset(0, 0.25), end: Offset(0, 0)).animate(animation), 
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            horizontalTitleGap: 15,
            title: Text(
              playlistname[albumIndex],
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: GoogleFonts.poppins().fontFamily,
              ),
            ),
            subtitle: Text(
              playlistOwner[albumIndex],
              style: TextStyle(fontSize: 12, color: Colors.grey[400]),
            ),
            leading: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${(albumIndex + 1) * 2}. ',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
                SizedBox(width: 8),
                Hero(
                  tag: playlistID[albumIndex],
                  child: Image.network(
                    playlistImage[albumIndex],
                    width: 60, // Adjust width as needed
                    height: 60, // Adjust height as needed
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
            onTap: () {
              FocusScope.of(context).unfocus();
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => PlaylistSongz(
                    id: playlistID[albumIndex],
                    imageUrl: playlistImage[albumIndex],
                    title: playlistname[albumIndex],
                    audioHandler: widget.audioHandler,
                  ),
                ),
              );
            },
          ),
        ),
      );
    }
  },
),


      
      ),
    );
  }
}