import 'package:flutter/material.dart';

import '../../../shared/widgets/dashboard_shell.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const DashboardShell(
      roleLabel: 'لوحة المسؤول',
      title: 'إدارة تطبيق أصالة الفنون',
      subtitle:
          'هذه الصفحة مخصصة للمسؤول لإدارة المستخدمين، مراجعة المحتوى، ومتابعة الجوانب الإدارية داخل التطبيق.',
      features: [
        DashboardFeature(
          icon: Icons.people_alt_outlined,
          title: 'إدارة المستخدمين',
          description: 'عرض الحسابات وتنظيم الصلاحيات ومتابعة حالة الوصول.',
        ),
        DashboardFeature(
          icon: Icons.collections_bookmark_outlined,
          title: 'إدارة الأعمال الفنية',
          description: 'إضافة الأعمال أو تعديلها وربطها ببيانات التوثيق.',
        ),
        DashboardFeature(
          icon: Icons.analytics_outlined,
          title: 'تقارير ومتابعة',
          description: 'واجهة جاهزة لتوسعة الإحصائيات والتقارير لاحقاً.',
        ),
      ],
    );
  }
}
