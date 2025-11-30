import 'package:flutter/material.dart';
import 'package:live_shop/core/constants/AppSizes.dart';
import 'package:live_shop/core/constants/constants.dart';
import 'package:live_shop/data/models/message_model.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({required this.message, super.key});

  final MessageModel message;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: AppSizes.avatarXs,
            backgroundImage: NetworkImage(message.userImage),
          ),
          const SizedBox(width: AppSizes.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      message.userName,
                      style: theme.textTheme.small.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: AppSizes.xs),
                    Text(
                      DateFormat(
                        AppConstants.timeFormat,
                      ).format(message.timestamp),
                      style: theme.textTheme.small.copyWith(
                        color: theme.colorScheme.mutedForeground,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.xs),
                Text(message.text, style: theme.textTheme.small),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
