import 'package:flutter/material.dart';

import 'users_section_test_page.dart';

class UsersSectionPage extends StatelessWidget {
  const UsersSectionPage({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.colors,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          scrolledUnderElevation: 0,
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          title: Text(title),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                scheme.primaryContainer.withValues(alpha: 0.64),
                Theme.of(context).scaffoldBackgroundColor,
              ],
            ),
          ),
          child: SafeArea(
            top: false,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final horizontalPadding = constraints.maxWidth >= 1100
                    ? 36.0
                    : (constraints.maxWidth >= 720 ? 28.0 : 20.0);
                final contentWidth = constraints.maxWidth >= 1440
                    ? 1280.0
                    : (constraints.maxWidth >= 1100
                        ? 1120.0
                        : constraints.maxWidth);

                return Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: contentWidth),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        horizontalPadding,
                        8,
                        horizontalPadding,
                        24,
                      ),
                      child: Column(
                        children: [
                          _SectionCover(
                            title: title,
                            icon: icon,
                            colors: colors,
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton.icon(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute<void>(
                                    builder: (_) =>
                                        UsersSectionTestPage(sectionTitle: title),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.fact_check_outlined),
                              label: const Text('تقديم اختبار'),
                            ),
                          ),
                          const SizedBox(height: 16),
                          _SectionTabs(colors: colors),
                          const SizedBox(height: 14),
                          Expanded(
                            child: TabBarView(
                              children: [
                                _SectionTabView(
                                  title: 'فيديوهات',
                                  emptyText:
                                      'لا توجد فيديوهات في هذا القسم حالياً',
                                  icon: Icons.play_circle_outline_rounded,
                                ),
                                _SectionTabView(
                                  title: 'منشورات',
                                  emptyText:
                                      'لا توجد منشورات في هذا القسم حالياً',
                                  icon: Icons.article_outlined,
                                ),
                                _SectionTabView(
                                  title: 'فعاليات',
                                  emptyText:
                                      'لا توجد فعاليات في هذا القسم حالياً',
                                  icon: Icons.event_available_outlined,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionCover extends StatelessWidget {
  const _SectionCover({
    required this.title,
    required this.icon,
    required this.colors,
  });

  final String title;
  final IconData icon;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    final onBrandColor = Theme.of(context).colorScheme.onPrimary;

    return AspectRatio(
      aspectRatio: 16 / 8.5,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: colors,
          ),
          boxShadow: [
            BoxShadow(
              color: colors.last.withValues(alpha: 0.18),
              blurRadius: 28,
              offset: const Offset(0, 16),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              top: -24,
              right: -10,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: onBrandColor.withValues(alpha: 0.10),
                  ),
                ),
              ),
            Positioned(
              left: -18,
              bottom: -28,
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: onBrandColor.withValues(alpha: 0.08),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: onBrandColor,
                          fontWeight: FontWeight.w700,
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

class _SectionTabs extends StatelessWidget {
  const _SectionTabs({
    required this.colors,
  });

  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: scheme.surface.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: TabBar(
        dividerColor: Colors.transparent,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: colors,
          ),
          borderRadius: BorderRadius.circular(18),
        ),
        labelColor: scheme.onPrimary,
        unselectedLabelColor: scheme.primary,
        tabs: const [
          Tab(text: 'فيديوهات'),
          Tab(text: 'منشورات'),
          Tab(text: 'فعاليات'),
        ],
      ),
    );
  }
}

class _SectionTabView extends StatelessWidget {
  const _SectionTabView({
    required this.title,
    required this.emptyText,
    required this.icon,
  });

  final String title;
  final String emptyText;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return ListView(
      padding: EdgeInsets.zero,
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
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: scheme.primaryContainer.withValues(alpha: 0.28),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: scheme.primary,
                  size: 32,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                title,
                style: textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                emptyText,
                style: textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
