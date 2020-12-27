import 'package:flutter/material.dart';
import 'package:flutter_prueba_clase_autenticacion/models/authentication_response.dart';
import 'package:flutter_prueba_clase_autenticacion/pages/email_sign_up.dart';
import 'package:flutter_prueba_clase_autenticacion/pages/home_page.dart';
import 'package:flutter_prueba_clase_autenticacion/services/authentication_service.dart';
import 'package:provider/provider.dart';

class PrincipalPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
  AuthenticationService authService = Provider.of<AuthenticationService>(context);
    return StreamBuilder(
      stream: authService.authStatus,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        if (!snapshot.hasData || snapshot.hasError) {
          return AuthMethods();
        }else if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }else{
          // FirebaseUser user = snapshot.data;  
          return HomePage();
        }
      }
    );
  }
}
class AuthMethods extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
  AuthenticationService authService = Provider.of<AuthenticationService>(context);
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        margin: EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MaterialButton(
                onPressed: () async {
                  AuthenticationResponse response = await authService.ingresarAnonimamente();
                },
                color: Colors.grey,
                child: Text("Registrase anónimamente", style: TextStyle(color: Colors.white)),
              ),
              MaterialButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => EmailSignUp()));
                },
                color: Colors.grey,
                child: Text("Registrase con correo y contraseña", style: TextStyle(color: Colors.white)),
              ),
              MaterialButton(
                onPressed: () async {
                  AuthenticationResponse response = await authService.signInGmail();
                },
                color: Colors.red[400],
                child: Text("Registrase con Google", style: TextStyle(color: Colors.white)),
              ),
              MaterialButton(
                onPressed: () async {
                  AuthenticationResponse response = await authService.ingresarConFacebook(context);
                },
                color: Colors.blue[700],
                child: Text("Registrase con Facebook", style: TextStyle(color: Colors.white)),
              ),
              MaterialButton(
                onPressed: () async {
                  AuthenticationResponse response = await authService.ingresarConTelefono();
                },
                color: Colors.grey,
                child: Text("Registrase con Teléfono", style: TextStyle(color: Colors.white)),
              ),
            ]
          ),
        ),
      ),
    );
  }
}