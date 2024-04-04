import 'package:audio_service/audio_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testz/pages/home.dart';
import 'dart:core';

class LoginScreen extends StatefulWidget {
  final AudioHandler audioHandler;
  const LoginScreen({super.key, required this.audioHandler});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _showContainer = false;
  String _email = '';
  String _password = '';
 

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _showContainer = true;
      });
    });
  }

  Future<void> login() async {
    final db = await mongo.Db.create('mongodb+srv://tejas:tejas@cluster0.0hu0hq9.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0');
    await db.open();
    final collection = db.collection('users');

    try {

      final user = await  collection.find({
        'email': _email,
      }).toList();

      if (user != null) {
        // Login successful, navigate to next screen or perform other actions
        if(user.first['password'] == _password){
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('username', user.first['username']);
          prefs.setString('email', user.first['email']);
          
          Navigator.push(context, CupertinoPageRoute(builder: (context) => HomeScreen(cameras: [], username: user.first['username'], email: user.first['email'], audioHandler:widget.audioHandler,)));
        }
        else{
          print('Invalid username or password');
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Invalid username or password'),
          ));
        }
        
        print('Login successful');
        print('User data: $user');
        //Navigator.push(context, CupertinoPageRoute(builder: (context) => HomeScreen(cameras: [])));
      } else {
        // Login failed, display error message
        print('Invalid username or password');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Invalid username or password'),
          
        ));
      }
    } catch (e) {
      // Error occurred, display error message
      print('Error during login: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('An error occurred during login'),
      ));
    } finally {
      await db.close();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Stack(
         alignment: Alignment.bottomCenter,
          children: [
            Hero(
              tag: 'test',
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/main4.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
        
             AnimatedOpacity(
              opacity: _showContainer ? 1.0 : 0.0,
              duration: Duration(milliseconds: 500),
              
                
                 child: Container(
                  width: double.infinity,
                  height: 450,
                    padding: EdgeInsets.all(30.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                   child: Column(
                    
                             mainAxisAlignment: MainAxisAlignment.end,
                             crossAxisAlignment: CrossAxisAlignment.stretch,
                             children: [
                              Text("Sign In", style: TextStyle(fontSize: 30,color: Colors.blueAccent, 
                              fontWeight: FontWeight.bold, fontFamily: GoogleFonts.poppins().fontFamily), textAlign: TextAlign.start,),
                              SizedBox(height: 30.0,),
                    TextField(
                      
                      decoration: InputDecoration(
                        
                        labelText: 'Email',
                        focusColor: Colors.white,
                        prefixIcon: Icon(Icons.email, color: Colors.blueAccent,),
                        border: OutlineInputBorder(),
                      ),
                      onChanged: 
                      (value) {
                        setState(() {
                          _email = value;
                        });
                      },
                    ),
                    SizedBox(height: 20.0),
                    TextField(
                      obscureText: true,
                      
                      decoration: InputDecoration(
                      
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock, color: Colors.blueAccent,),
                        suffixIcon: Icon(Icons.visibility),
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _password = value;
                        });
                      },
                    ),
                    SizedBox(height: 40.0),
                    ElevatedButton(
                      
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        login();
                      },
                      child: Text('Login', style: TextStyle(
                                fontFamily: GoogleFonts.poppins().fontFamily,
                              ),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        
                        
                        foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)
                                ),
                      ),
                    ),
                    
                    TextButton(
                      style: TextButton.styleFrom(
                        alignment: Alignment.centerLeft,
                        foregroundColor: Colors.black
                      ),
                      child: Text('Forgot Password?', style: TextStyle(
                                fontFamily: GoogleFonts.poppins().fontFamily,
                              ),textAlign: TextAlign.start,),
                      onPressed: () {
                      
                      }
               
                    )
                             ],
                           ),
                 ),
               ),
             
          
          ]
        ),
      ),
    );
  }
}