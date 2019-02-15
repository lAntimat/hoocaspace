import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hoocaspace/data/datasource/product_datasource.dart';
import 'package:hoocaspace/data/models/user.dart';
import 'package:hoocaspace/other/color_constants.dart';
import 'package:hoocaspace/other/text_style.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();

enum LoginState { EnterPhone, EnterSmsCode }

var currentState = LoginState.EnterPhone;

bool _fabLoading = false;
bool _validate = false;

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Future<String> _message = Future<String>.value('');
  TextEditingController _smsCodeController = TextEditingController();
  TextEditingController _numberPrefix = TextEditingController();
  TextEditingController _number = TextEditingController();
  String verificationId;
  final String testSmsCode = '888888';
  final String testPhoneNumber = '+79600747198';

  Future<String> _testSignInAnonymously() async {
    final FirebaseUser user = await _auth.signInAnonymously();
    assert(user != null);
    assert(user.isAnonymous);
    assert(!user.isEmailVerified);
    assert(await user.getIdToken() != null);
    if (Platform.isIOS) {
      // Anonymous auth doesn't show up as a provider on iOS
      assert(user.providerData.isEmpty);
    } else if (Platform.isAndroid) {
      // Anonymous auth does show up as a provider on Android
      assert(user.providerData.length == 1);
      assert(user.providerData[0].providerId == 'firebase');
      assert(user.providerData[0].uid != null);
      assert(user.providerData[0].displayName == null);
      assert(user.providerData[0].photoUrl == null);
      assert(user.providerData[0].email == null);
    }

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);

    return 'signInAnonymously succeeded: $user';
  }

  Future<String> _testSignInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final FirebaseUser user = await _auth.signInWithCredential(credential);
    assert(user.email != null);
    assert(user.displayName != null);
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);
    ProductDataSource source = new ProductDataSource();

    await source
        .saveUser(new User.withId(
            user.uid, user.displayName, user.photoUrl, user.phoneNumber))
        .then((value) {
      debugPrint('save user success');
    }).catchError((error) {
      debugPrint('save user error ' + error.toString());
    });
    return 'signInWithGoogle succeeded: $user';
  }

  Future<void> _testVerifyPhoneNumber() async {
    String phoneNumber = "";

    setState(() {
      if (_numberPrefix.text != null && _number.text != null) {
        phoneNumber = "+" + _numberPrefix.text + _number.text;
        _validate = true;
        _fabLoading = true;
      } else {
        _validate = false;
        return;
      }
    });

    final PhoneVerificationCompleted verificationCompleted =
        (FirebaseUser user) {
      setState(() {
        _fabLoading = false;
        _message =
            Future<String>.value('signInWithPhoneNumber auto succeeded: $user');
        currentState = LoginState.EnterSmsCode;
      });
    };

    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) {
      setState(() {
        _message = Future<String>.value(
            'Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}');
      });
    };

    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      this.verificationId = verificationId;
      _smsCodeController.text = testSmsCode;
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      this.verificationId = verificationId;
      _smsCodeController.text = testSmsCode;
    };

    await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

  Future<String> _testSignInWithPhoneNumber(String smsCode) async {
    final AuthCredential credential = PhoneAuthProvider.getCredential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    final FirebaseUser user = await _auth.signInWithCredential(credential);
    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);

    _smsCodeController.text = '';
    return 'signInWithPhoneNumber succeeded: $user';
  }

  @override
  void initState() {
    super.initState();
    _numberPrefix.text = "7";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Авторизация"),
        automaticallyImplyLeading: false,
        centerTitle: true,
        elevation: 8,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _testVerifyPhoneNumber();
        },
        backgroundColor: ColorConstants.steelBlue,
        child: _fabLoading
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircularProgressIndicator(
                    valueColor:
                        new AlwaysStoppedAnimation<Color>(Colors.white)))
            : Icon(Icons.arrow_forward),
      ),
      body: new Container(
        color: ColorConstants.primaryColor,
        child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0), child: getBody()),
      ),
    );
  }

  Widget getBody() {
    if (currentState == LoginState.EnterPhone) {
      return Column(
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Container(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                new Flexible(
                  child: Text(
                    "+",
                    style: TextStyleConst.headerTextStyle,
                  ),
                ),
                new Container(
                  width: 5,
                ),
                new SizedBox(
                  width: 40,
                  child: TextFormField(
                    textInputAction: TextInputAction.next,
                    maxLength: 4,
                    style: new TextStyle(
                        fontSize: 16.0, height: 1.3, color: Colors.white),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      WhitelistingTextInputFormatter.digitsOnly
                    ],
                    controller: _numberPrefix,
                    decoration: const InputDecoration(
                      counterText: "",
                      labelText: "",
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue)),
                    ),
                  ),
                ),
                new Container(
                  width: 10,
                ),
                new Expanded(
                    flex: 10,
                    child: TextFormField(
                      style: new TextStyle(
                          fontSize: 16.0, height: 1.3, color: Colors.white),
                      controller: _number,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        WhitelistingTextInputFormatter.digitsOnly
                      ],
                      validator: validateMobile,
                      decoration: const InputDecoration(
                        fillColor: Colors.white,
                        labelText: "Номер телефона",
                        labelStyle: TextStyle(color: Colors.white70),
                        counterText: "",
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue)),
                      ),
                    ))
              ],
            ),
          ),
          Container(
            height: 5,
          ),
          Text(
            "SMS с кодом подтверждения придет на ваш номер телефона",
            style: TextStyle(color: Colors.white70),
          ),
          /*MaterialButton(
                  child: const Text('Test signInWithGoogle'),
                  onPressed: () {
                    setState(() {
                      _message = _testSignInWithGoogle();
                    });
                  }),
              MaterialButton(
                  child: const Text('Test verifyPhoneNumber'),
                  onPressed: () {
                    if (_numberPrefix.text != null && _number.text != null) {
                      String number = _numberPrefix.text + _number.text;
                      setState(() {
                        _message = _testVerifyPhoneNumber();
                      });
                    }
                  }),
              Container(
                margin: const EdgeInsets.only(
                  top: 8.0,
                  bottom: 8.0,
                  left: 16.0,
                  right: 16.0,
                ),
                child: TextField(
                  controller: _smsCodeController,
                  decoration: const InputDecoration(
                    hintText: 'SMS Code',
                  ),
                ),
              ),
              MaterialButton(
                  child: const Text('Test signInWithPhoneNumber'),
                  onPressed: () {
                    if (_numberPrefix.text != null && _number.text != null) {
                      String number = _numberPrefix.text + _number.text;
                      setState(() {
                        _message = _testSignInWithPhoneNumber(number);
                      });
                    }
                  }),*/
          FutureBuilder<String>(
              future: _message,
              builder: (_, AsyncSnapshot<String> snapshot) {
                return Text(snapshot.data ?? '',
                    style:
                        const TextStyle(color: Color.fromARGB(255, 0, 155, 0)));
              }),
        ],
      );
    } else if (currentState == LoginState.EnterSmsCode) {
      return Container(
        width: double.infinity,
        height: double.infinity,
        margin: const EdgeInsets.only(
          top: 8.0,
          bottom: 8.0,
          left: 16.0,
          right: 16.0,
        ),
        child: TextField(
          controller: _smsCodeController,
          decoration: const InputDecoration(
            counterText: "",
            fillColor: Colors.white,
            labelText: "Код",
            labelStyle: TextStyle(color: Colors.white70),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.blue)),
          ),
          style:
              new TextStyle(fontSize: 16.0, height: 1.3, color: Colors.white),
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            WhitelistingTextInputFormatter.digitsOnly
          ],
        ),
      );
    } else {
      return Container(
          margin: const EdgeInsets.only(
        top: 8.0,
        bottom: 8.0,
        left: 16.0,
        right: 16.0,
      ));
    }
  }

  String validateMobile(String value) {
// Indian Mobile number are of 10 digit only
    if (value.length != 10)
      return 'Mobile Number must be of 10 digit';
    else
      return null;
  }
}
