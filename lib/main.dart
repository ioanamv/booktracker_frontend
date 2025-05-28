import 'package:booktracker/screens/edit_book_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'screens/login_screen.dart';
import 'cubit/auth_cubit.dart';
import 'screens/home_screen.dart';
import 'screens/signup_screen.dart';
import 'services/api_service.dart';
import 'screens/add_book_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final apiService = ApiService();

  final authCubit = AuthCubit(apiService);
  await authCubit.initialize();

  runApp(
    MultiBlocProvider(
      providers: [
        Provider<ApiService>.value(value: apiService),
        BlocProvider<AuthCubit>.value(value: authCubit),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/home': (context) => const HomeScreen(),
        '/addBook': (context) => const AddBookScreen(),
        '/editBook': (context) => const EditBookScreen(),
      },
    );
  }
}
