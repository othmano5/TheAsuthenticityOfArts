import 'package:flutter/material.dart';

class UsersHomeFeed extends StatelessWidget {
  const UsersHomeFeed({
    super.key,
    required this.items,
  });

  final List<UsersFeedItem> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const _UsersEmptyFeedCard();
    }

    return Column(
      children: items
          .map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _UsersFeedPostCard(item: item),
            ),
          )
          .toList(),
    );
  }
}

class UsersFeedItem {
  const UsersFeedItem({
    required this.title,
    required this.content,
    required this.meta,
    required this.typeLabel,
    required this.icon,
  });

  final String title;
  final String content;
  final String meta;
  final String typeLabel;
  final IconData icon;
}

class _UsersFeedPostCard extends StatelessWidget {
  const _UsersFeedPostCard({
    required this.item,
  });

  final UsersFeedItem item;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: scheme.surface.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: scheme.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: scheme.shadow.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [scheme.secondary, scheme.primary],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(item.icon, color: scheme.onPrimary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.title, style: textTheme.titleMedium),
                    const SizedBox(height: 2),
                    Text(item.meta, style: textTheme.bodySmall),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: scheme.primaryContainer.withValues(alpha: 0.82),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  item.typeLabel,
                  style: textTheme.labelLarge?.copyWith(color: scheme.primary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            item.content,
            style: textTheme.bodyLarge?.copyWith(height: 1.55),
          ),
        ],
      ),
    );
  }
}

class _UsersEmptyFeedCard extends StatelessWidget {
  const _UsersEmptyFeedCard();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: scheme.surface.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  scheme.secondary.withValues(alpha: 0.18),
                  scheme.primary.withValues(alpha: 0.14),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.feed_outlined,
              color: scheme.primary,
              size: 32,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'لا يوجد شيء لعرضه',
            style: textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'عند إضافة منشورات أو فعاليات جديدة ستظهر هنا ضمن فيد واحد قابل للتمرير.',
            style: textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
