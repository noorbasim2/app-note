import 'package:appnote/Home/homepage.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../component/alert.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _obscureText = true;

  var mypassword, myemail;

  GlobalKey<FormState> formstate = new GlobalKey<FormState>();
  signIn() async {
    var formdata = formstate.currentState;
    if (formdata!.validate()) {
      formdata.save();

      try {
        showLoading(context);
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: myemail,
          password: mypassword,
        );
        return userCredential;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          Navigator.of(context).pop();
          AwesomeDialog(
            context: context,
            title: "Error",
            body: Text(
              "No user found for that email.",
            ),
          )..show();
          print('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          Navigator.of(context).pop();

          AwesomeDialog(
            context: context,
            title: "Error",
            body: Text(
              "Wrong password provided for that user.",
            ),
          )..show();
          print('Wrong password provided for that user.');
        }
      }
    } else {
      print("Not Valid");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.purple[100],
          // appBar: AppBar(),
          // drawer: Drawer(),
          body: ListView(
            children: [
              // Center(child: Image(image: AssetImage("images/21.jpg"))),
              // SizedBox(height: 50),
              SizedBox(height: 50),
              Center(
                child: Image(
                  image: AssetImage(
                    "images/login.png",
                  ),
                  width: 210,
                  height: 220,
                  fit: BoxFit.fill,
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: Form(
                    key: formstate,
                    child: Column(
                      children: [
                        TextFormField(
                          onSaved: (val) {
                            myemail = val;
                          },
                          validator: (val) {
                            if (val!.length > 100) {
                              return "email can't to be larger than 100 letter ";
                            }
                            if (val.length < 2) {
                              return "email can't to be less than 2 letter ";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.person),
                            hintText: "Email",
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 4,
                              ),
                            ),
                          ),
                        ),
                        //===========================
                        SizedBox(height: 15),
                        //===========================
                        TextFormField(
                          onSaved: (val) {
                            mypassword = val;
                          },
                          validator: (val) {
                            if (val!.length > 100) {
                              return "Password can't to be larger than 100 letter ";
                            }
                            if (val.length < 4) {
                              return "Password can't to be less than 4 letter ";
                            }
                            return null;
                          },
                          obscureText: _obscureText,
                          decoration: InputDecoration(
                            suffixIcon: GestureDetector(
                              onTap: (() {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              }),
                              child: Icon(_obscureText
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                            ),
                            prefixIcon: Icon(Icons.password_outlined),
                            hintText: "Password",
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 1,
                              ),
                            ),
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.all(10),
                            child: Row(
                              children: [
                                Text("Don't have an Account? "),
                                InkWell(
                                    onTap: () {
                                      Navigator.of(context)
                                          .pushReplacementNamed("signup");
                                    },
                                    child: Text(
                                      "Sign Up",
                                      style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 0, 140, 255)),
                                    )),
                              ],
                            )),
                        Container(
                          child: RaisedButton(
                            color: Colors.purple,
                            textColor: Colors.white,
                            onPressed: () async {
                              var user = await signIn();
                              if (user != null) {
                                Navigator.pushAndRemoveUntil(context,
                                    MaterialPageRoute(
                                  builder: (BuildContext context) {
                                    return Homepage();
                                  },
                                ), (route) => false);
                              }
                            },
                            child: Text(
                              "Log In",
                              // style: TextStyle(fontSize: 19),
                              style: Theme.of(context).textTheme.headline6,
                            ),
                          ),
                        )
                      ],
                    )),
              )
            ],
          )),
    );
  }
}
