import 'package:flutter_clean_arch/cores/error/exceptions.dart';
import 'package:flutter_clean_arch/cores/error/failure.dart';
import 'package:flutter_clean_arch/features/auth/data/datasource/auth_remote_data_source.dart';
import 'package:flutter_clean_arch/features/auth/domain/entity/user.dart';
import 'package:flutter_clean_arch/features/auth/domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  const AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, User>> signIn({
    required String email,
    required String password,
  }) async {
    return _getUser(
      () async => await remoteDataSource.signIn(
        email: email,
        password: password,
      ),
    );
  }

  @override
  Future<Either<Failure, User>> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    return _getUser(
      () async => await remoteDataSource.signUp(
        name: name,
        email: email,
        password: password,
      ),
    );
  }
}

Future<Either<Failure, User>> _getUser(Future<User> Function() fn) async {
  try {
    final user = await fn();

    return right(user);
  } on sb.AuthException catch (e) {
    return left(Failure(e.message));
  } on ServerExceptionn catch (e) {
    return left(Failure(e.message));
  }
}
