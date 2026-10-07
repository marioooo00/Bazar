import 'package:flutter/material.dart';
import 'package:task/core/constants/app_colors.dart';

class CategoryScreen
    extends StatefulWidget {
  final List<Map<String, dynamic>>
  products;
  final ValueChanged<
    Map<String, dynamic>
  >
  onProductTap;
  final VoidCallback onSearchTap;

  const CategoryScreen({
    super.key,
    required this.products,
    required this.onProductTap,
    required this.onSearchTap,
  });

  @override
  State<CategoryScreen> createState() =>
      _CategoryScreenState();
}

class _CategoryScreenState
    extends State<CategoryScreen> {
  String selectedCategory = 'All';

  List<String> get categories => [
    'All',
    ...widget.products
        .map(
          (product) =>
              product['category']
                  as String,
        )
        .toSet(),
  ];

  List<Map<String, dynamic>>
  get visibleProducts =>
      selectedCategory == 'All'
      ? widget.products
      : widget.products
            .where(
              (product) =>
                  product['category'] ==
                  selectedCategory,
            )
            .toList();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 12),
        Padding(
          padding:
              const EdgeInsets.symmetric(
                horizontal: 20,
              ),
          child: Row(
            children: [
              IconButton(
                onPressed:
                    widget.onSearchTap,
                icon: const Icon(
                  Icons.search,
                ),
                color: const Color(
                  0xff222222,
                ),
              ),
              const Expanded(
                child: Center(
                  child: Text(
                    'Category',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight:
                          FontWeight
                              .w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),
        ),
        SizedBox(
          height: 48,
          child: ListView.separated(
            padding:
                const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
            scrollDirection:
                Axis.horizontal,
            itemCount:
                categories.length,
            separatorBuilder: (_, _) =>
                const SizedBox(
                  width: 22,
                ),
            itemBuilder: (context, index) {
              final category =
                  categories[index];
              final isSelected =
                  category ==
                  selectedCategory;
              return InkWell(
                onTap: () => setState(
                  () =>
                      selectedCategory =
                          category,
                ),
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment
                          .end,
                  children: [
                    Text(
                      category,
                      style: TextStyle(
                        color:
                            isSelected
                            ? const Color(
                                0xff222222,
                              )
                            : const Color(
                                0xff999999,
                              ),
                        fontSize: 13,
                        fontWeight:
                            isSelected
                            ? FontWeight
                                  .w700
                            : FontWeight
                                  .w400,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      width: 18,
                      height: 2,
                      color: isSelected
                          ? AppColors
                                .primary
                          : Colors
                                .transparent,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding:
                const EdgeInsets.only(
                  top: 6,
                ),
            itemCount:
                visibleProducts.length,
            separatorBuilder: (_, _) =>
                const Divider(
                  height: 1,
                  indent: 20,
                  color: Color(
                    0xffEEEEEE,
                  ),
                ),
            itemBuilder: (context, index) {
              final product =
                  visibleProducts[index];
              return _BookRow(
                product: product,
                onTap: () =>
                    widget.onProductTap(
                      product,
                    ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _BookRow extends StatelessWidget {
  final Map<String, dynamic> product;
  final VoidCallback onTap;

  const _BookRow({
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
