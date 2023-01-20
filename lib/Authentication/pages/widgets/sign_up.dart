import 'dart:io';
import 'package:budgetbuddy/Authentication/Authenticator.dart';
import 'package:budgetbuddy/Authentication/theme.dart';
import 'package:budgetbuddy/Authentication/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final FocusNode focusNodePassword = FocusNode();
  final FocusNode focusNodeConfirmPassword = FocusNode();
  final FocusNode focusNodeEmail = FocusNode();
  final FocusNode focusNodeName = FocusNode();

  bool _obscureTextPassword = true;
  bool _obscureTextConfirmPassword = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late String signupEmail;
  late String signupName;
  late String signupPassword;
  late String signupConfirmPassword;
  File _imageFile = File('assets/images/placeholder.jpg');

  DecorationImage _image = const DecorationImage(
    image: AssetImage('assets/images/placeholder.jpg'),
    fit: BoxFit.cover,
  );

  @override
  void dispose() {
    focusNodePassword.dispose();
    focusNodeConfirmPassword.dispose();
    focusNodeEmail.dispose();
    focusNodeName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        padding: const EdgeInsets.only(top: 23.0),
        child: Column(
          children: <Widget>[
            Stack(
              alignment: Alignment.topCenter,
              children: <Widget>[
                Card(
                  elevation: 2.0,
                  color: const Color(0xFF4A5859).withOpacity(0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: SizedBox(
                    width: 300.0,
                    height: 360.0,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 10.0, bottom: 10.0, left: 25.0, right: 25.0),
                          child: // selecet profile image from device files
                              Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 50.0,
                                height: 50.0,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle, image: _image),
                              ),
                              InkWell(
                                onTap: () async {
                                  await ImagePicker()
                                      .pickImage(source: ImageSource.gallery)
                                      .then(
                                    (value) {
                                      if (value != null) {
                                        setState(() {
                                          _imageFile = File(value.path);
                                          _image = DecorationImage(
                                            image: FileImage(_imageFile),
                                            fit: BoxFit.cover,
                                          );
                                        });
                                      }
                                    },
                                  );
                                },
                                child: Container(
                                  height: 50.0,
                                  width: 50.0,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.transparent,
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt,
                                    color: Color(0xFF4A5859),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 250.0,
                          height: 2.0,
                          color: Colors.grey[400],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 10.0, bottom: 10.0, left: 25.0, right: 25.0),
                          child: TextFormField(
                            focusNode: focusNodeName,
                            keyboardType: TextInputType.text,
                            textCapitalization: TextCapitalization.words,
                            autocorrect: false,
                            style: const TextStyle(
                                fontFamily: 'WorkSansSemiBold',
                                fontSize: 16.0,
                                color: Colors.white),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(
                                FontAwesomeIcons.user,
                                color: Color(0xFF4A5859),
                              ),
                              hintText: 'Name',
                              hintStyle: TextStyle(
                                  fontFamily: 'WorkSansSemiBold',
                                  fontSize: 16.0),
                            ),
                            validator: (String? input) {
                              if (input!.isEmpty) {
                                CustomSnackBar(
                                    context, const Text('Name is required'),
                                    backgroundColor: Colors.redAccent);
                              }
                            },
                            onSaved: (String? input) =>
                                signupName = input.toString(),
                            onFieldSubmitted: (_) {
                              focusNodeEmail.requestFocus();
                            },
                          ),
                        ),
                        Container(
                          width: 250.0,
                          height: 1.0,
                          color: Colors.grey[400],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 10.0, bottom: 10.0, left: 25.0, right: 25.0),
                          child: TextFormField(
                            focusNode: focusNodeEmail,
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            style: const TextStyle(
                                fontFamily: 'WorkSansSemiBold',
                                fontSize: 16.0,
                                color: Colors.white),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(
                                FontAwesomeIcons.envelope,
                                color: Color(0xFF4A5859),
                              ),
                              hintText: 'Email Address',
                              hintStyle: TextStyle(
                                  fontFamily: 'WorkSansSemiBold',
                                  fontSize: 16.0),
                            ),
                            validator: (String? input) {
                              if (input!.isEmpty) {
                                CustomSnackBar(
                                    context, const Text('Email is required'),
                                    backgroundColor: Colors.redAccent);
                              }
                              if (!RegExp(
                                      r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                                  .hasMatch(input)) {
                                CustomSnackBar(context,
                                    const Text('Invalid Email Address'),
                                    backgroundColor: Colors.redAccent);
                              }
                            },
                            onSaved: (String? input) =>
                                signupEmail = input.toString(),
                            onFieldSubmitted: (_) {
                              focusNodePassword.requestFocus();
                            },
                          ),
                        ),
                        Container(
                          width: 250.0,
                          height: 2.0,
                          color: Colors.grey[400],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 10.0, bottom: 10.0, left: 25.0, right: 25.0),
                          child: TextFormField(
                            validator: (String? input) {
                              if (input!.isEmpty) {
                                CustomSnackBar(
                                    context, const Text('Password is Required'),
                                    backgroundColor: Colors.redAccent);
                              }
                              if (input.length < 6) {
                                CustomSnackBar(
                                    context,
                                    const Text(
                                        'Password must be at least 6 character'),
                                    backgroundColor: Colors.redAccent);
                              }
                              signupPassword = input.toString();
                            },
                            focusNode: focusNodePassword,
                            obscureText: _obscureTextPassword,
                            autocorrect: false,
                            style: const TextStyle(
                                fontFamily: 'WorkSansSemiBold',
                                fontSize: 16.0,
                                color: Colors.white),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: const Icon(
                                FontAwesomeIcons.lock,
                                color: Color(0xFF4A5859),
                              ),
                              hintText: 'Password',
                              hintStyle: const TextStyle(
                                  fontFamily: 'WorkSansSemiBold',
                                  fontSize: 16.0),
                              suffixIcon: GestureDetector(
                                onTap: _toggleSignup,
                                child: Icon(
                                  _obscureTextPassword
                                      ? FontAwesomeIcons.eye
                                      : FontAwesomeIcons.eyeSlash,
                                  size: 15.0,
                                  color: const Color(0xFF4A5859),
                                ),
                              ),
                            ),
                            onSaved: (String? input) =>
                                signupPassword = input.toString(),
                            onFieldSubmitted: (_) {
                              focusNodeConfirmPassword.requestFocus();
                            },
                          ),
                        ),
                        Container(
                          width: 250.0,
                          height: 2.0,
                          color: Colors.grey[400],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 10.0, bottom: 10.0, left: 25.0, right: 25.0),
                          child: TextFormField(
                            validator: (String? input) {
                              if (input!.isEmpty || input != signupPassword) {
                                CustomSnackBar(context,
                                    const Text('Password does not match'),
                                    backgroundColor: Colors.redAccent);
                              }
                            },
                            focusNode: focusNodeConfirmPassword,
                            obscureText: _obscureTextConfirmPassword,
                            autocorrect: false,
                            style: const TextStyle(
                                fontFamily: 'WorkSansSemiBold',
                                fontSize: 16.0,
                                color: Colors.white),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: const Icon(
                                FontAwesomeIcons.lock,
                                color: Color(0xFF4A5859),
                              ),
                              hintText: 'Confirmation',
                              hintStyle: const TextStyle(
                                  fontFamily: 'WorkSansSemiBold',
                                  fontSize: 16.0),
                              suffixIcon: GestureDetector(
                                onTap: _toggleSignupConfirm,
                                child: Icon(
                                  _obscureTextConfirmPassword
                                      ? FontAwesomeIcons.eye
                                      : FontAwesomeIcons.eyeSlash,
                                  size: 15.0,
                                  color: const Color(0xFF4A5859),
                                ),
                              ),
                            ),
                            onSaved: (String? input) =>
                                signupConfirmPassword = input.toString(),
                            onFieldSubmitted: (_) {
                              _toggleSignUpButton();
                            },
                            textInputAction: TextInputAction.go,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 350.0),
                  decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(5.0)),
                      gradient: LinearGradient(
                          colors: <Color>[
                            const Color(0xFFC83E4D).withOpacity(0.6),
                            const Color(0xFFF4B860).withOpacity(0.5),
                            // Color(0xFF4A5859).withOpacity(0.1),
                          ],
                          begin: const FractionalOffset(0.2, 0.2),
                          end: const FractionalOffset(1.0, 1.0),
                          stops: const <double>[0.0, 1.0],
                          tileMode: TileMode.clamp)),
                  child: MaterialButton(
                    highlightColor: Colors.transparent,
                    splashColor: CustomTheme.loginGradientEnd,
                    //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 42.0),
                      child: Text(
                        'SIGN UP',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 25.0,
                            fontFamily: 'WorkSansBold'),
                      ),
                    ),
                    onPressed: () => _toggleSignUpButton(),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _toggleSignUpButton() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      Authenticate().signUp(
          context: context,
          email: signupEmail,
          password: signupPassword,
          name: signupName,
          pic: _imageFile);
    } else {
      CustomSnackBar(context, const Text('Sign Up Failed'),
          backgroundColor: Colors.red);
    }
  }

  void _toggleSignup() {
    setState(() {
      _obscureTextPassword = !_obscureTextPassword;
    });
  }

  void _toggleSignupConfirm() {
    setState(() {
      _obscureTextConfirmPassword = !_obscureTextConfirmPassword;
    });
  }
}
