import 'package:audio_service/audio_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testz/pages/home.dart';

class RegisterScreen extends StatefulWidget {
  final AudioHandler audioHandler;
  const RegisterScreen({super.key, required this.audioHandler});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  
  String _username = '';
  String _email = '';
  String _password = '';
  int _age = 0;
  String _country = '';
  bool _showContainer = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _showContainer = true;
      });
    });
  }

  Future<void> register() async {
    final db = await mongo.Db.create('mongodb+srv://tejas:tejas@cluster0.0hu0hq9.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0');
    await db.open();
    final collection = db.collection('users');

    try {

      final user = await  collection.find({
        'email': _email,
      }).toList();

      if (user.length == 0) {
        // Login successful, navigate to next screen or perform other actions
        await collection.insert({
          'username': _username,
          'email': _email,
          'password': _password,
        });
        
          print(user);
          // final SharedPreferences prefs = await SharedPreferences.getInstance();
          // prefs.setString('username', _username);
          // prefs.setString('email', _email);
          Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => HomeScreen(cameras: [], username: _username, email: _email,audioHandler: widget.audioHandler,)));
        
        
        print('Login successful');
        print('User data: $user');
        //Navigator.push(context, CupertinoPageRoute(builder: (context) => HomeScreen(cameras: [])));
      } else {
        // Login failed, display error message
        print('User already exists');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('User already exists'),
          
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
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Stack(
           alignment: Alignment.bottomCenter,
          children: [
            Hero(
              tag: 'test2',
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/singup2.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            AnimatedOpacity(
              opacity: _showContainer ? 1.0 : 0.0,
              duration: Duration(milliseconds: 500),
              child: Container(
                  padding: EdgeInsets.all(30.0),
                  
                  width: double.infinity,
                  height: 480,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                     
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text("Sign Up", style: TextStyle(fontSize: 30,color: Colors.blueAccent, 
                        fontFamily: GoogleFonts.poppins().fontFamily, fontWeight: FontWeight.bold), textAlign: TextAlign.start,),
                        
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Username', focusColor: Colors.white, 
                          prefixIcon: Icon(Icons.person, color: Colors.blueAccent,), border: OutlineInputBorder()),
                          
                          onChanged: (value) {
                            setState(() {
                              _username = value;
                            });
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Email',
                          focusColor: Colors.white,prefixIcon: Icon(Icons.email, color: Colors.blueAccent,), border: OutlineInputBorder()),
                          
                          onChanged: (value) {
                            setState(() {
                              _email = value;
                            });
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Password'
                          ,prefixIcon: Icon(Icons.lock, color: Colors.blueAccent,), suffixIcon: Icon(Icons.visibility), border: OutlineInputBorder()),
                          obscureText: true,
                          
                          onChanged: (value) {
                            setState(() {
                              _password = value;
                            });
                          },
                        ),
                      
                          
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                             
                                FocusScope.of(context).unfocus();
                                register();
                              
                            },
                            child: Text('Sign Up'
                            , style: TextStyle(
                                fontFamily: GoogleFonts.poppins().fontFamily,
                              ),),
                          ),
                        
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