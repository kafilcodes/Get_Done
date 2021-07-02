// ignore: file_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get_done/handler/LoginPage.dart';
import 'package:get_done/home/Home.dart';
import 'package:get_done/services/user/auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get_done/services/others/internet.dart';
import 'package:overlay_support/overlay_support.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;

// ignore: use_key_in_widget_constructors
class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage>
    with SingleTickerProviderStateMixin {
  //---------------------declarations-------------------------------------------
  AuthClass authClass = AuthClass();
  TextEditingController password = TextEditingController();
  TextEditingController confirmpassword = TextEditingController();
  String _name = "";
  String _email = "";
  bool showPass = false;
  bool showPass2 = false;
  late Animation<Color?> animation2;
  late AnimationController controller2;
  bool Animate2 = false;

  Future<void> _createUser() async {
    try {
      // ignore:  avoid_print
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _email,
        password: confirmpassword.text,
      );

      User? user = userCredential.user;
      await FirebaseFirestore.instance.collection('users').doc(user!.uid).set(
        {
          "date": FieldValue.serverTimestamp(),
          "name": _name,
          "email": _email,
        },
      );

      const CircularProgressIndicator();
      // ignore: avoid_print

      // ignore: avoid_print

      Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
    } on FirebaseAuthException catch (e) {
      showSimpleNotification(Text(e.toString()),
          background: Colors.yellowAccent.withOpacity(0.8));
      setState(() {
        Animate2 = false;
      });
      // ignore: avoid_print

    } catch (e) {
      setState(() {
        Animate2 = false;
      });
      // ignore: avoid_print

    }
  }
  // ---------------------------------------------------------------------------

// ------------validation-------------------------------------------------------
  final formKey = GlobalKey<FormState>();
  void validateAndSave() {
    final form = formKey.currentState;
    if (form!.validate()) {
      setState(() {
        Animate2 = true;
      });
      form.save();
      // ignore: avoid_print

    } else {
      // ignore: avoid_print
      showSimpleNotification(
        Text("INVALID DETAILS "),
        background: Colors.redAccent,
      );
    }
  }
  //----------------------------------------------------------------------------

  @override
  void initState() {
    super.initState();
    controller2 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    animation2 = controller2.drive(TweenSequence<Color?>([
      TweenSequenceItem(
        weight: 1.0,
        tween: ColorTween(begin: Colors.red, end: Colors.blue),
      ),
      TweenSequenceItem(
        weight: 1.0,
        tween: ColorTween(begin: Colors.blue, end: Colors.green),
      ),
      TweenSequenceItem(
        weight: 1.0,
        tween: ColorTween(begin: Colors.green, end: Colors.yellow),
      ),
      TweenSequenceItem(
        weight: 1.0,
        tween: ColorTween(begin: Colors.yellow, end: Colors.red),
      ),
    ]));
    controller2.repeat();
    // ignore: avoid_print
  }

  @override
  void dispose() {
    password.dispose();
    confirmpassword.dispose();
    controller2.dispose();
    super.dispose();
  }

  //----------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    //---------------------------gestureLink------------------------------------
    final TapGestureRecognizer _gestureRecognizer = TapGestureRecognizer()
      ..onTap = () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => LoginPage(),
          ),
        );
      };
    //--------------------------------------------------------------------------

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(10.0),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded,
                color: Colors.white60, size: 28),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: SafeArea(
            child: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // ignore: avoid_unnecessary_containers
                  Container(
                    child: Column(
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        const Icon(
                          Icons.person_pin_rounded,
                          color: Colors.cyanAccent,
                          size: 200,
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 40, vertical: 7),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Full Name",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              cursorColor: Colors.cyanAccent,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                              textDirection: TextDirection.ltr,
                              onChanged: (value) {
                                _name = value;
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please Enter Name';
                                }
                                return null;
                              },
                              onFieldSubmitted: (_) =>
                                  FocusScope.of(context).nextFocus(),
                              textInputAction: TextInputAction.next,
                              // ignore: prefer_const_literals_to_create_immutables
                              autofillHints: [AutofillHints.newUsername],
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(
                                    color: Color(Colors.white.value),
                                  ),
                                ),
                                contentPadding:
                                    const EdgeInsets.only(top: 14.0),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(Colors.white.value),
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(Colors.cyanAccent.value),
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                hintText: "Enter Name",
                                hintStyle: const TextStyle(
                                    color: Colors.white54,
                                    fontSize: 15,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.normal),
                                prefixIcon: const Icon(Icons.person_outline,
                                    color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Email",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              cursorColor: Colors.cyanAccent,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                              textDirection: TextDirection.ltr,
                              onChanged: (value) {
                                _email = value;
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please Enter Email";
                                }
                                if (!RegExp(
                                        "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                                    .hasMatch(value)) {
                                  return 'Please Enter a Valid Email';
                                }
                                return null;
                              },
                              onFieldSubmitted: (_) =>
                                  FocusScope.of(context).nextFocus(),
                              textInputAction: TextInputAction.next,
                              // ignore: prefer_const_literals_to_create_immutables
                              autofillHints: [AutofillHints.email],
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(Colors.cyanAccent.value),
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(
                                    color: Color(Colors.white.value),
                                  ),
                                ),
                                contentPadding:
                                    const EdgeInsets.only(top: 14.0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                hintText: "Enter Email",
                                hintStyle: const TextStyle(
                                    color: Colors.white54,
                                    fontSize: 15,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.normal),
                                prefixIcon: const Icon(Icons.email_outlined,
                                    color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Password",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              cursorColor: Colors.cyanAccent,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                              textDirection: TextDirection.ltr,
                              controller: password,
                              onChanged: (value) {
                                password = value as TextEditingController;
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please a Enter Password';
                                }
                                return null;
                              },
                              onFieldSubmitted: (_) =>
                                  FocusScope.of(context).nextFocus(),
                              textInputAction: TextInputAction.next,
                              // ignore: prefer_const_literals_to_create_immutables
                              autofillHints: [AutofillHints.newPassword],
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: showPass,
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(Colors.cyanAccent.value),
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(
                                    color: Color(Colors.white.value),
                                  ),
                                ),
                                contentPadding:
                                    const EdgeInsets.only(top: 14.0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                hintText: "Enter Password",
                                hintStyle: const TextStyle(
                                    color: Colors.white54,
                                    fontSize: 15,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.normal),
                                prefixIcon: const Icon(
                                    Icons.lock_outline_rounded,
                                    color: Colors.white),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    Icons.remove_red_eye,
                                    color: showPass ? Colors.grey : Colors.blue,
                                    size: 22,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      showPass = !showPass;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ignore: prefer_const_constructors
                            const Text(
                              "Confirm Password",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              cursorColor: Colors.cyanAccent,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                              textDirection: TextDirection.ltr,
                              controller: confirmpassword,
                              onChanged: (value) {
                                confirmpassword =
                                    value as TextEditingController;
                              },
                              onFieldSubmitted: (_) =>
                                  FocusScope.of(context).nextFocus(),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please re-enter password';
                                }
                                // ignore: avoid_print
                                print(password.text);

                                // ignore: avoid_print
                                print(confirmpassword.text);

                                if (password.text != confirmpassword.text) {
                                  return "Password does not match";
                                }

                                return null;
                              },
                              textInputAction: TextInputAction.done,
                              // ignore: prefer_const_literals_to_create_immutables
                              autofillHints: [AutofillHints.newPassword],
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: showPass2,
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(Colors.cyanAccent.value),
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(
                                    color: Color(Colors.white.value),
                                  ),
                                ),
                                contentPadding:
                                    const EdgeInsets.only(top: 14.0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                hintText: "Please Re-Enter Password",
                                hintStyle: const TextStyle(
                                    color: Colors.white54,
                                    fontSize: 15,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.normal),
                                prefixIcon: const Icon(
                                    Icons.lock_outline_rounded,
                                    color: Colors.white),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    Icons.remove_red_eye,
                                    color:
                                        showPass2 ? Colors.grey : Colors.blue,
                                    size: 22,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      showPass2 = !showPass2;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Container(
                          margin: const EdgeInsets.all(10),
                          width: 300,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.cyanAccent,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: OutlinedButton(
                            style: const ButtonStyle(),
                            onPressed: () async {
                              HapticFeedback.mediumImpact();

                              if (formKey.currentState!.validate()) {
                                validateAndSave();
                                await isInternet(context).whenComplete(
                                  () => _createUser(),
                                );

                                // showSimpleNotification(
                                //   Text("Done"),
                                //   background: Colors.greenAccent,

                              }
                            },
                            child: Text(
                              " Register ",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.sourceSansPro(
                                color: Colors.white,
                                fontSize: 20,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Animate2
                            ? SizedBox(
                                width: 200,
                                height: 5,
                                child: LinearProgressIndicator(
                                  backgroundColor: Colors.black26,
                                  valueColor: animation2,
                                ),
                              )
                            : Container(),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 20),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  setState(() {
                                    Animate2 = true;
                                  });
                                  await authClass.googleSignIn(context);
                                },
                                child: Container(
                                  width: 70,
                                  height: 50,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      alignment: Alignment.center,
                                      fit: BoxFit.contain,
                                      scale: 1,
                                      image: AssetImage(
                                          "assets/images/google.png"),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        RichText(
                          text: TextSpan(
                            text: "Already Have an Account ?  ",
                            style: const TextStyle(
                              color: Colors.white54,
                              fontStyle: FontStyle.italic,
                            ),
                            children: [
                              TextSpan(
                                  text: "Sign In ",
                                  style: const TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                  recognizer: _gestureRecognizer),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
