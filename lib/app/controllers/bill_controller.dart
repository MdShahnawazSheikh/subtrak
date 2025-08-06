import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../data/models/bill_model.dart';

class BillController extends GetxController {
  late Box<BillModel> _box;
  final RxList<BillModel> bills = <BillModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _box = Hive.box<BillModel>('bills');
    bills.assignAll(_box.values.toList());
  }

  void addBill(BillModel bill) {
    _box.put(bill.id, bill);
    bills.add(bill);
  }

  void removeBill(String id) {
    _box.delete(id);
    bills.removeWhere((b) => b.id == id);
  }

  List<BillModel> getUpcomingBills() {
    return bills
        .where(
          (b) => b.dueDate.isAfter(
            DateTime.now().subtract(const Duration(days: 1)),
          ),
        )
        .toList();
  }
}
