import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/users_passed_sections_controller.dart';
import '../widgets/users_page_container.dart';
import '../widgets/users_profile_info_tile.dart';

class UsersProfilePage extends ConsumerWidget {
  const UsersProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final passedSections = ref.watch(usersPassedSectionsProvider);

    return UsersPageContainer(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: scheme.surface.withValues(alpha: 0.95),
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: scheme.outlineVariant),
          boxShadow: [
            BoxShadow(
              color: scheme.shadow.withValues(alpha: 0.04),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 92,
              height: 92,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [scheme.secondary, scheme.primary],
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.person_rounded,
                size: 42,
                color: scheme.onPrimary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'مستخدم أصالة الفنون',
              style: textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'يمكن ربط هذه البيانات لاحقاً مع بيانات الخادم وواجهة PHP بسهولة.',
              style: textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            const UsersProfileInfoTile(
              icon: Icons.phone_outlined,
              title: 'رقم الهاتف',
              value: '+963 9XX XXX XXX',
            ),
            const SizedBox(height: 12),
            const UsersProfileInfoTile(
              icon: Icons.location_on_outlined,
              title: 'العنوان',
              value: 'دمشق - سوريا',
            ),
            const SizedBox(height: 12),
            const UsersProfileInfoTile(
              icon: Icons.cake_outlined,
              title: 'تاريخ الميلاد',
              value: '1998/05/12',
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton.tonalIcon(
                onPressed: () {},
                icon: const Icon(Icons.edit_outlined),
                label: const Text('تعديل المعلومات الشخصية'),
              ),
            ),
            const SizedBox(height: 24),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'الأقسام المجتازة بنسبة 60%+',
                style: textTheme.titleMedium,
              ),
            ),
            const SizedBox(height: 12),
            if (passedSections.isEmpty)
              _PassedSectionsEmptyState(
                scheme: scheme,
                textTheme: textTheme,
              ),
            if (passedSections.isNotEmpty)
              ...passedSections.map(
                (section) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _PassedSectionCard(section: section),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _PassedSectionsEmptyState extends StatelessWidget {
  const _PassedSectionsEmptyState({
    required this.scheme,
    required this.textTheme,
  });

  final ColorScheme scheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: scheme.primaryContainer.withValues(alpha: 0.20),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          Icon(
            Icons.workspace_premium_outlined,
            color: scheme.primary,
          ),
          const SizedBox(height: 10),
          Text(
            'لم يتم اجتياز أي قسم بعد',
            style: textTheme.titleSmall,
          ),
        ],
      ),
    );
  }
}

class _PassedSectionCard extends StatelessWidget {
  const _PassedSectionCard({
    required this.section,
  });

  final PassedSectionCertificate section;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: () => _handleTap(context),
        child: Ink(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: scheme.primaryContainer.withValues(alpha: 0.22),
            borderRadius: BorderRadius.circular(22),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: scheme.surface,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  Icons.picture_as_pdf_outlined,
                  color: scheme.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      section.sectionTitle,
                      style: textTheme.titleSmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'النتيجة ${section.score}/${section.totalQuestions} - ${section.percentage}%',
                      style: textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: scheme.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleTap(BuildContext context) async {
    if (section.certificatePdfPath == null || section.certificatePdfPath!.isEmpty) {
      await showDialog<void>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('الشهادة'),
            content: const Text('لا تتوفر حاليا شهادة'),
            actions: [
              FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('موافق'),
              ),
            ],
          );
        },
      );
      return;
    }
  }
}
