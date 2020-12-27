import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationResponse{
  final bool success;
  final String mensaje;
  final User user;
  AuthenticationResponse({this.success, this.mensaje, this.user});
}