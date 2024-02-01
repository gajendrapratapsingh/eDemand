import 'package:e_demand/app/generalImports.dart';
import 'package:quick_actions/quick_actions.dart';

class AppQuickActions {
  final QuickActions quickActions = const QuickActions();

  static void initAppQuickActions() {
    //

    AppQuickActions().quickActions.initialize((final String shortcutType) {
      if (shortcutType == 'explore') {
        bottomNavigationBarGlobalKey.currentState?.selectedIndexOfBottomNavigationBar.value = 0;
      } else if (shortcutType == 'booking') {
        bottomNavigationBarGlobalKey.currentState?.selectedIndexOfBottomNavigationBar.value = 1;
      } else if (shortcutType == 'category') {
        bottomNavigationBarGlobalKey.currentState?.selectedIndexOfBottomNavigationBar.value = 2;
      } else {
        bottomNavigationBarGlobalKey.currentState?.selectedIndexOfBottomNavigationBar.value = 3;
      }
    });
    //
  }

  static void createAppQuickActions() {
    //
    //
    AppQuickActions().quickActions.setShortcutItems(<ShortcutItem>[
      const ShortcutItem(type: 'profile', localizedTitle: 'Profile', icon: 'profile'),
      const ShortcutItem(type: 'category', localizedTitle: 'Category', icon: 'category'),
      const ShortcutItem(type: 'booking', localizedTitle: 'Booking', icon: 'booking'),
      const ShortcutItem(type: 'explore', localizedTitle: 'Explore', icon: 'explore'),
    ]);
  }
}
