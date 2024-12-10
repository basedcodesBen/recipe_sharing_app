import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/drawer_widget.dart';
import 'logged_in_content.dart';
import 'logged_out_content.dart';
import '../../providers/auth_provider.dart';


class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: const DrawerWidget(),
      body: authState.when(
        data: (user) => user != null
            ? const LoggedInContent()
            : const LoggedOutContent(),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
