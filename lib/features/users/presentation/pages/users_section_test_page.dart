import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../application/users_passed_sections_controller.dart';
import '../users_navigation.dart';

final usersSectionTestFormProvider =
    Provider.autoDispose.family<FormGroup, String>((ref, sectionTitle) {
      return FormGroup({
        for (var index = 0; index < _questions.length; index++)
          'question_$index': FormControl<int>(
            validators: [Validators.required],
          ),
      });
    });

class UsersSectionTestPage extends ConsumerWidget {
  const UsersSectionTestPage({
    super.key,
    required this.sectionTitle,
  });

  final String sectionTitle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final form = ref.watch(usersSectionTestFormProvider(sectionTitle));

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        title: const Text('تقديم اختبار'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              scheme.primaryContainer.withValues(alpha: 0.56),
              Theme.of(context).scaffoldBackgroundColor,
            ],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: [
            ReactiveForm(
              formGroup: form,
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: scheme.surface.withValues(alpha: 0.96),
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(color: scheme.outlineVariant),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          sectionTitle,
                          style: textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'أجب عن الأسئلة التالية ثم اضغط على زر التقديم لعرض النتيجة.',
                          style: textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...List.generate(
                    _questions.length,
                    (index) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _QuestionCard(
                        number: index + 1,
                        question: _questions[index],
                        control:
                            form.control('question_$index') as FormControl<int>,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () => _submit(context, ref, form),
                      child: const Text('تقديم'),
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

  Future<void> _submit(
    BuildContext context,
    WidgetRef ref,
    FormGroup form,
  ) async {
    if (form.invalid) {
      form.markAllAsTouched();
      return;
    }

    var score = 0;
    for (var index = 0; index < _questions.length; index++) {
      final answer = (form.control('question_$index').value as int?) ?? -1;
      if (answer == _questions[index].correctIndex) {
        score++;
      }
    }

    ref.read(usersPassedSectionsProvider.notifier).markSectionAsPassed(
          sectionTitle: sectionTitle,
          score: score,
          totalQuestions: _questions.length,
        );

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('النتيجة'),
          content: Text('علامتك هي $score / ${_questions.length}'),
          actions: [
            FilledButton(
              onPressed: () {
                ref.read(userBottomNavProvider.notifier).setIndex(0);
                Navigator.of(dialogContext).pop();
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: const Text('موافق'),
            ),
          ],
        );
      },
    );
  }
}

class _QuestionCard extends StatelessWidget {
  const _QuestionCard({
    required this.number,
    required this.question,
    required this.control,
  });

  final int number;
  final _TestQuestion question;
  final FormControl<int> control;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: scheme.surface.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: ReactiveValueListenableBuilder<int>(
        formControl: control,
        builder: (context, _, __) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$number. ${question.title}',
                style: textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              ...List.generate(
                question.answers.length,
                (index) => RadioListTile<int>(
                  value: index,
                  groupValue: control.value,
                  onChanged: (value) {
                    control.value = value;
                    control.markAsTouched();
                  },
                  contentPadding: EdgeInsets.zero,
                  title: Text(question.answers[index]),
                ),
              ),
              if (control.invalid && control.touched)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    'اختر إجابة واحدة',
                    style: textTheme.bodySmall?.copyWith(
                      color: scheme.error,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _TestQuestion {
  const _TestQuestion({
    required this.title,
    required this.answers,
    required this.correctIndex,
  });

  final String title;
  final List<String> answers;
  final int correctIndex;
}

const _questions = <_TestQuestion>[
  _TestQuestion(
    title: 'ما الهدف الأساسي من توثيق العمل الفني؟',
    answers: ['إثبات الأصالة', 'تغيير الألوان', 'زيادة الحجم'],
    correctIndex: 0,
  ),
  _TestQuestion(
    title: 'أي عنصر يعد مهماً في تقييم العمل الفني؟',
    answers: ['الخامة المستخدمة', 'سرعة الإنترنت', 'نوع الهاتف'],
    correctIndex: 0,
  ),
  _TestQuestion(
    title: 'ماذا يساعد على حفظ تفاصيل القطعة الفنية؟',
    answers: ['التوثيق الجيد', 'إخفاء المعلومات', 'إلغاء الصور'],
    correctIndex: 0,
  ),
  _TestQuestion(
    title: 'أي خيار يرتبط بعرض الأعمال للمستخدمين؟',
    answers: ['المعارض', 'الطباعة العشوائية', 'إغلاق الصفحة'],
    correctIndex: 0,
  ),
  _TestQuestion(
    title: 'الفن الرقمي يعتمد غالباً على:',
    answers: ['الأدوات التقنية', 'الورق فقط', 'الخشب فقط'],
    correctIndex: 0,
  ),
  _TestQuestion(
    title: 'ما الفائدة من وجود أقسام داخل التطبيق؟',
    answers: ['تنظيم المحتوى', 'إخفاء الأعمال', 'تعطيل الوصول'],
    correctIndex: 0,
  ),
  _TestQuestion(
    title: 'عند عدم توفر محتوى في القسم يجب:',
    answers: ['إظهار رسالة واضحة', 'ترك الصفحة فارغة تماماً', 'إغلاق التطبيق'],
    correctIndex: 0,
  ),
  _TestQuestion(
    title: 'أي من التالي يعتبر محتوى داخل القسم؟',
    answers: ['منشورات وفعاليات', 'إعدادات النظام فقط', 'رسائل الخطأ فقط'],
    correctIndex: 0,
  ),
  _TestQuestion(
    title: 'الاختبار داخل القسم يفيد في:',
    answers: ['تقييم المستخدم', 'حذف الحساب', 'إخفاء التبويبات'],
    correctIndex: 0,
  ),
  _TestQuestion(
    title: 'بعد التقديم يجب أن يظهر للمستخدم:',
    answers: ['نتيجته النهائية', 'شاشة سوداء', 'لا شيء'],
    correctIndex: 0,
  ),
];
