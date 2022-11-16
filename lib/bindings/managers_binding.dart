import 'package:get/get.dart';
import 'package:my_anime_stream/helpers/favoriteManager.dart';

import '../helpers/media_quality_manager.dart';

import '../helpers/webview_manager.dart';

/// [ManagerBinding] registers all domain specific controllers used across the
/// whole app. All dependencies are registered using the GetX state management
/// (more about the state management here: https://pub.dev/packages/get ).
class ManagerBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(WebViewManager());
    Get.lazyPut(() => FavoriteManager());
  }
}
