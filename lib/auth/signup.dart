import 'package:appnote/Home/homepage.dart';
import 'package:appnote/component/alert.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool _obscureText = true;
  var myusername, mypassword, myemail;

  GlobalKey<FormState> formstate = new GlobalKey<FormState>();
  signUp() async {
    var formdata = formstate.currentState;
    if (formdata!.validate()) {
      formdata.save();
      try {
        showLoading(context);
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: myemail,
          password: mypassword,
        );
        return userCredential;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          Navigator.of(context).pop();
          AwesomeDialog(
            context: context,
            title: "Error",
            body: Text(
              "Password is to weak",
            ),
          )..show();
          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          Navigator.of(context).pop();
          AwesomeDialog(
            context: context,
            title: "Error",
            body: Text(
              "The account already exists for that email.",
            ),
          )..show();
          print('The account already exists for that email.');
        }
      } catch (e) {
        print(e);
      }
    } else {}
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
              SizedBox(height: 50),
              Center(
                child: Image(
                  image: AssetImage(
                    "images/signup.png",
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
                              return "email cant't to be larger than 100 letter ";
                            }
                            if (val.length < 2) {
                              return "email cant't to be less than 2 letter ";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.email),
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
                            myusername = val;
                          },
                          validator: (val) {
                            if (val!.length > 100) {
                              return "username cant't to be larger than 100 letter ";
                            }
                            if (val.length < 2) {
                              return "username cant't to be less than 2 letter ";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.person),
                            hintText: "Username",
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
                            prefixIcon: Icon(
                              Icons.password_outlined,
                            ),
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
                                Text("If you have an account? "),
                                InkWell(
                                    onTap: () {
                                      Navigator.of(context).pushNamed("login");
                                    },
                                    child: Text(
                                      "Log In",
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
                              UserCredential respons = await signUp();
                              print("======================");
                              if (respons != null) {
                                await FirebaseFirestore.instance
                                    .collection("users")
                                    .add({
                                  "username": myusername,
                                  "email": myemail
                                });
                                  Navigator.pushAndRemoveUntil(context,
                                    MaterialPageRoute(
                                  builder: (BuildContext context) {
                                    return Homepage();
                                  },
                                ), (route) => false);
                               
                              } else {
                                print("sing up faild");
                              }
                              print("======================");
                            },
                            child: Text(
                              "Sign Up",
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
