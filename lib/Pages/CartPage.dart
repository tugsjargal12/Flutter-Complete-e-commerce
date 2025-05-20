import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  final List<Map<String, String>> cart;
  const CartPage({required this.cart});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late List<Map<String, String>> cartItems;

  @override
  void initState() {
    super.initState();
    cartItems = List.from(widget.cart);
  }

  // jishee vne
  int getTotalPrice() {
    return cartItems.length * 10000;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Сагс'),
      ),
      body: cartItems.isEmpty
          ? Center(child: Text('Сагс хоосон байна'))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final product = cartItems[index];
                      return ListTile(
                        leading: Image.asset(product["image"]!,
                            width: 48, height: 48),
                        title: Text(product["title"]!),
                        subtitle: Text(product["desc"]!),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              cartItems.removeAt(index);
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
                Divider(),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Нийт:',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          Text('${getTotalPrice()}₮',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: cartItems.isEmpty
                              ? null
                              : () async {
                                  // 1. Хүргэлтийн мэдээлэл авах
                                  final deliveryResult =
                                      await showDialog<Map<String, String>>(
                                    context: context,
                                    builder: (context) {
                                      final _formKey = GlobalKey<FormState>();
                                      String address = '';
                                      String phone = '';
                                      return AlertDialog(
                                        title: Text('Хүргэлтийн мэдээлэл'),
                                        content: Form(
                                          key: _formKey,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              TextFormField(
                                                decoration: InputDecoration(
                                                    labelText:
                                                        'Хүргэлтийн хаяг'),
                                                validator: (v) =>
                                                    v == null || v.isEmpty
                                                        ? 'Хаяг оруулна уу'
                                                        : null,
                                                onSaved: (v) =>
                                                    address = v ?? '',
                                              ),
                                              TextFormField(
                                                decoration: InputDecoration(
                                                    labelText: 'Утасны дугаар'),
                                                keyboardType:
                                                    TextInputType.phone,
                                                validator: (v) => v == null ||
                                                        v.length < 6
                                                    ? 'Утасны дугаар оруулна уу'
                                                    : null,
                                                onSaved: (v) => phone = v ?? '',
                                              ),
                                            ],
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, null),
                                            child: Text('Цуцлах'),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                _formKey.currentState!.save();
                                                Navigator.pop(context, {
                                                  'address': address,
                                                  'phone': phone
                                                });
                                              }
                                            },
                                            child: Text('Дараах'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                  if (deliveryResult == null) return;

                                  // 2. Картын мэдээлэл авах dialog
                                  final cardResult =
                                      await showDialog<Map<String, String>>(
                                    context: context,
                                    builder: (context) {
                                      final _formKey = GlobalKey<FormState>();
                                      String cardNumber = '';
                                      String cardName = '';
                                      String cardExpiry = '';
                                      String cardCvv = '';
                                      return AlertDialog(
                                        title: Text('Картын мэдээлэл'),
                                        content: Form(
                                          key: _formKey,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              TextFormField(
                                                decoration: InputDecoration(
                                                    labelText: 'Картын дугаар'),
                                                keyboardType:
                                                    TextInputType.number,
                                                maxLength: 16,
                                                validator: (v) => v == null ||
                                                        v.length != 16
                                                    ? '16 оронтой дугаар оруулна уу'
                                                    : null,
                                                onSaved: (v) =>
                                                    cardNumber = v ?? '',
                                              ),
                                              TextFormField(
                                                decoration: InputDecoration(
                                                    labelText:
                                                        'Карт эзэмшигчийн нэр'),
                                                validator: (v) =>
                                                    v == null || v.isEmpty
                                                        ? 'Нэр оруулна уу'
                                                        : null,
                                                onSaved: (v) =>
                                                    cardName = v ?? '',
                                              ),
                                              TextFormField(
                                                decoration: InputDecoration(
                                                    labelText:
                                                        'Дуусах хугацаа (MM/YY)'),
                                                maxLength: 5,
                                                validator: (v) => v == null ||
                                                        !RegExp(r'^\d{2}/\d{2}$')
                                                            .hasMatch(v)
                                                    ? 'MM/YY хэлбэрээр'
                                                    : null,
                                                onSaved: (v) =>
                                                    cardExpiry = v ?? '',
                                              ),
                                              TextFormField(
                                                decoration: InputDecoration(
                                                    labelText: 'CVV'),
                                                maxLength: 3,
                                                keyboardType:
                                                    TextInputType.number,
                                                validator: (v) =>
                                                    v == null || v.length != 3
                                                        ? '3 оронтой CVV'
                                                        : null,
                                                onSaved: (v) =>
                                                    cardCvv = v ?? '',
                                              ),
                                            ],
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, null),
                                            child: Text('Цуцлах'),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                _formKey.currentState!.save();
                                                Navigator.pop(context, {
                                                  'cardNumber': cardNumber,
                                                  'cardName': cardName,
                                                  'cardExpiry': cardExpiry,
                                                  'cardCvv': cardCvv,
                                                });
                                              }
                                            },
                                            child: Text('Төлбөр төлөх'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                  if (cardResult == null) return;

                                  // 3. Захиалгын мэдээллийг BottomSheet дээр харуулах
                                  if (mounted) {
                                    setState(() {
                                      cartItems.clear();
                                    });
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(24)),
                                      ),
                                      builder: (context) => Padding(
                                        padding: const EdgeInsets.all(24.0),
                                        child: SingleChildScrollView(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(Icons.check_circle,
                                                  color: Colors.green,
                                                  size: 64),
                                              SizedBox(height: 12),
                                              Text('Захиалга амжилттай!',
                                                  style: TextStyle(
                                                      fontSize: 22,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              SizedBox(height: 16),
                                              Text(
                                                  'Хүргэлтийн хаяг: ${deliveryResult['address']}'),
                                              Text(
                                                  'Утас: ${deliveryResult['phone']}'),
                                              Divider(),
                                              Text('Захиалсан бараа:',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              ...widget.cart
                                                  .map((item) => Text(
                                                      '- ${item["title"]}'))
                                                  .toList(),
                                              Divider(),
                                              Text(
                                                  'Нийт төлбөр: ${getTotalPrice()}₮',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              SizedBox(height: 16),
                                              ElevatedButton(
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                child: Text('OK'),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                },
                          child: Text('Төлбөр төлөх'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
