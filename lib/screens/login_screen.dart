import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/auth_cubit.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void _login() {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    context.read<AuthCubit>().signIn(email, password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            if (state is AuthLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is AuthAuthenticated) {
              return Center(child: Text("Welcome, ${state.user!.email}!"));
            } else if (state is AuthError) {
              return Column(
                children: [
                  _buildForm(),
                  const SizedBox(height: 12),
                  Text(
                    state.message,
                    style: const TextStyle(color: Colors.red),
                  ),
                ],
              );
            }
            return _buildForm();
          },
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextField(
          controller: emailController,
          decoration: const InputDecoration(labelText: "Email"),
        ),
        TextField(
          controller: passwordController,
          decoration: const InputDecoration(labelText: "Password"),
          obscureText: true,
        ),
        const SizedBox(height: 16),
        ElevatedButton(onPressed: _login, child: const Text("Login")),
        TextButton(
          onPressed: () {
            Navigator.of(context).pushNamed('/signup');
          },
          child: const Text("Don't have an account? Sign Up"),
        ),
      ],
    );
  }
}
