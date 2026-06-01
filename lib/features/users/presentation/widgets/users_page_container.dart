import 'package:flutter/material.dart';

import '../../../../core/layout/app_breakpoints.dart';

class UsersPageContainer extends StatelessWidget {
  const UsersPageContainer({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final topInset = MediaQuery.paddingOf(context).top;
    final horizontalPadding = AppBreakpoints.horizontalPadding(width);
    final contentWidth = AppBreakpoints.contentWidth(width);

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        horizontalPadding,
        topInset + 30,
        horizontalPadding,
        120,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: contentWidth),
        child: child,
      ),
    );
  }
}
