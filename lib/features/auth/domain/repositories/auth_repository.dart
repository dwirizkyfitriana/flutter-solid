import 'package:flutter_clean_arch/cores/error/failure.dart';
import 'package:flutter_clean_arch/features/auth/domain/entity/user.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, User>> signUp({
    required String name,
    required String email,
    required String password,
  });

  Future<Either<Failure, User>> signIn({
    required String email,
    required String password,
  });
}
