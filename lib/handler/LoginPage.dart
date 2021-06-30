import 'package:google_fonts/google_fonts.dart';
import 'package:get_done/handler/SignupPage.dart';

import 'package:get_done/services/user/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get_done/services/user/changePassword.dart';
import 'package:get_done/services/others/internet.dart';
import 'package:overlay_support/overlay_support.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  //------------------------------------------------------------------

  bool showPass = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String _error = "";
  String _email = "";
  String _password = "";
  AuthClass authClass = AuthClass();
  bool loading = false;
  final formKey = GlobalKey<FormState>();
  late Animation<Color?> animation;
  late AnimationController controller;
  bool Animate = false;

  // -------------login ------------------------------------------------------------------------

  Future<void> _loginUser() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: _email, password: _password);

      if (formKey.currentState!.validate()) {
        if (userCredential.user != null) {
          setState(() {
            Animate = true;
          });
        }
        if (userCredential.user == null) {
          setState(() {
            Animate = false;
            final snackbar = SnackBar(
                backgroundColor: Colors.yellowAccent.withOpacity(0.8),
                width: double.infinity,
                duration: Duration(seconds: 2),
                content: const Text("Please Enter Valid Details"));
            ScaffoldMessenger.of(context).showSnackBar(snackbar);
            loading = false;
          });
        }
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        Animate = false;
        _error = e.message!;
        final snackbarError = SnackBar(
          width: double.infinity,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(12),
            ),
          ),
          margin: const EdgeInsets.all(22),
          padding: const EdgeInsets.all(5),
          elevation: 0,
          content: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.yellow,
                  size: 20,
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  _error,
                  maxLines: 3,
                  style: GoogleFonts.sourceSansPro(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          backgroundColor: Colors.redAccent.withOpacity(0.7),
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackbarError);
      });
    } catch (e) {
      setState(() {
        Animate = false;
      });
    }
  }

  //--------------------------------login---------------------------------------

  void validateAndSave() {
    final form = formKey.currentState;
    if (form!.validate()) {
      setState(() {
        Animate = true;
      });
      form.save();
    } else {
      showSimpleNotification(
        Text("Invalid Details , Check and Try Again"),
      );
    }
  }

  @override
  void initState() {
    super.initState();

    GoogleFonts.config;

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    animation = controller.drive(TweenSequence<Color?>([
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
    controller.repeat();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    controller.dispose();
    Animate;
    animation;
    showPass;
    _error;
    _email;
    _password;
    loading;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TapGestureRecognizer _gestureRecognizer = TapGestureRecognizer()
      ..onTap = () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => SignUpPage(),
          ),
        );
      };

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.black26,
      body: Center(
        child: SingleChildScrollView(
          child: SafeArea(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Text(
                      "Welcome Back",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.sourceSansPro(
                        letterSpacing: 1.1,
                        color: Colors.white,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w800,
                        fontSize: 32,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 7),
                    child: Text(
                      "Sign with your email and password \n    or continue with Google Sign In. ",
                      style: GoogleFonts.sourceSansPro(
                        color: Colors.white70,
                        fontStyle: FontStyle.italic,
                        letterSpacing: 1.5,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 50, vertical: 7),
                    color: Colors.transparent,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Email",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.sourceSansPro(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              cursorColor: Colors.cyanAccent,
                              textDirection: TextDirection.ltr,
                              style: GoogleFonts.sourceSansPro(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                              enableInteractiveSelection: true,
                              enableSuggestions: true,
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
                              textInputAction: TextInputAction.next,
                              controller: emailController,
                              autofillHints: [AutofillHints.email],
                              keyboardType: TextInputType.emailAddress,
                              onSaved: (value) {
                                _email = value!;
                              },
                              onFieldSubmitted: (_) =>
                                  FocusScope.of(context).nextFocus(),
                              onChanged: (value) {
                                _email = value;
                              },
                              autofocus: false,
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(Colors.white.value),
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(Colors.red.value),
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(Colors.red.value),
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(Colors.cyanAccent.value),
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                contentPadding:
                                    const EdgeInsets.only(top: 14.0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                hintText: "Enter Email",
                                hintStyle: GoogleFonts.sourceSansPro(
                                    color: Colors.white54,
                                    fontSize: 17,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.normal),
                                prefixIcon: const Icon(Icons.email_outlined,
                                    color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Password",
                              style: GoogleFonts.sourceSansPro(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              cursorColor: Colors.cyanAccent,
                              textDirection: TextDirection.ltr,
                              style: GoogleFonts.sourceSansPro(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                              validator: (value) => value!.isEmpty
                                  ? "Password can't be empty"
                                  : null,
                              onSaved: (value) {
                                _password = value!;
                              },
                              textInputAction: TextInputAction.done,
                              autofocus: false,
                              autofillHints: [AutofillHints.password],
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: showPass,
                              onChanged: (value) {
                                _password = value;
                              },
                              decoration: InputDecoration(
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(Colors.red.value),
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(Colors.red.value),
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                focusColor: Colors.cyanAccent,
                                enabledBorder: OutlineInputBorder(
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
                                contentPadding:
                                    const EdgeInsets.only(top: 14.0),
                                hintText: "Enter Password",
                                hintStyle: GoogleFonts.sourceSansPro(
                                  color: Colors.white54,
                                  fontSize: 17,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.normal,
                                ),
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
                                prefixIcon: const Icon(
                                    Icons.lock_outline_rounded,
                                    color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        Container(
                          width: 200,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.cyanAccent.withOpacity(1),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: OutlinedButton(
                            onPressed: () async {
                              FocusScope.of(context).unfocus();
                              HapticFeedback.mediumImpact();
                              await isInternet(context);
                              validateAndSave();
                              if (formKey.currentState!.validate()) {
                                _loginUser().whenComplete(
                                  () => ScaffoldMessenger.of(context)
                                      .hideCurrentSnackBar(),
                                );
                              }
                            },
                            child: Text(
                              "Sign In  ",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.sourceSansPro(
                                color: Colors.white,
                                fontSize: 20,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Container(
                          alignment: Alignment.centerRight,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ChangePasswordPage()));
                            },
                            child: Text("Forgot Password ?",
                                style: GoogleFonts.sourceSansPro(
                                    color: Theme.of(context).backgroundColor),
                                textAlign: TextAlign.end),
                          ),
                        ),
                        const SizedBox(height: 60),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 20),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  Animate = true;
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
                            text: "Don't have an Account ?  ",
                            style: GoogleFonts.sourceSansPro(
                              color: Colors.white54,
                              fontStyle: FontStyle.italic,
                            ),
                            children: [
                              TextSpan(
                                  text: "Sign Up",
                                  style: GoogleFonts.sourceSansPro(
                                    fontStyle: FontStyle.italic,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                  recognizer: _gestureRecognizer),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Animate
                            ? SizedBox(
                                width: 200,
                                height: 10,
                                child: LinearProgressIndicator(
                                  backgroundColor: Colors.black26,
                                  valueColor: animation,
                                ),
                              )
                            : Container(),
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
