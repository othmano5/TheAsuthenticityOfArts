import 'package:flutter/material.dart';

import '../widgets/users_feed_widgets.dart';
import '../widgets/users_page_container.dart';

const _homeFeedItems = <UsersFeedItem>[];

class UsersMainPage extends StatelessWidget {
  const UsersMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const UsersPageContainer(
      child: UsersHomeFeed(items: _homeFeedItems),
    );
  }
}
