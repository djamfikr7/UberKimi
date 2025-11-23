import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'repositories/auth_repository.dart';
import 'repositories/driver_repository.dart';
import 'blocs/auth/auth_cubit.dart';
import 'screens/auth/login_screen.dart';

void main() {
  runApp(const DriverApp());
}

class DriverApp extends StatelessWidget {
  const DriverApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => AuthRepository()),
        RepositoryProvider(create: (context) => DriverRepository()),
      ],
      child: BlocProvider(
        create: (context) => AuthCubit(context.read<AuthRepository>()),
        child: MaterialApp(
          title: 'Uber Driver',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            scaffoldBackgroundColor: Colors.white,
          ),
          home: const LoginScreen(),
        ),
      ),
    );
  }
}
