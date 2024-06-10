import 'package:flutter_clean_arch/cores/error/failure.dart';
import 'package:flutter_clean_arch/cores/usecases/usecase.dart';
import 'package:flutter_clean_arch/cores/common/entities/user.dart';
import 'package:flutter_clean_arch/features/auth/domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class UserSignIn implements Usecase<User, UserSignInParams> {
  final AuthRepository authRepository;
  UserSignIn(this.authRepository);

  @override
  Future<Either<Failure, User>> call(params) {
    return authRepository.signIn(
      email: params.email,
      password: params.password,
    );
  }
}

class UserSignInParams {
  final String email;
  final String password;

  UserSignInParams({
    required this.email,
    required this.password,
  });
}
