import 'package:flutter_riverpod/flutter_riverpod.dart';

final userBottomNavProvider =
    NotifierProvider.autoDispose<_UserBottomNavController, int>(
      _UserBottomNavController.new,
    );

class _UserBottomNavController extends Notifier<int> {
  @override
  int build() => 0;

  void setIndex(int index) {
    state = index;
  }
}
