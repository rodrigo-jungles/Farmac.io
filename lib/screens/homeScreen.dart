import 'package:farmacio_app/controller/adressController.dart';
import 'package:farmacio_app/controller/authController.dart';
import 'package:farmacio_app/controller/productController.dart';
import 'package:farmacio_app/models/adressModel.dart';
import 'package:farmacio_app/models/productModel.dart';
import 'package:farmacio_app/models/userModel.dart';
import 'package:farmacio_app/screens/cartScreen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthController _authController = Get.put(AuthController());
  final Adresscontroller _adressController = Get.put(Adresscontroller());

  List<Product> _products = [];
  UserModel? _user;
  Future<Address?>? futurePrimaryAddress;
  int? userId;

  @override
  void initState() {
    super.initState();
    _loadUser();
    _loadProducts();
  }

  Future<void> _loadUser() async {
    try {
      _user = await _authController.getUserFromSession();

      if (_user == null) {
        print(
          "⚠️ Nenhum usuário carregado da sessão, redirecionando para login...",
        );
        Get.offAllNamed('/login');
        return;
      }

      setState(() {
        userId = _user?.id;
        futurePrimaryAddress = _adressController.getPrimaryAddress(userId!);
      });
    } catch (e) {
      print('❌ Erro ao carregar usuário: $e');
      Get.snackbar(
        'Erro',
        'Falha ao carregar usuário: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> _loadProducts() async {
    try {
      final productController = Get.put(ProductController());
      final products = await productController.getProducts();

      setState(() {
        _products = products;
      });

      print('✅ Produtos carregados: ${_products.length}');
    } catch (e) {
      print('❌ Erro ao carregar produtos: $e');
      Get.snackbar(
        'Erro',
        'Falha ao carregar produtos: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void _logout() {
    _authController.emailController.clear();
    _authController.passwordController.clear();
    _authController.clearSession();
    Get.offAllNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 189, 181, 183),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 172, 131, 77),
        title: Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Buscar Medicamento',
                  prefixIcon: const Icon(Icons.search, color: Colors.black54),
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 8),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            IconButton(
              icon: const Icon(Icons.shopping_cart, color: Colors.black),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CartScreen()),
                );
              },
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(_user?.name ?? 'Usuário'),
              accountEmail: Text(_user?.email ?? ''),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  (_user?.name != null && _user!.name.isNotEmpty)
                      ? _user!.name[0].toUpperCase()
                      : 'U',
                  style: const TextStyle(fontSize: 24, color: Colors.black),
                ),
              ),
            ),
            _buildDrawerItem(
              Icons.person,
              'Perfil',
              onTap: () => Get.toNamed('/profile'),
            ),
            _buildDrawerItem(
              Icons.history,
              'Meus Pedidos',
              onTap: () => Get.toNamed('/orders'),
            ),
            _buildDrawerItem(
              Icons.location_on,
              'Endereços',
              onTap: () => Get.toNamed('/enderecos'),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Sair'),
              onTap: _logout,
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<Address?>(
              future: futurePrimaryAddress,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(
                    height: 30,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                if (!snapshot.hasData || snapshot.data == null) {
                  return GestureDetector(
                    onTap: () {
                      Get.toNamed('/enderecos');
                    },
                    child: Row(
                      children: const [
                        Icon(Icons.location_on, color: Colors.black54),
                        SizedBox(width: 8),
                        Text(
                          "Definir endereço principal",
                          style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final address = snapshot.data!;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.green),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "${address.street}, ${address.number} - ${address.city}",
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 5),
            _buildCategoryIcons(),
            const SizedBox(height: 20),
            _buildPromotionsBanner(),
            const SizedBox(height: 20),
            _buildProductList(),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryIcons() {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: _categoryItems.length,
        itemBuilder: (context, index) {
          final category = _categoryItems[index];
          final sw = MediaQuery.of(context).size.width;
          // largura proporcional por item, com limites para manter proporção
          final double itemWidth = (sw * 0.22).clamp(88.0, 140.0);
          final double avatarRadius = (itemWidth * 0.28).clamp(24.0, 36.0);

          return SizedBox(
            width: itemWidth,
            child: Center(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(40),
                  onTap: () => _onCategoryTap(category),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: avatarRadius,
                        backgroundColor: Colors.grey.shade200,
                        child: category['isFa'] == true
                            ? FaIcon(
                                category['icon'],
                                size: avatarRadius * 0.9,
                                color: Colors.black,
                              )
                            : Icon(
                                category['icon'],
                                size: avatarRadius * 0.9,
                                color: Colors.black,
                              ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        category['label'],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // Handler chamado quando uma categoria é tocada.
  // Agora usa o campo 'route' definido em cada item para navegar.
  void _onCategoryTap(Map<String, dynamic> category) {
    final route = category['route']?.toString();
    final label = (category['label'] ?? '').toString();

    if (route != null && route.isNotEmpty) {
      try {
        Get.toNamed(route);
      } catch (e) {
        Get.snackbar(
          'Navegação',
          'Não foi possível navegar para $label ($route): $e',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } else {
      Get.snackbar(
        label,
        'Abrindo $label...',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  final List<Map<String, dynamic>> _categoryItems = [
    {'label': 'SintomaQI', 'icon': Icons.psychology, 'route': '/sintomaqi'},
    {
      'label': 'Remédios',
      'icon': FontAwesomeIcons.pills,
      'route': '/remedios',
      'isFa': true,
    },
    {
      'label': 'Outros Produtos',
      'icon': Icons.brush,
      'route': '/outros-produtos',
    },
    {'label': 'Farmácias', 'icon': Icons.local_hospital, 'route': '/farmacias'},
  ];

  Widget _buildPromotionsBanner() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 0, 0, 0),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.local_offer, color: Colors.white),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'OFERTAS DO DIA',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductList() {
    if (_products.isEmpty) {
      // Mostra uma grade simples de produtos a partir de assets/img_produtos quando
      // não há produtos carregados na lista (_products).
      const sample = [
        {'file': 'Pasta_dente.png', 'label': 'Pasta de Dente', 'price': '6.50'},
        {'file': 'Sabonete.png', 'label': 'Sabonete', 'price': '2.90'},
        {'file': 'shampoo.png', 'label': 'Shampoo', 'price': '12.00'},
      ];

      return SizedBox(
        height: 200,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: sample.length,
          separatorBuilder: (_, __) => const SizedBox(width: 12),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          itemBuilder: (context, index) {
            final it = sample[index];
            final path = 'assets/img_produtos/${it['file']}';
            return Container(
              width: 140,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(8),
                      ),
                      child: Image.asset(
                        path,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorBuilder: (c, e, s) => Image.asset(
                          'assets/product_placeholder.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          it['label'] ?? '',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'R\$ ${it['price']}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
    }

    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _products.length,
        itemBuilder: (context, index) {
          final product = _products[index];
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                '/product_details',
                arguments: product.toMap(),
              );
            },
            child: Container(
              width: 140,
              margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(8),
                      ),
                      child: Builder(
                        builder: (context) {
                          final image = product.imageUrl;
                          if (image.startsWith('http') ||
                              image.startsWith('https')) {
                            return Image.network(
                              image,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                              errorBuilder: (c, e, s) => Image.asset(
                                'assets/product_placeholder.png',
                                fit: BoxFit.cover,
                              ),
                            );
                          }

                          return Image.asset(
                            image,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                            errorBuilder: (c, e, s) => Image.asset(
                              'assets/product_placeholder.png',
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'R\$ ${product.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDrawerItem(
    IconData icon,
    String title, {
    bool hasNotification = false,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.black54),
      title: Row(
        children: [
          Text(title),
          if (hasNotification)
            Container(
              margin: const EdgeInsets.only(left: 8),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                '1',
                style: TextStyle(color: Colors.white, fontSize: 10),
              ),
            ),
        ],
      ),
      onTap: onTap,
    );
  }
}
