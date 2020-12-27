import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_prueba_clase_autenticacion/models/authentication_response.dart';
import 'package:flutter_prueba_clase_autenticacion/pages/custom_web_view.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationService {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Stream<User> streamFirebase = FirebaseAuth.instance.authStateChanges();
  Stream<User> get authStatus => streamFirebase;
  //Registro anónimo
  Future<AuthenticationResponse> ingresarAnonimamente() async {
    try{
      UserCredential credential = await _auth.signInAnonymously();
      return AuthenticationResponse(
        success: true,
        user: credential.user
      );
    }catch(error){
      return AuthenticationResponse(
        success: false,
        mensaje: error.code
      );
    }
  }
  //Registro con correo y contraseña
  Future<AuthenticationResponse> registerWithEmailAndPassword(String email, String password) async {
      try{
        UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
        User user = result.user;
        return AuthenticationResponse(
          success: true,
          user: user
        );
      }catch (error){
        return AuthenticationResponse(
          success: false,
          mensaje: error.code
        );
      }
  }
  //Registro con Google
  Future<AuthenticationResponse> signInGmail() async {
    try{
      GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
      GoogleSignInAuthentication gSA = await googleSignInAccount.authentication;
      UserCredential result = await _auth.signInWithCredential(
        GoogleAuthProvider.credential(idToken: gSA.idToken, accessToken: gSA.accessToken)
      );
      User user = result.user;
      return AuthenticationResponse(
        success: true,
        user: user
      );
    }catch(error){
      return AuthenticationResponse(
        success: false,
        mensaje: error.code
      );
    }
  }
  //Registro con Facebook
  Future<AuthenticationResponse> ingresarConFacebook(BuildContext context) async {
    
    String clienteId = "";//Aqui va tu id de la aplicación. Lo creas en Facebook Developers
    String redirectURL = "";//Esta url la obtienes de la consola de Firebase al momento que habilitas la autenticación por Facebook
    User user;

    String result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CustomWebView(
          selectedUrl:
            'https://www.facebook.com/dialog/oauth?client_id=$clienteId&redirect_uri=$redirectURL&response_type=token&scope=email,public_profile,',
        ),
        maintainState: true),
    );
    if (result != null) {
      UserCredential userCredential;
      try {
        FirebaseAuth firebaseAuth = FirebaseAuth.instance;
        OAuthCredential facebookAuthCred = FacebookAuthProvider.credential(result);
        userCredential = await firebaseAuth.signInWithCredential(facebookAuthCred);
        user = userCredential.user;
        return AuthenticationResponse(
          success: true,
          user: user
        );
      } catch (error) {
        return AuthenticationResponse(
          success: false,
          mensaje: error.code
        );
      }
    }else{
      return AuthenticationResponse(
        success: false,
        mensaje: "user-cancelled"
      );
    }
  }
  //Registro con número de Teléfono
  Future<AuthenticationResponse> ingresarConTelefono() async {
    try{
      await _auth.verifyPhoneNumber(
        phoneNumber: '+16505554567',
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          UserCredential userCredential = await _auth.signInWithCredential(credential);
          User user = userCredential.user;
          return AuthenticationResponse(
            success: true,
            user: user
          );
        },
        verificationFailed: (FirebaseAuthException e) {
          if (e.code == 'invalid-phone-number') {
            print('The provided phone number is not valid.');
            return AuthenticationResponse(
              success: false,
              mensaje: "user-cancelled"
            );
          }
        },
        codeSent: (String verificationId, int resendToken) async {
          // Update the UI - wait for the user to enter the SMS code
          String smsCode = '123456';

          // Create a PhoneAuthCredential with the code
          PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);

          // Sign the user in (or link) with the credential
          await _auth.signInWithCredential(phoneAuthCredential);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print("Tiempo de espera terminado");
        },
      );
    }catch(error){

    }
    
  }
  
  Future<void> signOut() async {
    try {
      return await _auth.signOut();
    } catch (error) {
      print("Error al intentar salir");
    }
  }
}