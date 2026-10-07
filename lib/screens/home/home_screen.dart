import 'package:flutter/material.dart';
import 'package:task/core/constants/app_colors.dart';
import 'package:task/screens/auth/login_screen.dart';
import 'package:task/screens/category/category_screen.dart';
import 'package:task/screens/profile/profile_screen.dart';
import 'package:task/screens/search/search_screen.dart';

class HomeScreen
    extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() =>
      _HomeScreenState();
}

class _HomeScreenState
    extends State<HomeScreen> {
  int selectedNav = 0;
  final Map<String, int> cartItems = {};
  final Set<String> favoriteNames = {};
  final List<String> orderHistory = [];

  // ============================================================
  // PRODUCTS
  // ============================================================

  final List<Map<String, dynamic>>
  products = [
    {
      'name': 'The Kite Runner',
      'price': '\$14.99',
      'unitPrice': 14.99,
      'category': 'Novels',
      'image': 'assets/images/home/book_kite_runner.png',
    },
    {
      'name': 'The Subtle Art of Not Giving a F*ck',
      'price': '\$20.99',
      'unitPrice': 20.99,
      'category': 'Self Love',
      'image': 'assets/images/home/book_subtle_art.png',
    },
    {
      'name': 'The Art of War',
      'price': '\$14.99',
      'unitPrice': 14.99,
      'category': 'Strategy',
      'image': 'assets/images/home/book_third.png',
    },
    {
      'name': 'The Burning Maze',
      'price': '\$18.50',
      'unitPrice': 18.50,
      'category': 'Fantasy',
      'image': 'assets/images/home/special_offer_book.png',
    },
  ];

  // ============================================================
  // AUTHORS
  // ============================================================

  final List<Map<String, String>>
  authors = [
    {
      'name': 'John Freeman',
      'job': 'Writer',
      'image': 'assets/images/home/author_john_freeman.png',
    },
    {
      'name': 'Tess Gunty',
      'job': 'Novelist',
      'image': 'assets/images/home/author_tess_gunter.png',
    },
    {
      'name': 'Richard Perry',
      'job': 'Writer',
      'image': 'assets/images/home/author_richard.png',
    },
  ];

  // ============================================================
  // VENDORS
  // ============================================================

  final List<Map<String, String>>
  vendors = [
    {
      'name': 'WS',
      'image': 'assets/images/home/vendor_1.png',
    },
    {
      'name': 'Human',
      'image': 'assets/images/home/vendor_2.png',
    },
    {
      'name': 'GoodDay',
      'image': 'assets/images/home/vendor_3.png',
    },
    {
      'name': 'Crane & Co.',
      'image': 'assets/images/home/vendor_4.png',
    },
  ];

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: selectedNav == 0
                  ? SingleChildScrollView(
                      physics:
                          const BouncingScrollPhysics(),
                      padding:
                          const EdgeInsets.only(
                            bottom: 15,
                          ),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),

                          // TOP BAR
                          _buildTopBar(),

                          const SizedBox(
                            height: 18,
                          ),

                          // SPECIAL OFFER
                          _buildSpecialOffer(),

                          const SizedBox(
                            height: 24,
                          ),

                          // TOP OF WEEK
                          _buildSectionTitle(
                            title: 'Top of Week',
                            onTap:
                                () {},
                          ),

                          const SizedBox(
                            height: 12,
                          ),

                          _buildProducts(),

                          const SizedBox(
                            height: 22,
                          ),

                          // BEST VENDORS
                          _buildSectionTitle(
                            title: 'Best Vendors',
                            onTap:
                                () {},
                          ),

                          const SizedBox(
                            height: 12,
                          ),

                          _buildVendors(),

                          const SizedBox(
                            height: 24,
                          ),

                          // AUTHORS
                          _buildSectionTitle(
                            title: 'Authors',
                            onTap:
                                () {},
                          ),

                          const SizedBox(
                            height: 14,
                          ),

                          _buildAuthors(),

                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    )
                  : _buildCurrentTab(),
            ),

            // BOTTOM NAVIGATION
            _buildBottomNavigation(),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // TOP BAR
  // ============================================================

  Widget _buildTopBar() {
    return Padding(
      padding:
          const EdgeInsets.symmetric(
            horizontal: 15,
          ),
      child: SizedBox(
        height: 40,
        child: Row(
          children: [
            GestureDetector(
              onTap: _openSearch,
              child: const Icon(
                Icons.search,
                size: 24,
                color: Color(
                  0xff222222,
                ),
              ),
            ),

            const Expanded(
              child: Center(
                child: Text(
                  'Home',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight:
                        FontWeight.w700,
                    color: Color(
                      0xff222222,
                    ),
                  ),
                ),
              ),
            ),

            Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(
                  Icons
                      .shopping_bag_outlined,
                  size: 24,
                  color: Color(
                    0xff222222,
                  ),
                ),

                Positioned(
                  right: -2,
                  top: -3,
                  child: Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color:
                          const Color(
                            0xffFB7185,
                          ),
                      shape: BoxShape
                          .circle,
                      border: Border.all(
                        color: Colors
                            .white,
                        width: 1,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentTab() {
    if (selectedNav == 1) {
      return CategoryScreen(
        products: products,
        onProductTap:
            _showProductDetails,
        onSearchTap: _openSearch,
      );
    }
    if (selectedNav == 2) {
      return _buildCartScreen();
    }
    return _buildProfileScreen();
  }

  Future<void> _openSearch() async {
    final product =
        await Navigator.push<
          Map<String, dynamic>
        >(
          context,
          MaterialPageRoute(
            builder: (searchContext) =>
                SearchScreen(
                  products: products,
                  onProductTap:
                      (
                        product,
                      ) => Navigator.pop(
                        searchContext,
                        product,
                      ),
                ),
          ),
        );
    if (product != null && mounted) {
      _showProductDetails(product);
    }
  }

  Widget _buildCartScreen() {
    final items = cartItems.entries
        .toList();
    final total = items.fold<double>(
      0,
      (sum, entry) {
        final product = products
            .firstWhere(
              (item) =>
                  item['name'] ==
                  entry.key,
            );
        return sum +
            (product['unitPrice']
                    as num) *
                entry.value;
      },
    );

    if (items.isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize:
              MainAxisSize.min,
          children: [
            Icon(
              Icons
                  .shopping_cart_outlined,
              size: 48,
              color: Color(0xffAAAAAA),
            ),
            SizedBox(height: 12),
            Text(
              'Your cart is empty',
              style: TextStyle(
                color: Color(
                  0xff888888,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            'Cart',
            style: TextStyle(
              fontSize: 18,
              fontWeight:
                  FontWeight.w700,
            ),
          ),
        ),
        Expanded(
          child: ListView.separated(
            itemCount: items.length,
            separatorBuilder: (_, _) =>
                const Divider(
                  height: 1,
                ),
            itemBuilder: (context, index) {
              final entry =
                  items[index];
              final product = products
                  .firstWhere(
                    (item) =>
                        item['name'] ==
                        entry.key,
                  );
              return ListTile(
                leading: Image.asset(
                  product['image']
                      as String,
                  width: 42,
                  fit: BoxFit.cover,
                ),
                title: Text(
                  product['name']
                      as String,
                  maxLines: 1,
                  overflow: TextOverflow
                      .ellipsis,
                ),
                subtitle: Text(
                  'Qty: ${entry.value}  ·  ${product['price']}',
                ),
                trailing: IconButton(
                  tooltip: 'Remove from cart',
                  onPressed: () =>
                      setState(
                        () => cartItems
                            .remove(
                              entry.key,
                            ),
                      ),
                  icon: const Icon(
                    Icons
                        .delete_outline,
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding:
              const EdgeInsets.fromLTRB(
                20,
                12,
                20,
                20,
              ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Total  \$${total.toStringAsFixed(2)}',
                  style:
                      const TextStyle(
                        fontSize: 16,
                        fontWeight:
                            FontWeight
                                .w700,
                      ),
                ),
              ),
              ElevatedButton(
                onPressed: _placeOrder,
                child: const Text(
                  'Place order',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProfileScreen() {
    return ProfileScreen(
      products: products,
      favoriteNames: favoriteNames,
      onFavoriteTap: (name) {
        setState(() {
          if (!favoriteNames.add(
            name,
          )) {
            favoriteNames.remove(name);
          }
        });
      },
      orderHistory: orderHistory,
      onProductTap: _showProductDetails,
      onLogout: () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) =>
                const LoginScreen(),
          ),
          (route) => false,
        );
      },
    );
  }

  void _placeOrder() {
    if (cartItems.isEmpty) return;
    final total = cartItems.entries
        .fold<double>(0, (sum, entry) {
          final product = products
              .firstWhere(
                (item) =>
                    item['name'] ==
                    entry.key,
              );
          return sum +
              (product['unitPrice']
                      as num) *
                  entry.value;
        });
    final summary = cartItems.entries
        .map(
          (entry) =>
              '${entry.key} x${entry.value}',
        )
        .join(', ');
    setState(() {
      orderHistory.insert(
        0,
        '$summary  ·  \$${total.toStringAsFixed(2)}',
      );
      cartItems.clear();
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(
      const SnackBar(
        content: Text(
          'Order placed successfully',
        ),
      ),
    );
  }

  // ============================================================
  // SPECIAL OFFER
  // ============================================================

  Widget _buildSpecialOffer() {
    return Padding(
      padding:
          const EdgeInsets.symmetric(
            horizontal: 15,
          ),
      child: Container(
        height: 125,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(
            0xffF4F3F9,
          ),
          borderRadius:
              BorderRadius.circular(10),
        ),
        child: Stack(
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(
                    left: 15,
                    top: 20,
                    bottom: 15,
                  ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                children: [
                  const Text(
                    'Special Offer',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight:
                          FontWeight
                              .w700,
                      color: Color(
                        0xff252525,
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 4,
                  ),

                  const Text(
                    'Discount 25%',
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(
                        0xff777777,
                      ),
                    ),
                  ),

                  const Spacer(),

                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding:
                          const EdgeInsets.symmetric(
                            horizontal:
                                18,
                            vertical: 8,
                          ),
                      decoration: BoxDecoration(
                        color: AppColors
                            .primary,
                        borderRadius:
                            BorderRadius.circular(
                              20,
                            ),
                      ),
                      child: const Text(
                        'Order Now',
                        style: TextStyle(
                          color: Colors
                              .white,
                          fontSize: 11,
                          fontWeight:
                              FontWeight
                                  .w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Positioned(
              right: 15,
              top: 8,
              bottom: 8,
              child: ClipRRect(
                borderRadius:
                    BorderRadius.circular(
                      4,
                    ),
                child: Image.asset(
                  'assets/images/home/special_offer_book.png',
                  width: 75,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) {
                    return Container(
                      width: 75,
                      color: AppColors
                          .primaryLight,
                      child: const Icon(
                        Icons.book,
                        color: AppColors
                            .primary,
                        size: 30,
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // SECTION TITLE
  // ============================================================

  Widget _buildSectionTitle({
    required String title,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(
            horizontal: 15,
          ),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight:
                  FontWeight.w700,
              color: Color(0xff222222),
            ),
          ),

          const Spacer(),

          GestureDetector(
            onTap: onTap,
            child: Text(
              'See all',
              style: TextStyle(
                fontSize: 10,
                fontWeight:
                    FontWeight.w600,
                color:
                    AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // PRODUCTS
  // ============================================================

  Widget _buildProducts() {
    return SizedBox(
      height: 210,
      child: ListView.separated(
        padding:
            const EdgeInsets.symmetric(
              horizontal: 15,
            ),
        scrollDirection:
            Axis.horizontal,
        physics:
            const BouncingScrollPhysics(),
        itemCount: products.length,
        separatorBuilder: (_, __) {
          return const SizedBox(
            width: 10,
          );
        },
        itemBuilder: (context, index) {
          final product =
              products[index];

          return GestureDetector(
            onTap: () {
              _showProductDetails(
                product,
              );
            },
            child: SizedBox(
              width: 90,
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                children: [
                  Container(
                    height: 135,
                    width: 90,
                    decoration: BoxDecoration(
                      color:
                          const Color(
                            0xffF3F3F3,
                          ),
                      borderRadius:
                          BorderRadius.circular(
                            6,
                          ),
                    ),
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(
                            6,
                          ),
                      child: Image.asset(
                        product['image'],
                        fit: BoxFit
                            .cover,
                        errorBuilder: (_, __, ___) {
                          return const Icon(
                            Icons.book,
                            size: 40,
                            color: Colors
                                .grey,
                          );
                        },
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 7,
                  ),

                  Text(
                    product['name'],
                    maxLines: 2,
                    overflow:
                        TextOverflow
                            .ellipsis,
                    style:
                        const TextStyle(
                          fontSize: 10,
                          fontWeight:
                              FontWeight
                                  .w600,
                          color: Color(
                            0xff333333,
                          ),
                        ),
                  ),

                  const SizedBox(
                    height: 4,
                  ),

                  Text(
                    product['price'],
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight:
                          FontWeight
                              .w700,
                      color: AppColors
                          .primary,
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

  // ============================================================
  // VENDORS
  // ============================================================

  Widget _buildVendors() {
    return SizedBox(
      height: 55,
      child: ListView.separated(
        padding:
            const EdgeInsets.symmetric(
              horizontal: 15,
            ),
        scrollDirection:
            Axis.horizontal,
        physics:
            const BouncingScrollPhysics(),
        itemCount: vendors.length,
        separatorBuilder: (_, __) {
          return const SizedBox(
            width: 8,
          );
        },
        itemBuilder: (context, index) {
          final vendor = vendors[index];

          return Container(
            width: 95,
            decoration: BoxDecoration(
              color: const Color(
                0xffFAFAFA,
              ),
              borderRadius:
                  BorderRadius.circular(
                    7,
                  ),
              border: Border.all(
                color: const Color(
                  0xffF0F0F0,
                ),
              ),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.all(
                    8,
                  ),
              child: Image.asset(
                vendor['image']!,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) {
                  return Center(
                    child: Text(
                      vendor['name']!,
                      style: const TextStyle(
                        fontSize: 9,
                        fontWeight:
                            FontWeight
                                .w600,
                        color:
                            Colors.grey,
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  // ============================================================
  // AUTHORS
  // ============================================================

  Widget _buildAuthors() {
    return SizedBox(
      height: 145,
      child: ListView.separated(
        padding:
            const EdgeInsets.symmetric(
              horizontal: 15,
            ),
        scrollDirection:
            Axis.horizontal,
        physics:
            const BouncingScrollPhysics(),
        itemCount: authors.length,
        separatorBuilder: (_, __) {
          return const SizedBox(
            width: 25,
          );
        },
        itemBuilder: (context, index) {
          final author = authors[index];

          return SizedBox(
            width: 70,
            child: Column(
              children: [
                Container(
                  width: 65,
                  height: 65,
                  decoration:
                      const BoxDecoration(
                        shape: BoxShape
                            .circle,
                      ),
                  child: ClipOval(
                    child: Image.asset(
                      author['image']!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) {
                        return const Icon(
                          Icons.person,
                          size: 40,
                          color: Colors
                              .grey,
                        );
                      },
                    ),
                  ),
                ),

                const SizedBox(
                  height: 8,
                ),

                Text(
                  author['name']!,
                  maxLines: 1,
                  overflow: TextOverflow
                      .ellipsis,
                  textAlign:
                      TextAlign.center,
                  style:
                      const TextStyle(
                        fontSize: 9,
                        fontWeight:
                            FontWeight
                                .w600,
                        color: Color(
                          0xff333333,
                        ),
                      ),
                ),

                const SizedBox(
                  height: 4,
                ),

                Text(
                  author['job']!,
                  style:
                      const TextStyle(
                        fontSize: 8,
                        color: Color(
                          0xffA0A0A0,
                        ),
                      ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ============================================================
  // BOTTOM NAVIGATION
  // ============================================================

  Widget _buildBottomNavigation() {
    return Container(
      height: 65,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment
                .spaceAround,
        children: [
          _navItem(
            icon: Icons.home_rounded,
            label: 'Home',
            index: 0,
          ),
          _navItem(
            icon:
                Icons.category_outlined,
            label: 'Category',
            index: 1,
          ),
          _navItem(
            icon: Icons
                .shopping_cart_outlined,
            label: 'Cart',
            index: 2,
          ),
          _navItem(
            icon: Icons.person_outline,
            label: 'Profile',
            index: 3,
          ),
        ],
      ),
    );
  }

  Widget _navItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final bool isSelected =
        selectedNav == index;

    return GestureDetector(
      onTap: () {
        setState(
          () => selectedNav = index,
        );
      },
      child: SizedBox(
        width: 70,
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 21,
              color: isSelected
                  ? AppColors.primary
                  : const Color(
                      0xffAAAAAA,
                    ),
            ),

            const SizedBox(height: 3),

            Text(
              label,
              style: TextStyle(
                fontSize: 8,
                fontWeight: isSelected
                    ? FontWeight.w600
                    : FontWeight.w400,
                color: isSelected
                    ? AppColors.primary
                    : const Color(
                        0xffAAAAAA,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // PRODUCT DETAILS
  // ============================================================

  void _showProductDetails(
    Map<String, dynamic> product,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor:
          Colors.transparent,
      builder: (context) {
        var quantity = 1;
        final unitPrice =
            (product['unitPrice']
                    as num?)
                ?.toDouble() ??
            39.99;

        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height:
                  MediaQuery.of(context)
                      .size
                      .height *
                  0.82,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.vertical(
                      top:
                          Radius.circular(
                            25,
                          ),
                    ),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.all(
                      20,
                    ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors
                              .grey
                              .shade300,
                          borderRadius:
                              BorderRadius.circular(
                                10,
                              ),
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    Center(
                      child: Container(
                        height: 280,
                        width: 190,
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(
                                10,
                              ),
                          color: const Color(
                            0xffF5F5F5,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius:
                              BorderRadius.circular(
                                10,
                              ),
                          child: Image.asset(
                            product['image'],
                            fit: BoxFit
                                .cover,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            product['name'],
                            style: const TextStyle(
                              fontSize:
                                  20,
                              fontWeight:
                                  FontWeight
                                      .w700,
                            ),
                          ),
                        ),

                        IconButton(
                          tooltip:
                              favoriteNames
                                  .contains(
                                    product['name'],
                                  )
                              ? 'Remove from favorites'
                              : 'Add to favorites',
                          onPressed: () {
                            final name =
                                product['name']
                                    as String;
                            setState(() {
                              if (!favoriteNames
                                  .add(
                                    name,
                                  )) {
                                favoriteNames
                                    .remove(
                                      name,
                                    );
                              }
                            });
                            setModalState(
                              () {},
                            );
                          },
                          icon: Icon(
                            favoriteNames.contains(
                                  product['name'],
                                )
                                ? Icons
                                      .favorite
                                : Icons
                                      .favorite_border,
                            color: AppColors
                                .primary,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    Text(
                      'GoodDay',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors
                            .primary,
                        fontWeight:
                            FontWeight
                                .w600,
                      ),
                    ),

                    const SizedBox(
                      height: 12,
                    ),

                    const Text(
                      'Lorem ipsum dolor sit amet, consectetur '
                      'adipisicing elit. Vivamus dignissim ac ac.',
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(
                          0xff999999,
                        ),
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(
                      height: 15,
                    ),

                    const Text(
                      'Review',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight:
                            FontWeight
                                .w700,
                      ),
                    ),

                    const SizedBox(
                      height: 7,
                    ),

                    Row(
                      children: [
                        ...List.generate(
                          4,
                          (
                            index,
                          ) => const Icon(
                            Icons.star,
                            size: 18,
                            color: Color(
                              0xffffc107,
                            ),
                          ),
                        ),

                        const Icon(
                          Icons.star,
                          size: 18,
                          color: Colors
                              .black,
                        ),

                        const SizedBox(
                          width: 5,
                        ),

                        const Text(
                          '(4.0)',
                          style:
                              TextStyle(
                                fontSize:
                                    11,
                              ),
                        ),
                      ],
                    ),

                    const Spacer(),

                    Row(
                      children: [
                        Container(
                          height: 42,
                          decoration: BoxDecoration(
                            color: const Color(
                              0xffF5F3FA,
                            ),
                            borderRadius:
                                BorderRadius.circular(
                                  20,
                                ),
                          ),
                          child: Row(
                            children: [
                              IconButton(
                                onPressed:
                                    quantity >
                                        1
                                    ? () {
                                        setModalState(() {
                                          quantity--;
                                        });
                                      }
                                    : null,
                                icon: const Icon(
                                  Icons
                                      .remove,
                                  size:
                                      16,
                                ),
                              ),

                              Text(
                                '$quantity',
                                style: const TextStyle(
                                  fontWeight:
                                      FontWeight.w600,
                                ),
                              ),

                              IconButton(
                                onPressed: () {
                                  setModalState(() {
                                    quantity++;
                                  });
                                },
                                icon: Icon(
                                  Icons
                                      .add,
                                  size:
                                      16,
                                  color:
                                      AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(
                          width: 12,
                        ),

                        Text(
                          '\$${(unitPrice * quantity).toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize:
                                16,
                            fontWeight:
                                FontWeight
                                    .w700,
                            color: AppColors
                                .primary,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 15,
                    ),

                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(
                                context,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  AppColors
                                      .primary,
                              foregroundColor:
                                  Colors
                                      .white,
                              elevation:
                                  0,
                              padding: const EdgeInsets.symmetric(
                                vertical:
                                    14,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(
                                      25,
                                    ),
                              ),
                            ),
                            child: const Text(
                              'Continue shopping',
                              style: TextStyle(
                                fontSize:
                                    11,
                                fontWeight:
                                    FontWeight.w600,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(
                          width: 10,
                        ),

                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              setState(() {
                                cartItems[product['name']
                                        as String] =
                                    (cartItems[product['name'] as String] ??
                                        0) +
                                    quantity;
                                selectedNav =
                                    2;
                              });
                              Navigator.pop(
                                context,
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor:
                                  AppColors
                                      .primary,
                              side: BorderSide(
                                color: AppColors
                                    .primary,
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical:
                                    14,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(
                                      25,
                                    ),
                              ),
                            ),
                            child: const Text(
                              'View cart',
                              style: TextStyle(
                                fontSize:
                                    11,
                                fontWeight:
                                    FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
