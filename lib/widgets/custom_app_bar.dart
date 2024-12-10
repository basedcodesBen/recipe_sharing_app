import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../providers/auth_provider.dart';

class CustomAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return AppBar(
      backgroundColor: Colors.red[300],
      title: const Text('Savorly'),
      leading: Builder(
        builder: (BuildContext context) {
          return IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          );
        },
      ),
      actions: authState.when(
        data: (user) => user != null
            ? [
                TextButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Logged out successfully!')),
                    );
                  },
                  child: const Text(
                    'Logout',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ]
            : [],
        loading: () => [],
        error: (_, __) => [],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
