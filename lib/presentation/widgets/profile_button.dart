import 'package:flutter/material.dart';
import 'package:live_shop/presentation/pages/orders_page.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class ProfileButton extends StatelessWidget {
  const ProfileButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadButton.ghost(
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const OrdersPage()),
      ),
      child: const Icon(LucideIcons.user),
    );
  }
}
