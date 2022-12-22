import 'package:flutter/material.dart';
import 'package:flutter_fire_codex/controllers/firebase_controller.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

class BasketPage extends StatelessWidget {
  const BasketPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Items"),
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
            return Slidable(
              endActionPane: ActionPane(
                motion: const ScrollMotion(),
                children: [
                  SlidableAction(
                    onPressed: (context) {
                      FirebaseConroller.instance.deleteItem(
                          FirebaseConroller.instance.basketItems[index].id);
                    },
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    icon: Icons.delete,
                    label: "Remove",
                    spacing: 8,
                  )
                ],
              ),
              child: ListTile(
                title:
                    Text(FirebaseConroller.instance.basketItems[index].product),
                // title: Text(basketItems[index].product),
                subtitle: Text(FirebaseConroller
                    .instance.basketItems[index].quantity
                    .toString()),
                // subtitle: Text(basketItems[index].quantity.toString()),
              ),
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
            insetPadding: const EdgeInsets.all(50.0),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  const Text("Item Details"),
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
                        Navigator.pop(context);
                      },
                      child: const Text("Add"))
                ],
              ),
            ),
          );
        });
  }
}
