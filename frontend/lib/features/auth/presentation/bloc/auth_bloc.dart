import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:news_app_clean_architecture/features/auth/domain/entities/user_entity.dart';
import 'package:news_app_clean_architecture/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:news_app_clean_architecture/features/auth/domain/usecases/sign_in_anonymously_usecase.dart';
import 'package:news_app_clean_architecture/features/auth/domain/usecases/sign_out_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final SignInAnonymouslyUseCase signInAnonymouslyUseCase;
  final SignOutUseCase signOutUseCase;

  AuthBloc({
    required this.getCurrentUserUseCase,
    required this.signInAnonymouslyUseCase,
    required this.signOutUseCase,
  }) : super(AuthInitial()) {
    on<AppStarted>(_onAppStarted);
    on<SignInAnonymously>(_onSignInAnonymously);
    on<SignOut>(_onSignOut);
  }

  void _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await getCurrentUserUseCase.call();
    result.fold(
      (failure) => emit(AuthFailure(failure.toString())),
      (user) {
        if (user != null) {
          emit(Authenticated(user));
        } else {
          add(SignInAnonymously());
        }
      },
    );
  }

  void _onSignInAnonymously(
      SignInAnonymously event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await signInAnonymouslyUseCase.call();
    result.fold(
      (failure) => emit(AuthFailure(failure.toString())),
      (user) => emit(Authenticated(user)),
    );
  }

  void _onSignOut(SignOut event, Emitter<AuthState> emit) async {
    await signOutUseCase.call();
    emit(Unauthenticated());
  }
}
