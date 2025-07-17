import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_health_api_client/pet_health_api_client.dart';
import 'blocs/auth/auth_bloc.dart';
import 'blocs/auth/auth_state.dart';
import 'blocs/pets/pets_bloc.dart';
import 'blocs/health/health_bloc.dart';
import 'repositories/auth_repository.dart';
import 'repositories/pet_repository.dart';
import 'repositories/health_repository.dart';
import 'screens/auth/login_screen.dart';
import 'screens/pets/pets_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<PetHealthApiClient>(
          create: (context) => PetHealthApiClient(basePathOverride: 'http://localhost:8000'),
        ),
        RepositoryProvider<AuthRepository>(
          create: (context) {
            final apiClient = context.read<PetHealthApiClient>();
            return AuthRepository(authApi: apiClient.getAuthenticationApi(), apiClient: apiClient);
          },
        ),
        RepositoryProvider<PetRepository>(
          create: (context) {
            final apiClient = context.read<PetHealthApiClient>();
            return PetRepository(petsApi: apiClient.getPetsApi());
          },
        ),
        RepositoryProvider<HealthRepository>(
          create: (context) {
            final apiClient = context.read<PetHealthApiClient>();
            return HealthRepository(healthApi: apiClient.getHealthApi());
          },
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(
              authRepository: context.read<AuthRepository>(),
            ),
          ),
          BlocProvider<PetsBloc>(
            create: (context) => PetsBloc(
              petRepository: context.read<PetRepository>(),
            ),
          ),
          BlocProvider<HealthBloc>(
            create: (context) => HealthBloc(
              healthRepository: context.read<HealthRepository>(),
            ),
          ),
        ],
        child: MaterialApp(
          title: 'Pet Health Tracker',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
            useMaterial3: true,
          ),
          routes: {
            '/login': (context) => const LoginScreen(),
            '/home': (context) => const PetsListScreen(),
          },
          home: const AuthWrapper(),
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          return const PetsListScreen();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
