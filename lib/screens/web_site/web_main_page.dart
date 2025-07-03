import 'package:eco_buy/screens/web_site/add_product_screen.dart';
import 'package:eco_buy/screens/web_site/dashboard_screen.dart';
import 'package:eco_buy/screens/web_site/del_product_screen.dart';
import 'package:eco_buy/screens/web_site/update_product_scren.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';

// ignore: must_be_immutable
class WebMainScreen extends StatefulWidget {
  static const String id = "webmain";
  const WebMainScreen({super.key});

  @override
  State<WebMainScreen> createState() => _WebMainScreenState();
}

class _WebMainScreenState extends State<WebMainScreen> {
  Widget slectedscreen = const DashboardScreen();

  chooseScreen(item) {
    switch (item) {
      case DashboardScreen.id:
        setState(() {
          slectedscreen = const DashboardScreen();
        });

        break;
      case AddProductScreen.id:
        setState(() {
          slectedscreen = AddProductScreen();
        });

        break;
      case UpdateProductScreen.id:
        setState(() {
          slectedscreen = UpdateProductScreen();
        });

        break;
      case DeleteProductScreen.id:
        setState(() {
          slectedscreen = const DeleteProductScreen();
        });

        break;

      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      appBar: AppBar(
        title: const Text("Admin Pannel"),
        backgroundColor: Colors.black,
      ),
      sideBar: SideBar(
        backgroundColor: Colors.black,
        textStyle: const TextStyle(
          color: Color.fromARGB(255, 255, 255, 255),
          fontSize: 16,
        ),
        onSelected: (item) {
          chooseScreen(item.route);
        },
        items: const [
          AdminMenuItem(
            title: "Dasboard",
            icon: Icons.dashboard,
            route: DashboardScreen.id,
          ),
          AdminMenuItem(
            title: "Add Product",
            icon: Icons.add,
            route: AddProductScreen.id,
          ),
          AdminMenuItem(
            title: "Update Product",
            icon: Icons.update,
            route: UpdateProductScreen.id,
          ),
          AdminMenuItem(
            title: "Delete Product",
            icon: Icons.delete,
            route: DeleteProductScreen.id,
          ),
          AdminMenuItem(
            title: "Cart Items",
            icon: Icons.shopping_cart,
          ),
        ],
        selectedRoute: WebMainScreen.id,
      ),
      body: slectedscreen,
    );
  }
}
