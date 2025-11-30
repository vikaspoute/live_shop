import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_shop/core/constants/AppSizes.dart';
import 'package:live_shop/data/models/message_model.dart';
import 'package:live_shop/data/models/product_model.dart';
import 'package:live_shop/data/models/session_model.dart';
import 'package:live_shop/l10n/l10n.dart';
import 'package:live_shop/presentation/blocs/auth/auth_bloc.dart';
import 'package:live_shop/presentation/blocs/chat/chat_cubit.dart';
import 'package:live_shop/presentation/widgets/cart_button.dart';
import 'package:live_shop/presentation/widgets/empty_widget.dart';
import 'package:live_shop/presentation/widgets/error_widget.dart';
import 'package:live_shop/presentation/widgets/message_bubble.dart';
import 'package:live_shop/presentation/widgets/message_input_field.dart';
import 'package:live_shop/presentation/widgets/product_highlight_card.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class LiveSessionRoomPage extends StatefulWidget {
  const LiveSessionRoomPage({required this.session, super.key});

  final SessionModel session;

  @override
  State<LiveSessionRoomPage> createState() => _LiveSessionRoomPageState();
}

class _LiveSessionRoomPageState extends State<LiveSessionRoomPage> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();

  late final String _userId;

  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthSuccess) {
      _userId = authState.userId;
    } else {
      _userId = 'guest_${DateTime.now().millisecondsSinceEpoch}';
    }
    context.read<ChatCubit>().loadMessages(widget.session.id);
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    await context.read<ChatCubit>().sendMessage(
      sessionId: widget.session.id,
      userId: _userId,
      userName: 'Gust ${_userId.substring(4)}',
      text: text,
    );

    _messageController.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    if (!_scrollController.hasClients) return;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = ShadTheme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.session.title,
              style: theme.textTheme.small,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppSizes.xs),
            Text(
              '${widget.session.viewerCount} ${l10n.watching}',
              style: theme.textTheme.small.copyWith(
                color: theme.colorScheme.mutedForeground,
              ),
            ),
          ],
        ),
        actions: const [
          CartButton(),
          SizedBox(width: AppSizes.sm),
        ],
      ),
      body: Column(
        children: [
          const VideoStreamPlaceholder(),
          HighlightedProductPanel(sessionId: widget.session.id),
          const Divider(height: 1),
          Expanded(
            child: BlocConsumer<ChatCubit, ChatState>(
              listener: (_, _) => _scrollToBottom(),
              builder: (context, state) {
                if (state is ChatLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is ChatError) {
                  return ErrorStateWidget(
                    message: state.message,
                    error: context.l10n.error,
                    onRetry: () {},
                  );
                }

                final messages = state is ChatLoaded
                    ? state.messages
                    : <MessageModel>[];
                if (messages.isEmpty) {
                  return EmptyWidget(
                    icon: LucideIcons.messageCircle,
                    subtitle: l10n.beFirstToChat,
                    title: l10n.noMessagesYet,
                  );
                }

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(AppSizes.md),
                  itemCount: messages.length,
                  itemBuilder: (_, i) => MessageBubble(message: messages[i]),
                );
              },
            ),
          ),
          const Divider(height: 1),
          MessageInputField(
            controller: _messageController,
            onSend: _sendMessage,
          ),
        ],
      ),
    );
  }
}

class VideoStreamPlaceholder extends StatelessWidget {
  const VideoStreamPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = ShadTheme.of(context);
    return Container(
      height: 200,
      color: Colors.black12,
      child: Stack(
        children: [
          const Center(
            child: Icon(
              LucideIcons.circlePlay,
              size: 80,
              color: Colors.white70,
            ),
          ),
          Positioned(
            top: AppSizes.md,
            left: AppSizes.md,
            child: ShadBadge.destructive(
              child: Row(
                children: [
                  const Icon(
                    LucideIcons.circlePlay,
                    size: AppSizes.sm,
                    color: Colors.white,
                  ),
                  const SizedBox(width: AppSizes.xs),
                  Text(
                    l10n.live,
                    style: theme.textTheme.large.copyWith(
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
    );
  }
}

class HighlightedProductPanel extends StatelessWidget {
  const HighlightedProductPanel({required this.sessionId, super.key});

  final String sessionId;

  Future<ProductModel?> _fetchProduct() async {
    final snap = await FirebaseFirestore.instance
        .collection('products')
        .where('sessionId', isEqualTo: sessionId)
        .limit(1)
        .get();
    if (snap.docs.isEmpty) return null;
    final data = snap.docs.first.data()..['id'] = snap.docs.first.id;
    return ProductModel.fromJson(data);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ProductModel?>(
      future: _fetchProduct(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 120,
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (!snapshot.hasData) return const NoProductWidget();
        return ProductHighlightCard(product: snapshot.data!);
      },
    );
  }
}

class NoProductWidget extends StatelessWidget {
  const NoProductWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final l10n = context.l10n;

    return Container(
      padding: const EdgeInsets.all(AppSizes.lg),
      decoration: BoxDecoration(
        color: theme.colorScheme.muted.withOpacity(0.1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            LucideIcons.package,
            size: 48,
            color: theme.colorScheme.mutedForeground,
          ),
          const SizedBox(height: AppSizes.sm),
          Text(l10n.noProductsAvailable, style: theme.textTheme.small),
        ],
      ),
    );
  }
}
