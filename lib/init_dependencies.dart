import 'package:flutter_clean_arch/cores/common/cubits/app_user/app_user_cubit.dart';
import 'package:flutter_clean_arch/cores/secrets/app_secrets.dart';
import 'package:flutter_clean_arch/features/auth/data/datasource/auth_remote_data_source.dart';
import 'package:flutter_clean_arch/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_clean_arch/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_clean_arch/features/auth/domain/usecases/current_user.dart';
import 'package:flutter_clean_arch/features/auth/domain/usecases/user_sign_in.dart';
import 'package:flutter_clean_arch/features/auth/domain/usecases/user_sign_up.dart';
import 'package:flutter_clean_arch/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();

  final supabase = await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.supabaseAnnonKey,
  );
  serviceLocator.registerLazySingleton(() => supabase.client);
  serviceLocator.registerLazySingleton(() => AppUserCubit());
}

void _initAuth() {
  serviceLocator.registerFactory<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(serviceLocator()),
  );
  serviceLocator.registerFactory<AuthRepository>(
    () => AuthRepositoryImpl(serviceLocator()),
  );
  serviceLocator.registerFactory(
    () => UserSignUp(serviceLocator()),
  );
  serviceLocator.registerFactory(
    () => UserSignIn(serviceLocator()),
  );
  serviceLocator.registerFactory(
    () => CurrentUser(serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => AuthBloc(
      userSignUp: serviceLocator(),
      userSignIn: serviceLocator(),
      currentUser: serviceLocator(),
      appUserCubit: serviceLocator(),
    ),
  );
}
