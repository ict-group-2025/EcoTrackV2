import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/auth_controller.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    // Load user profile when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthController>().loadUserProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();
    final user = auth.user;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('No user data')),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ──
              const Text(
                'Profile',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A2340),
                ),
              ),
              const SizedBox(height: 20),

              // ── Profile Card ──
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: _cardDecoration(),
                child: Column(
                  children: [
                    // Avatar (initial)
                    CircleAvatar(
                      radius: 42,
                      backgroundColor: const Color(0xFF2196F3),
                      child: Text(
                        user.fullName.substring(0, 1).toUpperCase(),
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Name
                    Text(
                      user.fullName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A2340),
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Username
                    Text(
                      '@${user.username}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF8A94A6),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Role + Location
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _Badge(
                          icon: Icons.verified_outlined,
                          label: user.role ?? 'USER',
                        ),
                        if (user.userLocation != null) ...[
                          const SizedBox(width: 8),
                          _Badge(
                            icon: Icons.location_on_outlined,
                            label: user.userLocation!,
                          ),
                        ],
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Email
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.email_outlined,
                            size: 16, color: Color(0xFF8A94A6)),
                        const SizedBox(width: 6),
                        Text(
                          user.email,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF4A5568),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ── Account Stats ──
              const Text(
                'ACCOUNT',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                  color: Color(0xFF8A94A6),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _StatCard(
                    label: 'WARNINGS',
                    value: user.warningCount.toString(),
                  ),
                  const SizedBox(width: 12),
                  _StatCard(
                    label: 'BANS',
                    value: user.banCount.toString(),
                  ),
                ],
              ),

              const Spacer(),

              // ── Logout ──
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                  onPressed: () async {
                    await auth.logout();
                    if (mounted) {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        '/login',
                        (route) => false,
                      );
                    }
                  },
                  child: const Text(
                    'Logout',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFE53935),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}
class _Badge extends StatelessWidget {
  final IconData icon;
  final String label;

  const _Badge({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE8ECF2)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: const Color(0xFF607D8B)),
          const SizedBox(width: 5),
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Color(0xFF4A5568),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;

  const _StatCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A2340),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Color(0xFF8A94A6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}