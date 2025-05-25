import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/api_service.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  late FirebaseAuth _auth;

  ApiService apiService;

  AuthCubit(this.apiService) : super(AuthInitial()) {
    _auth = FirebaseAuth.instance;
  }

  Future<void> initialize() async {
    final user = _auth.currentUser;
    if (user != null) {
      apiService.setAuthToken(await user.getIdToken());
      emit(AuthAuthenticated(user));
    }
  }

  Future<void> signUp(String email, String password) async {
    emit(AuthLoading());
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      try {
        final response = await apiService.postRequest('/users', {
          'userId': credential.user!.uid,
          'email': email,
        });
        if (response.statusCode != 200 && response.statusCode != 201) {
          await credential.user!.delete();
          emit(AuthError('Backend server error: ${response.body}'));
          return;
        }
        apiService.setAuthToken(await _auth.currentUser!.getIdToken());
        emit(AuthAuthenticated(_auth.currentUser));
      } catch (e) {
        await credential.user!.delete();
        emit(AuthError(e.toString()));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> signIn(String email, String password) async {
    emit(AuthLoading());
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      apiService.setAuthToken(await _auth.currentUser!.getIdToken());
      emit(AuthAuthenticated(_auth.currentUser));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> signOut() async {
    emit(AuthLoading());
    try {
      await _auth.signOut();
      apiService.setAuthToken(null);
      emit(AuthInitial());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
