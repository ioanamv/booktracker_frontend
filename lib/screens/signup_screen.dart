import 'package:flutter/material.dart';
import '../cubit/auth_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void _signup() {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    context.read<AuthCubit>().signUp(email, password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign Up")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthAuthenticated) {
              Navigator.of(context).pushReplacementNamed('/home');
            }
            if (state is AuthError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (context, state) {
            if (state is AuthLoading) {
              return const Center(child: CircularProgressIndicator());
            }
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
                ElevatedButton(
                  onPressed: _signup,
                  child: const Text("Sign Up"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/');
                  },
                  child: const Text("Already have an account? Log in"),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
