import 'package:flutter/material.dart';
import 'package:flutter_prueba_clase_autenticacion/services/authentication_service.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AuthenticationService authService = Provider.of<AuthenticationService>(context);
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () async {
              await authService.signOut();
            },
          )
        ],
      ),
      body: Center(child: Text("Registrado correctamente")),
    );
  }
}