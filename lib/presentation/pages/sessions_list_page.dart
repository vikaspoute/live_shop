import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_shop/core/constants/AppSizes.dart';
import 'package:live_shop/l10n/l10n.dart';
import 'package:live_shop/presentation/blocs/cart/cart_cubit.dart';
import 'package:live_shop/presentation/blocs/session/session_bloc.dart';
import 'package:live_shop/presentation/widgets/cart_button.dart';
import 'package:live_shop/presentation/widgets/empty_widget.dart';
import 'package:live_shop/presentation/widgets/error_widget.dart';
import 'package:live_shop/presentation/widgets/profile_button.dart';
import 'package:live_shop/presentation/widgets/session_card.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class SessionsListPage extends StatefulWidget {
  const SessionsListPage({super.key});

  @override
  State<SessionsListPage> createState() => _SessionsListPageState();
}

class _SessionsListPageState extends State<SessionsListPage> {
  @override
  void initState() {
    super.initState();
    context.read<SessionBloc>().add(const FetchSessionsEvent());
    _loadCart();
  }

  Future<void> _loadCart() async {
    await context.read<CartCubit>().loadCart();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.liveSessions),
        automaticallyImplyLeading: false,
        actions: const [
          ProfileButton(),
          CartButton(),
          SizedBox(width: AppSizes.sm),
        ],
      ),
      body: BlocBuilder<SessionBloc, SessionState>(
        builder: (context, state) {
          if (state is SessionLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is SessionError) {
            return ErrorStateWidget(
              message: state.message,
              error: l10n.errorLoadingSessions,
              onRetry: () =>
                  context.read<SessionBloc>().add(const FetchSessionsEvent()),
            );
          }

          if (state is SessionLoaded) {
            if (state.sessions.isEmpty) {
              return EmptyWidget(
                icon: LucideIcons.tv,
                subtitle: l10n.checkBackLater,
                title: l10n.noLiveSessions,
              );
            }

            return RefreshIndicator(
              onRefresh: () async => context.read<SessionBloc>().add(
                const RefreshSessionsEvent(),
              ),
              child: ListView.builder(
                padding: const EdgeInsets.all(AppSizes.md),
                itemCount: state.sessions.length,
                itemBuilder: (context, index) {
                  final session = state.sessions[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSizes.md),
                    child: SessionCard(session: session),
                  );
                },
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
