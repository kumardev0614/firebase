import 'dart:convert';

Item itemFromJson(String str) => Item.fromJson(json.decode(str));

String itemToJson(Item data) => json.encode(data.toJson());

class Item {
  Item({
    required this.id,
    required this.product,
    required this.quantity,
  });

  String id;
  String product;
  int quantity;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        id: json["id"],
        product: json["product"],
        quantity: json["quantity"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "product": product,
        "quantity": quantity,
      };
}
