import 'package:flutter/material.dart';
import 'package:flutter_prueba_clase_autenticacion/helpers/helpers.dart';
import 'package:flutter_prueba_clase_autenticacion/models/authentication_response.dart';
import 'package:flutter_prueba_clase_autenticacion/services/authentication_service.dart';
import 'package:provider/provider.dart';

class EmailSignUp extends StatelessWidget {
  String correo;
  String contrasena;
  @override
  Widget build(BuildContext context) {
  AuthenticationService authService = Provider.of<AuthenticationService>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Registro con email"),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.all(20),
        child: Form(
          child: Column(
            children: [
              TextFormField(
                validator: (input) => input.isEmpty ? "Escribe un correo": null,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)
                  ),
                  labelText: "Correo electrónico"
                ),
                onChanged: (input) {
                  correo = input;
                }
              ),
              Container(height: 20),
              TextFormField(
                validator: (input) => input.isEmpty ? "Escribe una contraseña": null,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)
                  ),
                  labelText: "Contraseña"
                ),
                obscureText: true,
                onChanged: (input) {
                  contrasena = input;
                }
              ),
              Container(height: 20),
              MaterialButton(
                onPressed: () async {
                  AuthenticationResponse response = await authService.registerWithEmailAndPassword(correo, contrasena);
                  if(!response.success){
                    if(response.mensaje == "operation-not-allowed"){
                      mostrarAlerta(context, "Lo sentimos", "El registro con email se encuentra deshabilitado");
                    }else if(response.mensaje == "operation-not-allowed"){
                      mostrarAlerta(context, "Lo sentimos", "El registro con email se encuentra deshabilitado");
                    }else if(response.mensaje == "email-already-in-use"){
                      mostrarAlerta(context, "Lo sentimos", "El correo ingresado se encuentra en uso");
                    }else if(response.mensaje == "invalid-email"){
                      mostrarAlerta(context, "Lo sentimos", "El correo ingresado no es válido");
                    }else if(response.mensaje == "weak-password"){
                      mostrarAlerta(context, "Lo sentimos", "El correo ingresado es débil");
                    }
                  }else{
                    Navigator.pop(context);
                  }
                },
                color: Colors.green,
                child: Text(
                  "Registrarse",
                  style: TextStyle(
                    color: Colors.white
                  ),
                )
              )
            ],
          ),
        )
      ),
    );
  }
}