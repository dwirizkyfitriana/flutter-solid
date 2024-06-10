import 'package:flutter_clean_arch/cores/error/exceptions.dart';
import 'package:flutter_clean_arch/features/auth/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthRemoteDataSource {
  Session? get currentUserSession;
  Future<UserModel> signUp({
    required String name,
    required String email,
    required String password,
  });

  Future<UserModel> signIn({
    required String email,
    required String password,
  });

  Future<UserModel?> getCurrentUserData();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;
  AuthRemoteDataSourceImpl(this.supabaseClient);

  @override
  Session? get currentUserSession => supabaseClient.auth.currentSession;

  @override
  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabaseClient.auth
          .signInWithPassword(password: password, email: email);

      if (response.user == null) {
        throw const ServerExceptionn('User is null');
      }

      return UserModel.fromJson(response.user!.toJson());
    } catch (e) {
      throw ServerExceptionn(e.toString());
    }
  }

  @override
  Future<UserModel> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabaseClient.auth.signUp(
        password: password,
        email: email,
        data: {
          'name': name,
        },
      );

      if (response.user == null) {
        throw const ServerExceptionn('User is null');
      }

      return UserModel.fromJson(response.user!.toJson());
    } catch (e) {
      throw ServerExceptionn(e.toString());
    }
  }

  @override
  Future<UserModel?> getCurrentUserData() async {
    try {
      if (currentUserSession == null) return null;

      final userData = await supabaseClient
          .from('profile')
          .select()
          .eq('id', currentUserSession!.user.id);

      return UserModel.fromJson(userData.first)
          .copyWith(email: currentUserSession!.user.email);
    } catch (e) {
      throw ServerExceptionn(e.toString());
    }
  }
}
