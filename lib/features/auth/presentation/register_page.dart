import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../../core/route/router.dart';
import '../../../shared/widgets/auth_page_frame.dart';

final registerFormProvider = Provider.autoDispose<FormGroup>((ref) {
  return FormGroup(
    {
      'name': FormControl<String>(
        validators: [Validators.required, Validators.minLength(3)],
      ),
      'phone': FormControl<String>(
        validators: [
          Validators.required,
          Validators.minLength(9),
          Validators.pattern(r'^\+?[0-9]{9,15}$'),
        ],
      ),
      'address': FormControl<String>(
        validators: [Validators.required, Validators.minLength(6)],
      ),
      'birthDate': FormControl<DateTime>(validators: [Validators.required]),
      'password': FormControl<String>(
        validators: [Validators.required, Validators.minLength(8)],
      ),
      'confirmPassword': FormControl<String>(validators: [Validators.required]),
    },
    validators: [Validators.mustMatch('password', 'confirmPassword')],
  );
});

final registerPasswordVisibleProvider =
    NotifierProvider.autoDispose<_RegisterPasswordVisibleController, bool>(
      _RegisterPasswordVisibleController.new,
    );

final registerConfirmPasswordVisibleProvider =
    NotifierProvider.autoDispose<
      _RegisterConfirmPasswordVisibleController,
      bool
    >(_RegisterConfirmPasswordVisibleController.new);

class RegisterPage extends ConsumerWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(registerFormProvider);
    final isPasswordVisible = ref.watch(registerPasswordVisibleProvider);
    final isConfirmPasswordVisible = ref.watch(
      registerConfirmPasswordVisibleProvider,
    );

    return AuthPageFrame(
      badge: 'إنشاء حساب',
      title: 'ابدأ رحلتك في أصالة الفنون',
      subtitle:
          'أنشئ حساباً جديداً عبر نموذج حديث ومنظم ومتجاوب على الموبايل والشاشات الأكبر.',
      maxWidth: 860,
      footer: TextButton(
        onPressed: () => context.go(AppRoute.login.path),
        child: const Text('لديك حساب بالفعل؟ تسجيل الدخول'),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 640;

          return ReactiveForm(
            formGroup: form,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _AdaptiveFields(
                  isWide: isWide,
                  first: ReactiveTextField<String>(
                    formControlName: 'name',
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'الاسم الكامل',
                      hintText: 'أدخل الاسم الكامل',
                      prefixIcon: Icon(Icons.person_outline_rounded),
                    ),
                    validationMessages: {
                      ValidationMessage.required: (_) => 'الاسم مطلوب',
                      ValidationMessage.minLength: (_) =>
                          'الاسم يجب أن يكون 3 أحرف على الأقل',
                    },
                  ),
                  second: ReactiveTextField<String>(
                    formControlName: 'phone',
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9+]')),
                    ],
                    decoration: const InputDecoration(
                      labelText: 'رقم الهاتف',
                      hintText: '09XXXXXXXX أو +9639XXXXXXX',
                      prefixIcon: Icon(Icons.phone_outlined),
                    ),
                    validationMessages: {
                      ValidationMessage.required: (_) => 'رقم الهاتف مطلوب',
                      ValidationMessage.minLength: (_) =>
                          'رقم الهاتف قصير جداً',
                      ValidationMessage.pattern: (_) => 'أدخل رقم هاتف صحيح',
                    },
                  ),
                ),
                const SizedBox(height: 18),
                ReactiveTextField<String>(
                  formControlName: 'address',
                  textInputAction: TextInputAction.next,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'العنوان',
                    hintText: 'أدخل العنوان الكامل',
                    prefixIcon: Icon(Icons.location_on_outlined),
                  ),
                  validationMessages: {
                    ValidationMessage.required: (_) => 'العنوان مطلوب',
                    ValidationMessage.minLength: (_) => 'العنوان قصير جداً',
                  },
                ),
                const SizedBox(height: 18),
                _AdaptiveFields(
                  isWide: isWide,
                  first: _BirthDateField(
                    control: form.control('birthDate') as FormControl<DateTime>,
                  ),
                  second: ReactiveTextField<String>(
                    formControlName: 'password',
                    obscureText: !isPasswordVisible,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: 'كلمة المرور',
                      hintText: '********',
                      prefixIcon: const Icon(Icons.lock_outline_rounded),
                      suffixIcon: IconButton(
                        onPressed: () {
                          ref
                              .read(registerPasswordVisibleProvider.notifier)
                              .toggle();
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
                ),
                const SizedBox(height: 18),
                ReactiveTextField<String>(
                  formControlName: 'confirmPassword',
                  obscureText: !isConfirmPasswordVisible,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    labelText: 'تأكيد كلمة المرور',
                    hintText: '********',
                    prefixIcon: const Icon(Icons.verified_user_outlined),
                    suffixIcon: IconButton(
                      onPressed: () {
                        ref
                            .read(
                              registerConfirmPasswordVisibleProvider.notifier,
                            )
                            .toggle();
                      },
                      icon: Icon(
                        isConfirmPasswordVisible
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                      ),
                    ),
                  ),
                  validationMessages: {
                    ValidationMessage.required: (_) =>
                        'تأكيد كلمة المرور مطلوب',
                    ValidationMessage.mustMatch: (_) =>
                        'كلمتا المرور غير متطابقتين',
                  },
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => _submit(context, form),
                    child: const Text('إنشاء الحساب'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _submit(BuildContext context, FormGroup form) {
    if (form.invalid) {
      form.markAllAsTouched();
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم إنشاء الحساب يمكنك الآن تسجيل الدخول.')),
    );

    context.go(AppRoute.login.path);
  }
}

class _RegisterPasswordVisibleController extends Notifier<bool> {
  @override
  bool build() => false;

  void toggle() {
    state = !state;
  }
}

class _RegisterConfirmPasswordVisibleController extends Notifier<bool> {
  @override
  bool build() => false;

  void toggle() {
    state = !state;
  }
}

class _AdaptiveFields extends StatelessWidget {
  const _AdaptiveFields({
    required this.isWide,
    required this.first,
    required this.second,
  });

  final bool isWide;
  final Widget first;
  final Widget second;

  @override
  Widget build(BuildContext context) {
    if (!isWide) {
      return Column(children: [first, const SizedBox(height: 18), second]);
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: first),
        const SizedBox(width: 16),
        Expanded(child: second),
      ],
    );
  }
}

class _BirthDateField extends StatelessWidget {
  const _BirthDateField({required this.control});

  final FormControl<DateTime> control;

  @override
  Widget build(BuildContext context) {
    return ReactiveValueListenableBuilder<DateTime>(
      formControl: control,
      builder: (context, currentControl, child) {
        final date = currentControl.value;
        final formatted = date == null
            ? 'اختر تاريخ الميلاد'
            : _formatDate(date);

        return InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () async {
            final now = DateTime.now();
            final pickedDate = await showDatePicker(
              context: context,
              initialDate: date ?? DateTime(now.year - 20),
              firstDate: DateTime(1940),
              lastDate: now,
            );

            if (pickedDate != null) {
              currentControl.updateValue(pickedDate);
              currentControl.markAsTouched();
            }
          },
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: 'المواليد',
              prefixIcon: const Icon(Icons.cake_outlined),
              errorText: currentControl.invalid && currentControl.touched
                  ? 'تاريخ الميلاد مطلوب'
                  : null,
            ),
            child: Text(formatted),
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year/$month/$day';
  }
}
