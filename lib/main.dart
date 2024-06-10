import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_arch/cores/common/cubits/app_user/app_user_cubit.dart';
import 'package:flutter_clean_arch/cores/theme/theme.dart';
import 'package:flutter_clean_arch/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_clean_arch/features/auth/presentation/pages/signin_page.dart';
import 'package:flutter_clean_arch/features/blog/presentation/pages/blog_page.dart';
import 'package:flutter_clean_arch/init_dependencies.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initDependencies();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => serviceLocator<AppUserCubit>()),
        BlocProvider(create: (_) => serviceLocator<AuthBloc>())
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(AuthIsUserLoggedIn());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: AppTheme.darkThemeMode,
      home: BlocSelector<AppUserCubit, AppUserState, bool>(
        selector: (state) {
          return state is AppUserLoggedIn;
        },
        builder: (context, isLoggedIn) {
          if (isLoggedIn) {
            return const Scaffold(
              body: BlogPage(),
            );
          }
          return const SignInPage();
        },
      ),
    );
  }
}
