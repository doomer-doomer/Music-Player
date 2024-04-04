import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:spotify/spotify.dart' as music;
import 'package:google_fonts/google_fonts.dart';
import 'package:testz/pages/song.dart';
import 'package:testz/pages/songData.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class PlaylistSongz extends StatefulWidget {
  final String id;
  final String imageUrl;
  final String title;
  final AudioHandler audioHandler;
  const PlaylistSongz({super.key, 
  required this.id,
  required this.imageUrl, 
  required this.title
  , required this.audioHandler
  });

  @override
  State<PlaylistSongz> createState() => _PlaylistSongzState();
}

class _PlaylistSongzState extends State<PlaylistSongz> {
  String _searchQuery = '';
  List<String> id = [];
  List<String> _searchResults = [];
  List<String> _searchResults2 = [];
  List<String> _searchResults3 = [];
  List<String> market = [];
  List<String> artistID = [];
  List<List<String>> genre = [];
  List<SongData> songData = [];
  List<int> duration = [];
  List<String> audio = [];
  bool isload = false;
  late GlobalKey<AnimatedListState> global;
  bool _isLiked = false;
  Color? dominantColor;

  late var cred = music.SpotifyApiCredentials('d96f4905b91247d8b38c24e3a77155bd', 'd86c9dead5084cada0ed5cd37073c14c');
   late var spotify = music.SpotifyApi(cred);

    @override
  void initState() {
    //_search();
    print(widget.id);
    print(widget.title);
    print(widget.imageUrl);
     fetchTracks();
    _fetchDominantColor();
    super.initState();
    global = GlobalKey<AnimatedListState>();
  }
  
  @override
  void dispose() {
    
    super.dispose();
  }



  void _search() async {
  

  var search = await spotify.search.get(widget.title).first(20);
  
  setState(() {
    _searchResults.clear(); // Clear the search results list before adding new results
    _searchResults2.clear(); // Clear the image URLs list as well
    _searchResults3.clear();
    artistID.clear();
      market.clear();
      genre.clear();
      id.clear();
      audio.clear();
    search.forEach((pages) {
      if (pages.items == null) {
        print('Empty items');
      }
      pages.items!.forEach((item) {
        if (item is music.Track) {
          _searchResults.add(item.name!);
          _searchResults2.add(item.album!.images!.first.url!);
          _searchResults3.add(item.artists!.first.name!);
          id.add(item.id!);
          artistID.add(item.artists!.first.id!);
          market.add(item.availableMarkets!.first.toString());
          
          print(item.name!);
        }else if (item is music.PlaylistSimple) {
         
        }
        else if (item is music.Artist) {
         genre.add(item.genres!);
        }
      });
    });
  });
  setState(() {
    isload = true;
  
  });
}


 fetchTracks() async {
    try {
      var tracksResponse = await spotify.playlists.getTracksByPlaylistId(widget.id).all();
      print(tracksResponse);
      setState(() {
        isload = true;
      });
      // Accessing the tracks from the response
      List<music.Track> tracks = tracksResponse.toList() ?? [];

      setState(() {
         _searchResults.clear(); // Clear the search results list before adding new results
    _searchResults2.clear(); // Clear the image URLs list as well
    _searchResults3.clear();
    artistID.clear();
      market.clear();
      genre.clear();
      id.clear();
      duration.clear();
      audio.clear();
      });
      // Print tracks
      for (var track in tracks) {
        var search = await spotify.search.get(track.name! + " " + track.artists!.first.name!).first(1);

      
          
          
        
        search.forEach((pages){
          if (pages.items == null) {
            print('Empty items');
          }
          pages.items!.forEach((item) async{
            if(item is music.Artist){

              final yt = YoutubeExplode();
              final result = await yt.search.search(track.name! + " " + track.artists!.first.name! + ' audio');
              
              final videoId = result.first.id.value;
              var manifest = await yt.videos.streamsClient.getManifest (videoId);
              var audioUrl = manifest.audioOnly.first.url;
              setState(() {
                id.add(audioUrl.toString());
              _searchResults.add(track.name!);
              _searchResults2.add(track.album!.images!.first.url!);
              _searchResults3.add(track.artists!.first.name!);
              artistID.add(track.artists!.first.id!);
              //market.add(track.availableMarkets!.first.toString());
              genre.add(item.genres!);
              duration.add(track.durationMs!);
              audio.add(audioUrl.toString());

              songData.add(SongData(
                id: track.id!, 
                imageUrl: track.album!.images!.first.url!, 
                title: track.name!, 
                singer: track.artists!.first.name!, 
                artistID: track.artists!.first.id!, 
                genre: item.genres!,
                duration: track.durationMs!,
                audioUrl: audioUrl.toString()
                ));
              });
              
               
                yt.close();

             global.currentState!.insertItem(id.length-1);
                          }
          });
          
        });
      
        
        setState(() {
          isload = true;
        
        });
        
      }
    } catch (e) {
      print('Error fetching tracks: $e');
    }
  }

   Future<void> _fetchDominantColor() async {
    try {
      final paletteGenerator = await PaletteGenerator.fromImageProvider(
        NetworkImage(
          widget.imageUrl, // Replace with your image URL
        ),
      );

      setState(() {
        dominantColor =
            paletteGenerator.dominantColor?.color ?? Colors.white;
       
      });
    } catch (e) {
      print('Error fetching dominant color: $e');
     
    }
  }

  Future<void> toggleLike() async {
    
    setState(() {
      _isLiked = !_isLiked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [dominantColor ?? Colors.black,dominantColor ?? Colors.black, Colors.black], // Change colors as needed
            ),
          ),
        child: Stack(
          children: [
           
            
            Container(
              height: 400,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30)
                )
              ),
             
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 240,
                    decoration: BoxDecoration(
                      
                      borderRadius: BorderRadius.circular(20)
                    ),
                    child: Hero(tag: widget.id,child: Image.network(widget.imageUrl, width: 280, height: 300, fit: BoxFit.cover,)),
                  ),
                  SizedBox(height: 20,),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(20)
                    
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                          
                            Expanded(child: Text(widget.title, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: GoogleFonts.poppins().fontFamily,),overflow: TextOverflow.ellipsis,)),
                            IconButton(
                        onPressed: (){
                          toggleLike();
                  }, icon: Icon(
                     _isLiked ? Icons.favorite : Icons.favorite_border
                    , size: 30,  color: _isLiked ? Colors.red: Colors.white,)),
                          ],
                        ),
                       

                        
                        Text('Playlist', style: TextStyle(fontSize: 14, color: Colors.grey[400], fontFamily: GoogleFonts.poppins().fontFamily,),),
                          
                      ],
                    )
                  ),
                  
                 
                         
                         ] ),
            ),
           
            Container(
              width: double.infinity,
              height: 600,
              margin: EdgeInsets.only(top: 350),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30)
                )
              ),
              child: isload ?
              AnimatedList( 
                key: global, 
                initialItemCount: 0, 
                itemBuilder: (context, index, animation) {
                return 
                   FadeTransition(
                    opacity: animation,
                     child: SlideTransition(
                      position: Tween<Offset>( begin: Offset(0, 0.25), end: Offset(0, 0)).animate(animation), 
                      
                      child: ListTile(
                        
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                      horizontalTitleGap: 15,
                      title: Text(_searchResults[index], style: TextStyle(fontSize: 14
                      , fontWeight: FontWeight.bold, color: Colors.white,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      )),
                      subtitle: Text(_searchResults3[index], style: TextStyle(fontSize: 12,color: Colors.grey[400])),
                      leading: Row(
                                mainAxisSize: MainAxisSize.min, 
                                children: [
                                  Text(
                                       '${index + 1}. ',
                                       style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 14,
                                       ),
                                  ),
                                  SizedBox(width: 8,),
                                  Hero(
                                    tag: audio[index],
                                    child: CachedNetworkImage(
                                      imageUrl: _searchResults2[index],
                                      width: 60, // Adjust width as needed
                                      height: 60, // Adjust height as needed
                                      placeholder: (context, url) => LoadingAnimationWidget.flickr(size: 30, 
                                      leftDotColor: Colors.pinkAccent,
                                      rightDotColor: Colors.blueAccent,),
                                      errorWidget: (context, url, error) => Icon(Icons.error),
                                    ),
                                  ),
                                ],
                              ),
                      onTap: () {
                        Navigator.push(context, CupertinoPageRoute(builder: (context) => PlaySong(
                          songData: SongData(
                            id: id[index], 
                            imageUrl: _searchResults2[index], 
                            title: _searchResults[index], 
                            singer: _searchResults3[index], 
                            //market: market[index], 
                            artistID: artistID[index], 
                            genre: genre[index],
                            duration: duration[index],
                            audioUrl: audio[index]
                            ),
                            songList: songData,
                            currentIndex: index,
                            audioHandler: widget.audioHandler,
                            
                          )));
                                       
                      },
                                       )
                                     ),
                   );
              },) 
              //ListView.builder(
      //   itemCount: _searchResults.length,
      //   itemBuilder: (context, index) {
      //     int itemNumber = index + 1;
      //     return ListTile(
            
      //       contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      //       horizontalTitleGap: 15,
      //       title: Text(_searchResults[index], style: TextStyle(fontSize: 14
      //       , fontWeight: FontWeight.bold, color: Colors.white,
      //       fontFamily: GoogleFonts.poppins().fontFamily,
      //       )),
      //       subtitle: Text(_searchResults3[index], style: TextStyle(fontSize: 12,color: Colors.grey[400])),
            
      //       leading: Row(
      //   mainAxisSize: MainAxisSize.min,
      //   children: [
      //     Text(
      //       '$itemNumber. ',
      //       style: TextStyle(
      //         color: Colors.grey[400],
      //         fontSize: 14,
      //       ),
      //     ),
      //     SizedBox(width: 8,),
      //     Hero(
      //       tag: id[index],
      //       child: Image.network(
      //         _searchResults2[index],
      //         width: 60, // Adjust width as needed
      //         height: 60, // Adjust height as needed
      //         fit: BoxFit.cover,
      //       ),
      //     ),
      //   ],
      // ),
      //       onTap: () {
      //         Navigator.push(context, CupertinoPageRoute(builder: (context) => PlaySong(
      //           songData: SongData(
      //             id: id[index], 
      //             imageUrl: _searchResults2[index], 
      //             title: _searchResults[index], 
      //             singer: _searchResults3[index], 
      //             market: market[index], 
      //             artistID: artistID[index], 
      //             genre: genre[index]),
      //           )));
      //       },
      //     );
      //   },
                : Center(child: CircularProgressIndicator(color: Colors.greenAccent,),),
            )
            
      

          ],
        ),
      ),
    );
  }
}