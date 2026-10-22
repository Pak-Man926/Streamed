import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AppNavTab {
  home,
  live,
  schedule,
}

class NavigationNotifier extends StateNotifier<AppNavTab> {
  NavigationNotifier() : super(AppNavTab.home);

  void setTab(AppNavTab tab) {
    state = tab;
  }
}

final navigationProvider =
    StateNotifierProvider<NavigationNotifier, AppNavTab>((ref) {
  return NavigationNotifier();
});
