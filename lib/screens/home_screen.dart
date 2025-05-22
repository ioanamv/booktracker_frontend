import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/auth_cubit.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userEmail =
        context.read<AuthCubit>().state is AuthAuthenticated
            ? (context.read<AuthCubit>().state as AuthAuthenticated).user!.email
            : "User";

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              context.read<AuthCubit>().signOut();
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
      body: Center(
        child: Text("Welcome, $userEmail!", style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
