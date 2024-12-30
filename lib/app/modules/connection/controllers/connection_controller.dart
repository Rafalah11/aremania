import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:myapp/app/modules/connection/views/no_connection_view.dart';
import 'package:myapp/app/modules/home/views/home_view.dart';
import 'package:myapp/app/routes/app_pages.dart';

class ConnectionController extends GetxController {
  final Connectivity _connectivity = Connectivity();

  @override
  void onInit() {
    super.onInit();
    _checkInitialConnection(); // Check initial connectivity when app starts
    _connectivity.onConnectivityChanged.listen((connectivityResult) {
      updateConnectionStatus(connectivityResult.first);
    });
  }

  // This method checks the initial connectivity status when the app starts
  void _checkInitialConnection() async {
    final connectivityResult = await _connectivity.checkConnectivity();
    updateConnectionStatus(connectivityResult.first);
  }

  // This method handles updates based on the connectivity status
  void updateConnectionStatus(ConnectivityResult connectivityResult) {
    if (connectivityResult == ConnectivityResult.none) {
      if (Get.currentRoute != Routes.NO_CONNECTION) {
        Get.offAll(() => const NoConnectionView());
      }
    } else {
      if (Get.currentRoute == Routes.NO_CONNECTION) {
        Get.offAll(() => HomeScreen()); // Replace with your desired screen
      }
    }
  }
}
