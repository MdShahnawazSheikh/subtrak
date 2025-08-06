import 'package:get/get.dart';
import '../controllers/bill_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(BillController(), permanent: true);
  }
}
