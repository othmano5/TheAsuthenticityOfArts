import 'package:flutter/material.dart';

import '../../../../core/layout/app_breakpoints.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/users_category_card.dart';
import '../widgets/users_page_container.dart';
import 'users_section_page.dart';

class UsersCategoriesPage extends StatelessWidget {
  const UsersCategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return UsersPageContainer(
      child: _UsersCategoriesGrid(items: _sections),
    );
  }
}

class _UsersCategoriesGrid extends StatelessWidget {
  const _UsersCategoriesGrid({
    required this.items,
  });

  final List<_UsersSectionItem> items;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final itemWidth = AppBreakpoints.isDesktopWidth(width)
        ? 320.0
        : (AppBreakpoints.isTabletWidth(width) ? 280.0 : double.infinity);

    return Wrap(
      spacing: 18,
      runSpacing: 18,
      children: items
          .map(
            (item) => SizedBox(
              width: itemWidth,
              child: UsersCategoryCard(
                title: item.title,
                colors: item.colors,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => UsersSectionPage(
                        title: item.title,
                        subtitle: item.subtitle,
                        icon: item.icon,
                        colors: item.colors,
                      ),
                    ),
                  );
                },
              ),
            ),
          )
          .toList(),
    );
  }
}

class _UsersSectionItem {
  const _UsersSectionItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.colors,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> colors;
}

const _sections = <_UsersSectionItem>[
  _UsersSectionItem(
    title: 'اللوحات',
    subtitle: 'أعمال فنية كلاسيكية ومعاصرة بأساليب متنوعة.',
    icon: Icons.brush_outlined,
    colors: AppColors.sectionPaintings,
  ),
  _UsersSectionItem(
    title: 'المنحوتات',
    subtitle: 'قطع فنية ثلاثية الأبعاد ومقتنيات مختارة.',
    icon: Icons.architecture_outlined,
    colors: AppColors.sectionSculptures,
  ),
  _UsersSectionItem(
    title: 'المعارض',
    subtitle: 'تعرف على المعارض والفعاليات المرتبطة بالفنون.',
    icon: Icons.collections_outlined,
    colors: AppColors.sectionExhibitions,
  ),
  _UsersSectionItem(
    title: 'الفن الرقمي',
    subtitle: 'أعمال حديثة بهوية بصرية معاصرة ومميزة.',
    icon: Icons.auto_awesome_motion_outlined,
    colors: AppColors.sectionDigitalArt,
  ),
  _UsersSectionItem(
    title: 'خدمات التوثيق',
    subtitle: 'متابعة الأصالة والتحقق والخدمات المرافقة للعمل.',
    icon: Icons.workspace_premium_outlined,
    colors: AppColors.sectionDocumentation,
  ),
  _UsersSectionItem(
    title: 'مقتنيات خاصة',
    subtitle: 'مجموعات منتقاة ضمن تجربة عرض مرتبة وسريعة.',
    icon: Icons.grid_view_rounded,
    colors: AppColors.sectionSpecialCollections,
  ),
];
