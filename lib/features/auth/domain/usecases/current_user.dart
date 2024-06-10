import 'package:flutter_clean_arch/cores/error/failure.dart';
import 'package:flutter_clean_arch/cores/usecases/usecase.dart';
import 'package:flutter_clean_arch/cores/common/entities/user.dart';
import 'package:flutter_clean_arch/features/auth/domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class CurrentUser implements Usecase<User, NoParams> {
  final AuthRepository authRepository;

  CurrentUser(this.authRepository);

  @override
  Future<Either<Failure, User>> call(NoParams params) async {
    return await authRepository.currentUser();
  }
}
