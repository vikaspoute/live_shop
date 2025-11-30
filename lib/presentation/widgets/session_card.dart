import 'package:flutter/material.dart';
import 'package:live_shop/core/constants/AppSizes.dart';
import 'package:live_shop/data/models/session_model.dart';
import 'package:live_shop/l10n/l10n.dart';
import 'package:live_shop/presentation/pages/live_session_room_page.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class SessionCard extends StatelessWidget {
  const SessionCard({required this.session, super.key});

  final SessionModel session;

  String _formatViewerCount(int count) {
    if (count >= 1e6) return '${(count / 1e6).toStringAsFixed(1)}M';
    if (count >= 1e3) return '${(count / 1e3).toStringAsFixed(1)}K';
    return count.toString();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final l10n = context.l10n;

    return ShadCard(
      padding: const EdgeInsets.all(AppSizes.sm),
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => LiveSessionRoomPage(session: session),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            Stack(
              children: [
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(AppSizes.cardRadius),
                    ),
                    color: theme.colorScheme.muted,
                    image: session.thumbnailUrl != null
                        ? DecorationImage(
                            image: NetworkImage(session.thumbnailUrl!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: session.thumbnailUrl == null
                      ? Icon(
                          LucideIcons.tv,
                          size: 64,
                          color: theme.colorScheme.mutedForeground,
                        )
                      : null,
                ),

                // Live Badge
                if (session.isLive)
                  Positioned(
                    top: AppSizes.sm + AppSizes.xs,
                    left: AppSizes.sm + AppSizes.xs,
                    child: ShadBadge.destructive(
                      child: Text(context.l10n.live),
                    ),
                  ),

                // Viewer Count
                Positioned(
                  top: AppSizes.sm + AppSizes.xs,
                  right: AppSizes.sm + AppSizes.xs,
                  child: ShadBadge(
                    child: Row(
                      children: [
                        const Icon(
                          LucideIcons.eye,
                          size: AppSizes.iconXs,
                          color: Colors.white,
                        ),
                        const SizedBox(width: AppSizes.xs),
                        Text(
                          _formatViewerCount(session.viewerCount),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(AppSizes.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    session.title,
                    style: theme.textTheme.large?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSizes.sm),

                  // Seller
                  Row(
                    children: [
                      CircleAvatar(
                        radius: AppSizes.avatarXs,
                        backgroundImage: NetworkImage(session.sellerImage),
                      ),
                      const SizedBox(width: AppSizes.sm),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              session.sellerName,
                              style: theme.textTheme.small?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              DateFormat(
                                'MMM dd, hh:mm a',
                              ).format(session.startedAt),
                              style: theme.textTheme.muted,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSizes.lg),

                  // Join Button
                  ShadButton(
                    width: double.infinity,
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => LiveSessionRoomPage(session: session),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          LucideIcons.circlePlay,
                          size: AppSizes.iconSm,
                        ),
                        const SizedBox(width: AppSizes.sm),
                        Text(l10n.joinSession),
                      ],
                    ),
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
