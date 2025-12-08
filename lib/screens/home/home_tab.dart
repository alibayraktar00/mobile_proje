import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import '../exercises/exercises_tab.dart';
import '../calculations/calculations_tab.dart';
import '../nutrition/nutrition_tab.dart';
import '../supplements/supplements_tab.dart';
import '../../providers/auth_provider.dart';
import '../auth/login_screen.dart';

class HomeTab extends ConsumerWidget {
  const HomeTab({super.key});


  @override
  Widget build(BuildContext context, WidgetRef ref) {


    void signOut() async {
      try {
        final authService = ref.read(authServiceProvider);
        await authService.signOut();

        if (context.mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
          );
        }
      } catch (e) {
        debugPrint("Çıkış hatası: $e");
      }
    }


    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- HEADER ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hoş Geldin,",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "GymBuddy",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  // Çıkış Butonu
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(color: Colors.grey.withValues(alpha: 0.1), blurRadius: 10),
                      ],
                    ),
                    child: IconButton(
                      onPressed: signOut,
                      icon: Icon(Icons.logout_rounded, color: Colors.red[400]),
                      tooltip: "Log out",
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              const Text(
                "Kategoriler",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 16),

              // --- GRID MENÜ ---
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  childAspectRatio: 0.85,
                  children: [
                    _buildModernCard(
                      context,
                      title: "Egzersiz",
                      subtitle: "Programını Takip Et",
                      icon: Icons.fitness_center_rounded,
                      color1: Colors.blueAccent,
                      color2: Colors.lightBlueAccent,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ExercisesTab())),
                    ),
                    _buildModernCard(
                      context,
                      title: "Hesapla",
                      subtitle: "Vücut Endeksi",
                      icon: Icons.calculate_rounded,
                      color1: Colors.orange,
                      color2: Colors.deepOrangeAccent,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CalculationsTab())),
                    ),
                    _buildModernCard(
                      context,
                      title: "Takviye",
                      subtitle: "Supplement Listesi",
                      icon: Icons.local_pharmacy_rounded,
                      color1: Colors.green,
                      color2: Colors.tealAccent,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SupplementsTab())),
                    ),
                    _buildModernCard(
                      context,
                      title: "Beslenme",
                      subtitle: "Diyet ve Öğünler",
                      icon: Icons.restaurant_menu_rounded,
                      color1: Colors.redAccent,
                      color2: Colors.pinkAccent,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const NutritionTab())),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernCard(
      BuildContext context, {
        required String title,
        required String subtitle,
        required IconData icon,
        required Color color1,
        required Color color2,
        required VoidCallback onTap,
      }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [color1, color2],
          ),
          boxShadow: [
            BoxShadow(color: color1.withValues(alpha: 0.4), blurRadius: 12, offset: const Offset(0, 8)),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: -10,
              bottom: -10,
              child: Icon(icon, size: 80, color: Colors.white.withValues(alpha: 0.2)),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), shape: BoxShape.circle),
                    child: Icon(icon, color: Colors.white, size: 28),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                      const SizedBox(height: 4),
                      Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.8))),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}