import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get_done/services/user/auth.dart';
import 'package:get_done/services/others/internet.dart';
import 'package:overlay_support/overlay_support.dart';

// ignore: use_key_in_widget_constructors
class ChangePasswordPage extends StatefulWidget {
  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final formKey2 = GlobalKey<FormState>();

  String _email = "";

  TextEditingController emailController = TextEditingController();

  final FirebaseAuth auth = FirebaseAuth.instance;

  void validateAndSave() {
    final form = formKey2.currentState;
    if (form!.validate()) {
      form.save();
      // ignore: avoid_print

    } else {
      showSimpleNotification(
        Text("Invalid Details"),
      );
    }
  }

  Future<void> sendPassResetLink() async {
    try {
      if (formKey2.currentState!.validate()) {
        auth.sendPasswordResetEmail(email: _email).whenComplete(() {
          showSimpleNotification(
              Text(
                "DONE ! PASSWORD RESET EMAIL HAS BEEN SENT \n TO USER EMAIL ",
                textAlign: TextAlign.center,
                style: GoogleFonts.sourceSansPro(
                    color: Colors.white, fontSize: 17),
              ),
              background: Colors.greenAccent.withOpacity(0.8),
              duration: Duration(seconds: 2),
              elevation: 0);
        });
      }
    } on FirebaseAuthException catch (e) {
      showSimpleNotification(
        Text(
          e.toString(),
          textAlign: TextAlign.center,
          style: GoogleFonts.sourceSansPro(color: Colors.white, fontSize: 17),
        ),
        duration: Duration(seconds: 2),
        elevation: 0,
        background: Colors.redAccent.withOpacity(0.8),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    GoogleFonts.config;
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    _email;
    formKey2;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SafeArea(
          child: Container(
            margin: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                  height: 100,
                  width: 60,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    color: Theme.of(context).scaffoldBackgroundColor,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.close,
                      size: 20,
                      color: Colors.redAccent,
                    ),
                  ),
                ),
                Container(
                  height: 150,
                  width: double.infinity,
                  color: Colors.transparent,
                  child: Column(
                    children: [
                      Text(
                        "Forgot Password ? ",
                        style: GoogleFonts.lobster(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "Change Password",
                        style: GoogleFonts.pattaya(
                            fontSize: 35,
                            color: Colors.cyanAccent,
                            fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "An Password Reset Link will be Sent"
                        "\n to User Email",
                        style: GoogleFonts.varelaRound(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            fontStyle: FontStyle.italic,
                            color: Colors.white),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Container(
                  width: double.infinity,
                  color: Colors.transparent,
                  child: Form(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    key: formKey2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 10),
                          child: Text(
                            "Email - ",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.pacifico(
                              fontSize: 15,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          style: GoogleFonts.sourceSansPro(
                              letterSpacing: 1,
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                              color: Theme.of(context).iconTheme.color),
                          textDirection: TextDirection.ltr,
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
                          textInputAction: TextInputAction.done,
                          controller: emailController,
                          // ignore: prefer_const_literals_to_create_immutables
                          autofillHints: [AutofillHints.email],
                          keyboardType: TextInputType.emailAddress,
                          onSaved: (value) {
                            _email = value!;
                          },
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).unfocus();
                          },
                          autofocus: false,
                          decoration: InputDecoration(
                            errorStyle: GoogleFonts.sourceSansPro(fontSize: 18),
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
                            contentPadding: const EdgeInsets.only(top: 14.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            hintText: "Enter Email",
                            prefixIcon: const Icon(Icons.email_outlined,
                                color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 17,
                ),
                SizedBox(
                  height: 45,
                  width: 180,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      FocusScope.of(context).unfocus();

                      HapticFeedback.mediumImpact();

                      if (formKey2.currentState!.validate()) {
                        validateAndSave();
                        await isInternet(context).whenComplete(
                          () => sendPassResetLink().whenComplete(() {
                            AuthClass().signOutUser(context);
                          }),
                        );
                      } else if (_email != auth.currentUser!.email) {
                        showSimpleNotification(
                            Text(
                                "Error - Given Email doesn't Match the User from Database"),
                            background: Colors.yellowAccent.withOpacity(0.8),
                            duration: Duration(seconds: 2),
                            elevation: 0);
                      }
                    },
                    icon: const Icon(
                      Icons.mark_email_read_outlined,
                      color: Colors.white,
                      size: 30,
                    ),
                    label: Text(
                      "SUBMIT",
                      style: GoogleFonts.pacifico(
                          fontSize: 20, fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
