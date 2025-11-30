import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_shop/core/constants/AppSizes.dart';
import 'package:live_shop/l10n/l10n.dart';
import 'package:live_shop/presentation/blocs/auth/auth_bloc.dart';
import 'package:live_shop/presentation/pages/sessions_list_page.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<ShadFormState>();
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  bool _showOtpField = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  void _sendOtp() {
    if (_formKey.currentState!.saveAndValidate()) {
      setState(() => _showOtpField = true);
      ShadToaster.of(context).show(
        ShadToast(
          title: Text(context.l10n.otpSendSuccess),
          description: const Text('123456'),
        ),
      );
    }
  }

  void _login() {
    if (_formKey.currentState!.saveAndValidate()) {
      context.read<AuthBloc>().add(
        LoginEvent(phone: _phoneController.text, otp: _otpController.text),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = ShadTheme.of(context);

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.lg),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: ShadCard(
              title: Text(l10n.welcomeToLiveShop),
              description: Text(l10n.enterPhoneToStart),
              child: ShadForm(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: AppSizes.xl),
                    Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        LucideIcons.shoppingBag,
                        size: 40,
                        color: Colors.deepPurple,
                      ),
                    ),
                    const SizedBox(height: AppSizes.xl),

                    ShadInputFormField(
                      id: 'phone',
                      controller: _phoneController,
                      label: Text(l10n.phoneNumber),
                      placeholder: const Text('+1234567890'),
                      leading: const Icon(LucideIcons.phone, size: 16),
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: AppSizes.md),

                    if (_showOtpField) ...[
                      ShadInputFormField(
                        id: 'otp',
                        controller: _otpController,
                        label: Text(l10n.otp),
                        placeholder: Text(context.l10n.useOtpHint),
                        leading: const Icon(LucideIcons.lock, size: AppSizes.md),
                        keyboardType: TextInputType.number,
                        maxLength: 6,
                      ),
                      const SizedBox(height: AppSizes.sm),
                      ShadAlert.raw(
                        title: Text(context.l10n.demoMode),
                        description: Text(context.l10n.useOtpHint),
                        variant: ShadAlertVariant.primary,
                      ),
                      const SizedBox(height: AppSizes.md),
                    ],

                    BlocConsumer<AuthBloc, AuthState>(
                      listener: (context, state) async {
                        if (state is AuthSuccess) {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SessionsListPage(),
                            ),
                          );
                        }
                      },
                      builder: (context, state) {
                        final loading = state is AuthLoading;
                        return ShadButton(
                          width: double.infinity,
                          onPressed: loading
                              ? null
                              : (_showOtpField ? _login : _sendOtp),
                          child: loading
                              ? const SizedBox(
                                  width: AppSizes.md,
                                  height: AppSizes.md,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(_showOtpField ? l10n.login : l10n.sendOtp),
                        );
                      },
                    ),

                    if (_showOtpField) ...[
                      const SizedBox(height: AppSizes.md),
                      ShadButton.outline(
                        width: double.infinity,
                        onPressed: () => setState(() {
                          _showOtpField = false;
                          _otpController.clear();
                        }),
                        child: Text(l10n.back),
                      ),
                    ],

                    const SizedBox(height: AppSizes.xl),
                    Text(
                      l10n.termsAgreement,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.small.copyWith(
                        color: theme.colorScheme.mutedForeground,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
