import 'package:flutter/material.dart';
import 'package:live_shop/core/constants/AppSizes.dart';
import 'package:live_shop/l10n/l10n.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class MessageInputField extends StatelessWidget {
  const MessageInputField({
    required this.controller,
    required this.onSend,
    super.key,
  });

  final TextEditingController controller;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final l10n = context.l10n;

    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      color: theme.colorScheme.background,
      child: Row(
        children: [
          Expanded(
            child: ShadInput(
              controller: controller,
              placeholder: Text(l10n.sendMessageHint),
              onSubmitted: (_) => onSend(),
            ),
          ),
          const SizedBox(width: AppSizes.sm),
          ShadButton(
            onPressed: onSend,
            child: const Icon(LucideIcons.send),
          ),
        ],
      ),
    );
  }
}
