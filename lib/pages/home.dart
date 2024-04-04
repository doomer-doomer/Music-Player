import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testz/pages/camera.dart';
import 'package:testz/pages/homepage/home.dart';
import 'package:testz/pages/homepage/library.dart';
import 'package:testz/pages/homepage/search.dart';
import 'package:camera/camera.dart';

class Song {
  final String title;
  final String singer;
  final String imageUrl;

  Song({required this.title, required this.singer, required this.imageUrl});
}

class HorizontalSongList extends StatelessWidget {
  final List<Song> songs = [
    Song(
      title: 'Song 1',
      singer: 'Singer 1',
      imageUrl: 'assets/main1.png',
    ),
    Song(
      title: 'Song 2',
      singer: 'Singer 2',
      imageUrl: 'assets/main2.png',
    ),
    Song(
      title: 'Song 3',
      singer: 'Singer 3',
      imageUrl: 'assets/main3.png',
    ),
    Song(
      title: 'Song 4',
      singer: 'Singer 4',
      imageUrl: 'assets/main4.png',
    ),
    Song(
      title: 'Song 5',
      singer: 'Singer 5',
      imageUrl: 'assets/singup2.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: songs.map((song) {
            return SongCard(
              song: song,
            );
          }).toList(),
        ),
      ),
    );
  }
}

class SongCard extends StatelessWidget {
  final Song song;

  const SongCard({required this.song});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Container(
        width: 200,
        
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                image: DecorationImage(
                  image: AssetImage(song.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  song.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                Icon(Icons.more_vert),
              ],
            ),
           
            SizedBox(height: 4.0),
            Text(
              song.singer,
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 8.0),
            ElevatedButton.icon(
              onPressed: () {
                // Add play button functionality here
              },
              icon: Icon(Icons.play_arrow),
              label: Text('Play'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final List<CameraDescription> cameras;
   String username;
   String email;
   final AudioHandler audioHandler;
   HomeScreen({super.key, 
   required this.cameras, 
   required this.username, 
   required this.email,
   required this.audioHandler
   });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentPageIndex = 0;
 late List<Widget> _widgetOptions;

  @override
  void initState() {
    // TODO: implement initState
   _widgetOptions = <Widget>[
  
  NewHome(username: widget.username, email: widget.email, audioHandler: widget.audioHandler,),
   SearchScreen(audioHandler: widget.audioHandler,),
    Lib()
  ];
    super.initState();
  }

    

  void _onItemTapped(int index) {
    setState(() {
      currentPageIndex = index;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        backgroundColor: Colors.black,
        child: ListView(
          children: [
            DrawerHeader(
              curve: Curves.easeInCubic,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage('https://i.scdn.co/image/ab67706f000000034691f7100f5f2cf40d0b3cc9'),
                  ),
                  SizedBox(height: 10),
                  Text('User',style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold,fontFamily: GoogleFonts.poppins().fontFamily),)
                ],
              ),
            ),
            ListTile(
              title: Text('Home',style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold,fontFamily: GoogleFonts.poppins().fontFamily),),
              onTap: (){},
            ),
            ListTile(
              title: Text('Search',style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold,fontFamily: GoogleFonts.poppins().fontFamily),),
              onTap: (){
               
              },
            ),
            ListTile(
              title: Text('Library',style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold,fontFamily: GoogleFonts.poppins().fontFamily),),
              onTap: (){},
            ),
            ListTile(
              title: Text('Settings',style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold,fontFamily: GoogleFonts.poppins().fontFamily),),
              onTap: (){},
            ),
          ],
        ),
      ),
      body: _widgetOptions.elementAt(currentPageIndex),
     
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentPageIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, fontFamily: GoogleFonts.poppins().fontFamily),
        unselectedLabelStyle: TextStyle( fontSize: 12, fontFamily: GoogleFonts.poppins().fontFamily),
        backgroundColor: Colors.black,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            backgroundColor: Colors.black,
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            backgroundColor: Colors.black,
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_music),
            backgroundColor: Colors.black,
            label: 'Library',
          ),
        ],
      ),
      
    );
  }
}

