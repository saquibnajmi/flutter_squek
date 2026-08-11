import 'package:flutter/material.dart';

import 'package:flutter_squek/pages/savings_page.dart';
import 'package:flutter_squek/services/audio_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AudioService _audioService = AudioService();

  Future<void> _playClick() async {
    await _audioService.playClick();
  }

  Future<void> _openSavings() async {
    await _playClick();
    if (!mounted) return;

    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const SavingsPage()),
    );
  }

  Widget _buildTile(
    BuildContext context, {
    required String label,
    required IconData icon,
    required VoidCallback onTap,
    Color? color,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            const BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.06),
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 32,
              backgroundColor: color ?? Colors.grey.shade200,
              child: Icon(icon, size: 32, color: Colors.black87),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      appBar: AppBar(
        title: const Text('flutter_squek'),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          int crossAxisCount = 2;
          if (width > 900) {
            crossAxisCount = 4;
          } else if (width > 600) {
            crossAxisCount = 3;
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 2,
                  child: GridView.count(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.2,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _buildTile(
                        context,
                        label: 'MY SAVING',
                        icon: Icons.account_balance_wallet,
                        color: Colors.blue.shade100,
                        onTap: _openSavings,
                      ),
                      _buildTile(
                        context,
                        label: 'BORROW & OUTSTANDING',
                        icon: Icons.money,
                        color: Colors.orange.shade100,
                        onTap: () {},
                      ),
                      _buildTile(
                        context,
                        label: 'MY SHARES',
                        icon: Icons.pie_chart,
                        color: Colors.green.shade100,
                        onTap: () {},
                      ),
                      _buildTile(
                        context,
                        label: 'MY ASSETS',
                        icon: Icons.account_balance,
                        color: Colors.purple.shade100,
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  flex: 3,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
                              'MY SAVING',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '25,59,238.56',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Expanded(
                          child: Center(
                            child: Text(
                              'Chart placeholder',
                              style: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
