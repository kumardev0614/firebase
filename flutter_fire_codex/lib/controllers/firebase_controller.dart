import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/basket.dart';

class FirebaseConroller extends GetxController {
  static FirebaseConroller instance = Get.find();

  var basketItems = <Item>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchRecords();
    FirebaseFirestore.instance
        .collection("basket_items")
        .snapshots()
        .listen((event) {
      mapRecords(event);
    });
  }

  fetchRecords() async {
    var records =
        await FirebaseFirestore.instance.collection("basket_items").get();

    mapRecords(records);
  }

  mapRecords(QuerySnapshot<Map<String, dynamic>> records) {
    var _list = records.docs
        .map((item) => Item(
            id: item.id, product: item["product"], quantity: item['quantity']))
        .toList();

    basketItems.value = _list;
  }

  addItem(String prod, int quant) {
    FirebaseFirestore.instance
        .collection("basket_items")
        .add({"product": prod, "quantity": quant});
  }
}
