import 'package:shared_preferences/shared_preferences.dart';
import 'package:testz/pages/auth.dart';
import 'package:testz/pages/camera.dart';
import 'package:testz/pages/home.dart';
import 'package:testz/pages/login.dart';
import 'package:testz/pages/mongo/mongo.dart';
import 'package:testz/pages/otp.dart';
import 'package:testz/pages/phone.dart';
import 'package:testz/pages/playlist.dart';

import 'package:testz/pages/register.dart';
import 'package:testz/pages/song.dart';
import 'package:testz/pages/songData.dart';
import 'package:testz/pages/start.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:testz/pages/testing.dart';
import 'firebase_options.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:testz/pages/AudioPlayerHandler.dart';

late AudioHandler _audioHandler;
void main() async {
 
  WidgetsFlutterBinding.ensureInitialized();
  
  timeDilation = 1;
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [ SystemUiOverlay.top]);
   SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.black, // Change the navigation bar color
    ));

   _audioHandler = await AudioService.init(
    builder: () => MyAudioHandler(),
    config: AudioServiceConfig(
      androidNotificationChannelId: 'com.mycompany.myapp.channel.audio',
      androidNotificationChannelName: 'Music playback',
    ),
  );
 


    var status = await Permission.notification.status;
    if(status.isGranted){
      print("Permission is granted");
    }else if(status.isDenied){
      print("Permission is denied");
      var serviceStatus = await Permission.notification.request();
      var ext = await Permission.manageExternalStorage.request();
    }else if(status.isPermanentlyDenied){
      print("Permission is permanently denied");
    }
    

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);

    //final SharedPreferences prefs = await SharedPreferences.getInstance();

  // String? username = prefs.getString('username');
  // String? email = prefs.getString('email');

  runApp( MaterialApp(
  
    initialRoute: "/home",
    routes: {
      "/login": (context) => LoginScreen(audioHandler: _audioHandler,),
      "/register": (context) => RegisterScreen(audioHandler: _audioHandler,),
      "/auth": (context) => AuthScreen(),
      "/home": (context) => HomeScreen(cameras: [], username: "username!", email: "email!",audioHandler: _audioHandler,),
      
      "/phone": (context) => PhoneScreen(),
      '/otp': (context) => OtpPage(),
      '/play_song': (context) => PlaySong(songData: SongData(id: '', imageUrl: '', title: '', singer: '', artistID: '', genre: [],duration: 0, audioUrl: ''),songList: [],currentIndex: 0,audioHandler: _audioHandler,
      ),
      // '/camera': (context) => Camera(cameras:[],),
      '/playlist': (context) => PlaylistSongz(id: '',imageUrl: '',title: '', audioHandler: _audioHandler,),
      '/testing': (context) => Testing(),
      "/": (context) => StartScreen(cameras: [],audioHandler: _audioHandler,),
    },
  )
  );
}

