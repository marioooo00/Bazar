import 'package:flutter/material.dart';
import 'package:task/core/constants/app_colors.dart';

class SearchScreen
    extends StatefulWidget {
  final List<Map<String, dynamic>>
  products;
  final ValueChanged<
    Map<String, dynamic>
  >
  onProductTap;

  const SearchScreen({
    super.key,
    required this.products,
    required this.onProductTap,
  });

  @override
  State<SearchScreen> createState() =>
      _SearchScreenState();
}

class _SearchScreenState
    extends State<SearchScreen> {
  final searchController =
      TextEditingController();

  List<Map<String, dynamic>>
  get results {
    final query = searchController.text
        .trim()
        .toLowerCase();
    if (query.isEmpty) {
      return widget.products;
    }
    return widget.products.where((
      product,
    ) {
      return (product['name'] as String)
              .toLowerCase()
              .contains(query) ||
          (product['category']
                  as String)
              .toLowerCase()
              .contains(query);
    }).toList();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final matchingProducts = results;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 56,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () =>
                        Navigator.pop(
                          context,
                        ),
                    icon: const Icon(
                      Icons.arrow_back,
                    ),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Search',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight:
                              FontWeight
                                  .w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 48,
                  ),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.fromLTRB(
                    20,
                    8,
                    20,
                    14,
                  ),
              child: TextField(
                controller:
                    searchController,
                onChanged: (_) =>
                    setState(() {}),
                textInputAction:
                    TextInputAction
                        .search,
                decoration: InputDecoration(
                  hintText: 'Search',
                  prefixIcon:
                      const Icon(
                        Icons.search,
                        color: Color(
                          0xffAAAAAA,
                        ),
                      ),
                  filled: true,
                  fillColor:
                      const Color(
                        0xffFAFAFA,
                      ),
                  contentPadding:
                      const EdgeInsets.symmetric(
                        vertical: 12,
                      ),
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(
                          12,
                        ),
                    borderSide:
                        const BorderSide(
                          color: Color(
                            0xffEEEEEE,
                          ),
                        ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(
                          12,
                        ),
                    borderSide:
                        const BorderSide(
                          color: Color(
                            0xffEEEEEE,
                          ),
                        ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(
                          12,
                        ),
                    borderSide:
                        const BorderSide(
                          color: AppColors
                              .primary,
                        ),
                  ),
                ),
              ),
            ),
            Expanded(
              child:
                  matchingProducts
                      .isEmpty
                  ? const Center(
                      child: Text(
                        'No books found',
                        style: TextStyle(
                          color: Color(
                            0xff999999,
                          ),
                        ),
                      ),
                    )
                  : ListView.separated(
                      itemCount:
                          matchingProducts
                              .length,
                      separatorBuilder:
                          (
                            _,
                            _,
                          ) => const Divider(
                            height: 1,
                            indent: 20,
                            color: Color(
                              0xffEEEEEE,
                            ),
                          ),
                      itemBuilder: (context, index) {
                        final product =
                            matchingProducts[index];
                        return _SearchBookRow(
                          product:
                              product,
                          onTap: () => widget
                              .onProductTap(
                                product,
                              ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchBookRow
    extends StatelessWidget {
  final Map<String, dynamic> product;
  final VoidCallback onTap;

  const _SearchBookRow({
    required this.product,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: 70,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius:
                      BorderRadius.circular(
                        7,
                      ),
                  child: Image.asset(
                    product['image']
                        as String,
                    width: 44,
                    height: 52,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(
                  width: 14,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment
                            .center,
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                    children: [
                      Text(
                        product['name']
                            as String,
                        maxLines: 1,
                        overflow:
                            TextOverflow
                                .ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight:
                              FontWeight
                                  .w600,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        product['price']
                            as String,
                        style: const TextStyle(
                          color: AppColors
                              .primary,
                          fontSize: 13,
                          fontWeight:
                              FontWeight
                                  .w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
