import 'package:flutter/material.dart';
import 'package:kanatin/models/cart_model.dart';

class CartProvider with ChangeNotifier {
  List<CartModel> _cart = [];
  List<CartModel> get cart => _cart;
  int _total = 0;
  int get total => _total;

  void addRemove(String name, int menuId, bool isAdd) {
    if (_cart.where((element) => menuId == element.menuId).isNotEmpty) {
      var index = _cart.indexWhere((element) => element.menuId == menuId);
      _cart[index].quantity = (isAdd)
          ? _cart[index].quantity + 1
          : (_cart[index].quantity > 0)
              ? _cart[index].quantity - 1
              : 0;

      _total = (isAdd)
          ? _total + 1
          : (_total > 0)
              ? _total - 1
              : 0;
    } else {
      //belum ada
      _cart.add(CartModel(name: name, menuId: menuId, quantity: 1));
      print('JUMLAH : ' + _cart.length.toString());
      _total = _total + 1;
    }
    notifyListeners();
  }
}
