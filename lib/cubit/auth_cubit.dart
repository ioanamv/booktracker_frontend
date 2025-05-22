import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthCubit() : super(AuthInitial());

  Future<void> signUp(String email, String password) async {
    emit(AuthLoading());
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      emit(AuthAuthenticated(_auth.currentUser));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> signIn(String email, String password) async {
    emit(AuthLoading());
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      emit(AuthAuthenticated(_auth.currentUser));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    emit(AuthInitial());
  }
}
