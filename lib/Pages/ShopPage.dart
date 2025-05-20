import 'package:animate_do/animate_do.dart';
import 'package:day16_shopping/Pages/CategoryPage.dart';
import 'package:day16_shopping/Pages/CartPage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'LoginPage.dart';

class ShopPage extends StatefulWidget {
  @override
  _ShopPageState createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  String? userInfo;
  List<Map<String, String>> cart = []; // Сагсны бүтээгдэхүүнүүд

  @override
  void initState() {
    super.initState();
    loadUserInfo();
  }

  Future<void> loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final phone = prefs.getString('phone');
    final email = prefs.getString('email');
    setState(() {
      userInfo = email ?? phone ?? "Мэдээлэл олдсонгүй";
    });
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
      (route) => false,
    );
  }

  void showProfileSheet() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.account_circle, size: 64, color: Colors.black54),
            SizedBox(height: 12),
            Text(
              "Хэрэглэгчийн мэдээлэл",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(height: 12),
            Text(
              userInfo ?? "",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: logout,
              icon: Icon(Icons.logout),
              label: Text("Гарах"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Жишээ бүтээгдэхүүний жагсаалт
  final List<Map<String, String>> products = [
    {
      "image": "assets/images/beauty.jpg",
      "title": "Гоо сайхны тос",
      "desc": "Арьс арчилгааны бүтээгдэхүүн"
    },
    {
      "image": "assets/images/clothes.jpg",
      "title": "Зуны даашинз",
      "desc": "Загварлаг, хөнгөн материал"
    },
    {
      "image": "assets/images/perfume.jpg",
      "title": "Үнэртэй ус",
      "desc": "Шинэхэн үнэртэй ус"
    },
    {
      "image": "assets/images/glass.jpg",
      "title": "Нүдний шил",
      "desc": "UV хамгаалалттай шил"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.black87, size: 28),
            onPressed: () {
              showSearch(
                context: context,
                delegate: ProductSearchDelegate(products),
              );
            },
            tooltip: "Хайх",
          ),
          IconButton(
            icon: Icon(Icons.account_circle, color: Colors.black87, size: 32),
            onPressed: showProfileSheet,
            tooltip: "Профайл",
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            FadeInUp(
                duration: Duration(milliseconds: 1000),
                child: Container(
                  height: 500,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/background.jpg'),
                          fit: BoxFit.cover)),
                  child: Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.bottomRight,
                            colors: [
                          Colors.black.withOpacity(.8),
                          Colors.black.withOpacity(.2),
                        ])),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 50.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              FadeInUp(
                                  duration: Duration(milliseconds: 1200),
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.favorite,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {},
                                  )),
                              FadeInUp(
                                  duration: Duration(milliseconds: 1300),
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.shopping_cart,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              CartPage(cart: cart),
                                        ),
                                      );
                                    },
                                  )),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                FadeInUp(
                                    duration: Duration(milliseconds: 1500),
                                    child: Text(
                                      "Манай шинэ бүтээгдэхүүнүүд",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold),
                                    )),
                                SizedBox(
                                  height: 15,
                                ),
                                FadeInUp(
                                    duration: Duration(milliseconds: 1700),
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                          "Дэлгэрэнгүй харах",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Icon(
                                          Icons.arrow_forward_ios,
                                          color: Colors.white,
                                          size: 15,
                                        )
                                      ],
                                    ))
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
            // --- Бүтээгдэхүүнүүдийн жагсаалт ---
            FadeInUp(
              duration: Duration(milliseconds: 1200),
              child: Container(
                padding: EdgeInsets.all(20),
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Бүтээгдэхүүнүүд",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 16),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return Card(
                          margin: EdgeInsets.only(bottom: 16),
                          child: ListTile(
                            leading: Image.asset(
                              product["image"]!,
                              width: 56,
                              height: 56,
                              fit: BoxFit.cover,
                            ),
                            title: Text(product["title"]!),
                            subtitle: Text(product["desc"]!),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.add_shopping_cart,
                                      color: Colors.green),
                                  onPressed: () {
                                    setState(() {
                                      cart.add(product);
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text('Сагсанд нэмэгдлээ')),
                                    );
                                  },
                                ),
                                Icon(Icons.arrow_forward_ios, size: 16),
                              ],
                            ),
                            onTap: () {
                              // Дэлгэрэнгүй хуудас руу үсрэх логик энд бичиж болно
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            // --- Ангилал болон бусад хэсгүүд хуучнаараа ---
            FadeInUp(
                duration: Duration(milliseconds: 1400),
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Ангилал",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          Text("Бүгд")
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 150,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: <Widget>[
                            makeCategory(
                                image: 'assets/images/beauty.jpg',
                                title: 'Гоо сайхан',
                                tag: 'beauty'),
                            makeCategory(
                                image: 'assets/images/clothes.jpg',
                                title: 'Хувцас',
                                tag: 'clothes'),
                            makeCategory(
                                image: 'assets/images/perfume.jpg',
                                title: 'Үнэртэй ус',
                                tag: 'perfume'),
                            makeCategory(
                                image: 'assets/images/glass.jpg',
                                title: 'Нүдний шил',
                                tag: 'glass'),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Ангиллаар хамгийн их борлуулалттай",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          Text("Бүгд")
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 150,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: <Widget>[
                            makeBestCategory(
                                image: 'assets/images/tech.jpg',
                                title: 'Технологи'),
                            makeBestCategory(
                                image: 'assets/images/watch.jpg', title: 'Цаг'),
                            makeBestCategory(
                                image: 'assets/images/perfume.jpg',
                                title: 'Үнэртэй ус'),
                            makeBestCategory(
                                image: 'assets/images/glass.jpg',
                                title: 'Нүдний шил'),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 80,
                      ),
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }

  Widget makeCategory({image, title, tag}) {
    return AspectRatio(
      aspectRatio: 2 / 2.2,
      child: Hero(
        tag: tag,
        child: GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CategoryPage(
                          image: image,
                          title: title,
                          tag: tag,
                        )));
          },
          child: Material(
            child: Container(
              margin: EdgeInsets.only(right: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                      image: AssetImage(image), fit: BoxFit.cover)),
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient:
                        LinearGradient(begin: Alignment.bottomRight, colors: [
                      Colors.black.withOpacity(.8),
                      Colors.black.withOpacity(.0),
                    ])),
                child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      title,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    )),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget makeBestCategory({image, title}) {
    return AspectRatio(
      aspectRatio: 3 / 2.2,
      child: Container(
        margin: EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image:
                DecorationImage(image: AssetImage(image), fit: BoxFit.cover)),
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(begin: Alignment.bottomRight, colors: [
                Colors.black.withOpacity(.8),
                Colors.black.withOpacity(.0),
              ])),
          child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                title,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              )),
        ),
      ),
    );
  }
}

// --- Search Delegate ---
class ProductSearchDelegate extends SearchDelegate {
  final List<Map<String, String>> products;
  ProductSearchDelegate(this.products);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () => query = '',
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = products
        .where((p) =>
            p["title"]!.toLowerCase().contains(query.toLowerCase()) ||
            p["desc"]!.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final product = results[index];
        return ListTile(
          leading: Image.asset(product["image"]!, width: 48, height: 48),
          title: Text(product["title"]!),
          subtitle: Text(product["desc"]!),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = products
        .where((p) =>
            p["title"]!.toLowerCase().contains(query.toLowerCase()) ||
            p["desc"]!.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final product = suggestions[index];
        return ListTile(
          leading: Image.asset(product["image"]!, width: 48, height: 48),
          title: Text(product["title"]!),
          subtitle: Text(product["desc"]!),
          onTap: () {
            query = product["title"]!;
            showResults(context);
          },
        );
      },
    );
  }
}
