import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'services/hive_service.dart';
import 'screens/auth/login_screen.dart';
import 'screens/home/main_navigation_screen.dart';
import 'providers/auth_provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();


  
  // Initialize Firebase
  bool firebaseInitialized = false;
  try {
    // Initialize Firebase without options (will use google-services.json for Android)
    // If you have firebase_options.dart, you can uncomment the import and use:
    // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,);
  firebaseInitialized = true;
    debugPrint('Firebase initialized successfully');
  } catch (e) {
    // Firebase might not be configured yet
    debugPrint('Firebase initialization error: $e');
    debugPrint('To set up Firebase:');
    debugPrint('1. Create a Firebase project at https://console.firebase.google.com/');
    debugPrint('2. Add your Android app and download google-services.json');
    debugPrint('3. Place google-services.json in android/app/');
    debugPrint('4. (Optional) Run: flutterfire configure');
    // Continue without Firebase - app will show error messages when trying to use auth
  }

  // Initialize Hive (works without Firebase)
  await HiveService.init();

  runApp(ProviderScope(
    child: MyApp(firebaseInitialized: firebaseInitialized),
  ));
}

class MyApp extends StatelessWidget {
  final bool firebaseInitialized;
  
  const MyApp({super.key, required this.firebaseInitialized});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GYMBUDDY',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: firebaseInitialized 
          ? const AuthWrapper()
          : const FirebaseSetupScreen(),
    );
  }
}

class FirebaseSetupScreen extends StatelessWidget {
  const FirebaseSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Setup Required'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.orange,
            ),
            const SizedBox(height: 24),
            const Text(
              'Firebase Not Configured',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'To use authentication features, please set up Firebase.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                // Show instructions
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Firebase Setup'),
                    content: const SingleChildScrollView(
                      child: Text(
                        '1. Install FlutterFire CLI: dart pub global activate flutterfire_cli\n\n'
                        '2. Run: flutterfire configure\n\n'
                        '3. Enable Email/Password authentication in Firebase Console\n\n'
                        '4. Create a Firestore database\n\n'
                        'See FIREBASE_SETUP.md for detailed instructions.',
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(Icons.info),
              label: const Text('View Setup Instructions'),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                // Allow app to continue without Firebase (limited functionality)
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => const MainNavigationScreen(),
                  ),
                );
              },
              child: const Text('Continue Without Firebase (Limited Features)'),
            ),
          ],
        ),
      ),
    );
  }
}

class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (user) {
        if (user != null) {
          return const MainNavigationScreen();
        }
        return const LoginScreen();
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => const LoginScreen(),
    );
  }
}
