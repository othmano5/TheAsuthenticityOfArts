import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../../core/route/router.dart';
import '../../../shared/widgets/auth_page_frame.dart';
import '../application/session_controller.dart';
import '../application/session_state.dart';

final loginFormProvider = Provider.autoDispose<FormGroup>((ref) {
  return FormGroup({
    'phone': FormControl<String>(
      validators: [
        Validators.required,
        Validators.minLength(8),
        Validators.pattern(r'^\+?[0-9]{8,15}$'),
      ],
    ),
    'password': FormControl<String>(
      validators: [Validators.required, Validators.minLength(8)],
    ),
  });
});

final loginPasswordVisibleProvider =
    NotifierProvider.autoDispose<_LoginPasswordVisibleController, bool>(
      _LoginPasswordVisibleController.new,
    );

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(loginFormProvider);
    final isPasswordVisible = ref.watch(loginPasswordVisibleProvider);

    return AuthPageFrame(
      badge: 'تسجيل الدخول',
      title: 'مرحباً بعودتك',
      subtitle: 'أدخل رقم الهاتف وكلمة المرور للمتابعة.',
      maxWidth: 500,
      footer: TextButton(
        onPressed: () => context.push(AppRoute.register.path),
        child: const Text('ليس لديك حساب؟ إنشاء حساب جديد'),
      ),
      child: ReactiveForm(
        formGroup: form,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ReactiveTextField<String>(
              formControlName: 'phone',
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9+]')),
              ],
              decoration: const InputDecoration(
                labelText: 'رقم الهاتف',
                hintText: '11111111 أو 22222222',
                prefixIcon: Icon(Icons.phone_outlined),
              ),
              validationMessages: {
                ValidationMessage.required: (_) => 'رقم الهاتف مطلوب',
                ValidationMessage.minLength: (_) =>
                    'رقم الهاتف يجب أن يكون 8 أرقام على الأقل',
                ValidationMessage.pattern: (_) => 'أدخل رقم هاتف صحيح',
              },
            ),
            const SizedBox(height: 18),
            ReactiveTextField<String>(
              formControlName: 'password',
              obscureText: !isPasswordVisible,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                labelText: 'كلمة المرور',
                hintText: '12345678',
                prefixIcon: const Icon(Icons.lock_outline_rounded),
                suffixIcon: IconButton(
                  onPressed: () {
                    ref.read(loginPasswordVisibleProvider.notifier).toggle();
                  },
                  icon: Icon(
                    isPasswordVisible
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                  ),
                ),
              ),
              validationMessages: {
                ValidationMessage.required: (_) => 'كلمة المرور مطلوبة',
                ValidationMessage.minLength: (_) =>
                    'كلمة المرور يجب أن تكون 8 أحرف على الأقل',
              },
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => _submit(context, ref, form),
                child: const Text('تسجيل الدخول'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submit(
    BuildContext context,
    WidgetRef ref,
    FormGroup form,
  ) async {
    if (form.invalid) {
      form.markAllAsTouched();
      return;
    }

    final phone = (form.control('phone').value as String?)?.trim() ?? '';
    final password = (form.control('password').value as String?)?.trim() ?? '';

    AppUserRole? role;

    if (phone == '11111111' && password == '12345678') {
      role = AppUserRole.user;
    } else if (phone == '22222222' && password == '12345678') {
      role = AppUserRole.admin;
    }
    
    if (role == null) {
      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('بيانات الدخول غير صحيحة'),
          ),
        );
      return;
    }

    await ref.read(sessionControllerProvider.notifier).signIn(role: role);

    if (!context.mounted) {
      return;
    }

    context.go(role.homePath);
  }
}

class _LoginPasswordVisibleController extends Notifier<bool> {
  @override
  bool build() => false;

  void toggle() {
    state = !state;
  }
}
