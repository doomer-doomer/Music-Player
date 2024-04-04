// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:spotify/spotify.dart' as music;
// import 'package:testz/pages/song.dart';

// class PlaylistSongs {
//   final String id;
//   final String title;
//   final String singer;
//   final String imageUrl;


//   PlaylistSongs({required this.id,required this.title, required this.singer, required this.imageUrl});
// }


// class PlaySongCard extends StatelessWidget {
//   final PlaylistSongs song;

//   const PlaySongCard({required this.song});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.all(8.0),
      
//       child: GestureDetector(
//         onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context)=> PlaySong(
//           id: song.id, 
//           imageUrl: song.imageUrl, 
//           title: song.title,
//           singer: song.singer,
          
          
//           ))),
//         child: ListView.builder(
//         itemCount: 30,
//         itemBuilder: (context, index) {
//           return ListTile(
//             contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
//             horizontalTitleGap: 15,
//             title: Text(song.title, style: TextStyle(fontSize: 14
//             , fontWeight: FontWeight.bold, color: Colors.black,
//             fontFamily: GoogleFonts.poppins().fontFamily,
//             )),
//             subtitle: Text(song.singer, style: TextStyle(fontSize: 12)),
            
//             leading: Hero(
//               tag: song.id,
//               child: Image.network(
//                 song.imageUrl,
//                width: 60, // Adjust width as needed
//                         height: 60, // Adjust height as needed
//                         fit: BoxFit.cover,),
//             ),
//             onTap: () {
//               Navigator.push(context, MaterialPageRoute(builder: (context) => PlaySong(id: song.id,imageUrl: song.imageUrl,title: song.title,singer: song.singer,)));
//             },
//           );
//         },
//       ),
//       ),
//     );
//   }
// }


// class PlaylistSong extends StatefulWidget {
//    final String query;
//   const PlaylistSong({super.key, required this.query});

//   @override
//   State<PlaylistSong> createState() => _PlaylistSongState();
// }

// class _PlaylistSongState extends State<PlaylistSong> {
//   late List<PlaylistSongs> songs;
//   late music.SpotifyApi spotify;
//  bool isLoading = true;

 
//   @override
//   void initState() {
//     super.initState();
//     songs = [];
//     // Initialize SpotifyApi
//     var cred = music.SpotifyApiCredentials('f1f95fae275c456d9b2bc95c4572501f', 'ad248e1a723f4b87b9b7f8de339aaff2');
//     spotify = music.SpotifyApi(cred);
//     // Fetch songs
//     _fetchSongs();
//   }

//   Future<void> _fetchSongs() async {
//     try {
//       var search = await spotify.search.get(widget.query).first(15);

//       setState(() {
//         songs.clear(); // Clear the songs list before adding new songs

//         search.forEach((pages) {
//           if (pages.items == null) {
//             print('Empty items');
//           }
//           pages.items!.forEach((item) {
//             if (item is music.Track) {
//               // Add PlaylistSimple items to the songs list
//               songs.add(PlaylistSongs(
//                 id: item.id!,
//                 title: item.name!,
//                 singer: item.artists!.isNotEmpty ? item.artists!.first.name! : 'Unknown Artist',
//                 imageUrl: item.album!.images!.isNotEmpty ? item.album!.images!.first.url! : '',
               
//               ));
//             }
//             // Add similar blocks for other types like Artist, Track, AlbumSimple if needed
//           });
//   isLoading = false;
//         });
      
//       });
      
//     } catch (e) {
//       print('Error fetching songs: $e');
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         SingleChildScrollView(
//         scrollDirection: Axis.vertical,
//         child: Column(
//           children: songs.map((song) {
//             return PlaySongCard(
//               song: song,
//             );
//           }).toList(),
//         ),
//         ),
//         if (isLoading)
//             Container(
//               // Semi-transparent black background
//               child: Center(
                
//                 child: CircularProgressIndicator(
//                   color: Colors.green,
//                 ), // Loading indicator in the center
//               ),
//             ),
      
    
//     ]);
//   }
// }