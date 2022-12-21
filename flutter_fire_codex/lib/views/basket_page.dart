import 'package:flutter/material.dart';
import 'package:flutter_fire_codex/controllers/firebase_controller.dart';
import 'package:get/get.dart';

class BasketPage extends StatelessWidget {
  const BasketPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cart"),
        actions: [
          IconButton(
              onPressed: () {
                showMyItemDialog(context);
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: Obx(
        () => ListView.builder(
          itemCount: FirebaseConroller.instance.basketItems.length,
          itemBuilder: (context, index) {
            return ListTile(
              title:
                  Text(FirebaseConroller.instance.basketItems[index].product),
              // title: Text(basketItems[index].product),
              subtitle: Text(FirebaseConroller
                  .instance.basketItems[index].quantity
                  .toString()),
              // subtitle: Text(basketItems[index].quantity.toString()),
            );
          },
        ),
      ),
    );
  }

  showMyItemDialog(context) {
    var productController = TextEditingController();
    var quantityController = TextEditingController();
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Column(
              children: [
                TextField(
                  controller: productController,
                ),
                TextField(
                  controller: quantityController,
                ),
                TextButton(
                    onPressed: () {
                      var prod = productController.text.trim();
                      var quant = quantityController.text.trim();
                      FirebaseConroller.instance
                          .addItem(prod, int.parse(quant));
                    },
                    child: const Text("Add"))
              ],
            ),
          );
        });
  }
}
