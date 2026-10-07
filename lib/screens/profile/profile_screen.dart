import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task/core/constants/app_colors.dart';

class ProfileScreen
    extends StatefulWidget {
  final List<Map<String, dynamic>>
  products;
  final Set<String> favoriteNames;
  final ValueChanged<String>
  onFavoriteTap;
  final List<String> orderHistory;
  final ValueChanged<
    Map<String, dynamic>
  >
  onProductTap;
  final VoidCallback onLogout;

  const ProfileScreen({
    super.key,
    required this.products,
    required this.favoriteNames,
    required this.onFavoriteTap,
    required this.orderHistory,
    required this.onProductTap,
    required this.onLogout,
  });

  @override
  State<ProfileScreen> createState() =>
      _ProfileScreenState();
}

class _ProfileScreenState
    extends State<ProfileScreen> {
  User? get user =>
      FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    final currentUser = user;
    final name =
        currentUser?.displayName
                ?.trim()
                .isNotEmpty ==
            true
        ? currentUser!.displayName!
              .trim()
        : 'Book lover';
    final email =
        currentUser?.email ??
        'No email added';

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        const SizedBox(height: 12),
        const Center(
          child: Text(
            'Profile',
            style: TextStyle(
              fontSize: 18,
              fontWeight:
                  FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding:
              const EdgeInsets.symmetric(
                horizontal: 18,
              ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 21,
                backgroundColor:
                    const Color(
                      0xffEEEAF5,
                    ),
                child:
                    currentUser
                            ?.photoURL ==
                        null
                    ? const Icon(
                        Icons.person,
                        color: AppColors
                            .primary,
                      )
                    : ClipOval(
                        child: Image.network(
                          currentUser!
                              .photoURL!,
                          width: 42,
                          height: 42,
                          fit: BoxFit
                              .cover,
                          errorBuilder:
                              (
                                context,
                                error,
                                stackTrace,
                              ) => const Icon(
                                Icons
                                    .person,
                                color: AppColors
                                    .primary,
                              ),
                        ),
                      ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight:
                            FontWeight
                                .w700,
                      ),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    Text(
                      email,
                      style:
                          const TextStyle(
                            fontSize:
                                10,
                            color: Color(
                              0xff999999,
                            ),
                          ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed:
                    _confirmLogout,
                child: const Text(
                  'Logout',
                  style: TextStyle(
                    color: Color(
                      0xffD64A4A,
                    ),
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 18),
        _menuItem(
          Icons.person_outline,
          'My Account',
          _openAccount,
        ),
        _menuItem(
          Icons.favorite_border,
          'Your Favorites',
          _openFavorites,
        ),
        _menuItem(
          Icons.receipt_long_outlined,
          'Order History',
          _openOrders,
        ),
        _menuItem(
          Icons.support_agent_outlined,
          'Help Center',
          _openHelp,
        ),
      ],
    );
  }

  Widget _menuItem(
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return ListTile(
      dense: true,
      contentPadding:
          const EdgeInsets.symmetric(
            horizontal: 20,
          ),
      leading: CircleAvatar(
        radius: 14,
        backgroundColor: const Color(
          0xffF4F1F8,
        ),
        child: Icon(
          icon,
          size: 15,
          color: AppColors.primary,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: Color(0xffBBBBBB),
        size: 20,
      ),
      onTap: onTap,
    );
  }

  void _openAccount() {
    final nameController =
        TextEditingController(
          text: user?.displayName ?? '',
        );
    final emailController =
        TextEditingController(
          text: user?.email ?? '',
        );
    var saving = false;

    Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (pageContext) => StatefulBuilder(
          builder: (context, setPageState) => Scaffold(
            backgroundColor:
                Colors.white,
            appBar: AppBar(
              title: const Text(
                'My Account',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight:
                      FontWeight.w700,
                ),
              ),
              leading:
                  const BackButton(),
              backgroundColor:
                  Colors.white,
              surfaceTintColor:
                  Colors.white,
              elevation: 0,
            ),
            body: Padding(
              padding:
                  const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 12,
                  ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                children: [
                  _fieldLabel('Name'),
                  TextField(
                    controller:
                        nameController,
                    textCapitalization:
                        TextCapitalization
                            .words,
                    decoration:
                        _inputDecoration(),
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  _fieldLabel('Email'),
                  TextField(
                    controller:
                        emailController,
                    keyboardType:
                        TextInputType
                            .emailAddress,
                    decoration:
                        _inputDecoration(),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width:
                        double.infinity,
                    height: 46,
                    child: ElevatedButton(
                      onPressed: saving
                          ? null
                          : () async {
                              final name = nameController
                                  .text
                                  .trim();
                              final email = emailController
                                  .text
                                  .trim();
                              if (name.isEmpty ||
                                  email
                                      .isEmpty) {
                                _message(
                                  'Name and email are required',
                                );
                                return;
                              }
                              setPageState(
                                () => saving =
                                    true,
                              );
                              try {
                                final account =
                                    user;
                                if (account ==
                                    null) {
                                  throw FirebaseAuthException(
                                    code: 'no-current-user',
                                  );
                                }
                                await account
                                    .updateDisplayName(
                                      name,
                                    );
                                var emailMessage =
                                    '';
                                if (email !=
                                    account.email) {
                                  try {
                                    await account.verifyBeforeUpdateEmail(
                                      email,
                                    );
                                    emailMessage = ' Check your new email to confirm the change.';
                                  } on FirebaseAuthException catch (
                                    error
                                  ) {
                                    emailMessage =
                                        ' Name saved, but email was not changed: ${error.message ?? 'sign in again and retry'}';
                                  }
                                }
                                await account
                                    .reload();
                                if (!mounted ||
                                    !pageContext.mounted) {
                                  return;
                                }
                                setState(
                                  () {},
                                );
                                Navigator.pop(
                                  pageContext,
                                );
                                _message(
                                  'Account details saved.$emailMessage',
                                );
                              } on FirebaseAuthException catch (
                                error
                              ) {
                                _message(
                                  error.message ?? 'Could not save account details',
                                );
                              } finally {
                                if (pageContext
                                    .mounted) {
                                  setPageState(
                                    () =>
                                        saving = false,
                                  );
                                }
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            AppColors
                                .primary,
                        foregroundColor:
                            Colors
                                .white,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                                24,
                              ),
                        ),
                      ),
                      child: saving
                          ? const SizedBox(
                              width: 18,
                              height:
                                  18,
                              child: CircularProgressIndicator(
                                strokeWidth:
                                    2,
                                color: Colors
                                    .white,
                              ),
                            )
                          : const Text(
                              'Save Changes',
                              style: TextStyle(
                                fontWeight:
                                    FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ).whenComplete(() {
      nameController.dispose();
      emailController.dispose();
    });
  }

  InputDecoration
  _inputDecoration() => InputDecoration(
    filled: true,
    fillColor: const Color(0xffFAFAFA),
    contentPadding:
        const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
    border: OutlineInputBorder(
      borderRadius:
          BorderRadius.circular(8),
      borderSide: const BorderSide(
        color: Color(0xffEEEEEE),
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius:
          BorderRadius.circular(8),
      borderSide: const BorderSide(
        color: Color(0xffEEEEEE),
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius:
          BorderRadius.circular(8),
      borderSide: const BorderSide(
        color: AppColors.primary,
      ),
    ),
  );

  Widget _fieldLabel(String label) =>
      Padding(
        padding: const EdgeInsets.only(
          bottom: 6,
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      );

  void _openFavorites() {
    final favorites = widget.products
        .where(
          (product) => widget
              .favoriteNames
              .contains(
                product['name'],
              ),
        )
        .toList();
    _openBookList(
      'Your Favorites',
      favorites,
      emptyMessage:
          'No favorite books yet',
    );
  }

  void _openOrders() {
    Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text(
              'Order History',
              style: TextStyle(
                fontSize: 16,
                fontWeight:
                    FontWeight.w700,
              ),
            ),
            backgroundColor:
                Colors.white,
            surfaceTintColor:
                Colors.white,
            elevation: 0,
          ),
          body:
              widget
                  .orderHistory
                  .isEmpty
              ? const Center(
                  child: Text(
                    'Your orders will appear here',
                    style: TextStyle(
                      color: Color(
                        0xff999999,
                      ),
                    ),
                  ),
                )
              : ListView.separated(
                  itemCount: widget
                      .orderHistory
                      .length,
                  separatorBuilder:
                      (_, _) =>
                          const Divider(
                            height: 1,
                          ),
                  itemBuilder: (context, index) => ListTile(
                    leading: const CircleAvatar(
                      backgroundColor:
                          Color(
                            0xffF4F1F8,
                          ),
                      child: Icon(
                        Icons
                            .receipt_long_outlined,
                        color: AppColors
                            .primary,
                        size: 18,
                      ),
                    ),
                    title: Text(
                      'Order ${widget.orderHistory.length - index}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight:
                            FontWeight
                                .w600,
                      ),
                    ),
                    subtitle: Text(
                      widget
                          .orderHistory[index],
                      style:
                          const TextStyle(
                            fontSize:
                                11,
                          ),
                    ),
                    trailing: const Text(
                      'Placed',
                      style: TextStyle(
                        color: AppColors
                            .primary,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  void _openBookList(
    String title,
    List<Map<String, dynamic>> books, {
    required String emptyMessage,
  }) {
    Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight:
                    FontWeight.w700,
              ),
            ),
            backgroundColor:
                Colors.white,
            surfaceTintColor:
                Colors.white,
            elevation: 0,
          ),
          body: books.isEmpty
              ? Center(
                  child: Text(
                    emptyMessage,
                    style:
                        const TextStyle(
                          color: Color(
                            0xff999999,
                          ),
                        ),
                  ),
                )
              : ListView.separated(
                  itemCount:
                      books.length,
                  separatorBuilder:
                      (_, _) =>
                          const Divider(
                            height: 1,
                          ),
                  itemBuilder: (context, index) {
                    final book =
                        books[index];
                    final isFavorite = widget
                        .favoriteNames
                        .contains(
                          book['name'],
                        );
                    return ListTile(
                      onTap: () => widget
                          .onProductTap(
                            book,
                          ),
                      leading: Image.asset(
                        book['image']
                            as String,
                        width: 42,
                        fit: BoxFit
                            .cover,
                      ),
                      title: Text(
                        book['name']
                            as String,
                        maxLines: 1,
                        overflow:
                            TextOverflow
                                .ellipsis,
                      ),
                      subtitle: Text(
                        book['price']
                            as String,
                        style: const TextStyle(
                          color: AppColors
                              .primary,
                        ),
                      ),
                      trailing: IconButton(
                        onPressed: () => setState(
                          () => widget.onFavoriteTap(
                            book['name']
                                as String,
                          ),
                        ),
                        icon: Icon(
                          isFavorite
                              ? Icons
                                    .favorite
                              : Icons
                                    .favorite_border,
                          color: AppColors
                              .primary,
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }

  void _openHelp() {
    Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text(
              'Help Center',
              style: TextStyle(
                fontSize: 16,
                fontWeight:
                    FontWeight.w700,
              ),
            ),
            backgroundColor:
                Colors.white,
            surfaceTintColor:
                Colors.white,
            elevation: 0,
          ),
          body: Column(
            children: [
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.fromLTRB(
                      24,
                      26,
                      24,
                      28,
                    ),
                color:
                    AppColors.primary,
                child: const Column(
                  children: [
                    Text(
                      'How can we help you?',
                      style: TextStyle(
                        color: Colors
                            .white,
                        fontSize: 18,
                        fontWeight:
                            FontWeight
                                .w700,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Our support team is here for you.',
                      style: TextStyle(
                        color: Color(
                          0xffE7E0F2,
                        ),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.all(
                      20,
                    ),
                child: Row(
                  children: [
                    Expanded(
                      child: _contactCard(
                        Icons
                            .mail_outline,
                        'Email',
                        'support@bazar.app',
                        () => _message(
                          'Email: support@bazar.app',
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: _contactCard(
                        Icons
                            .phone_outlined,
                        'Phone Number',
                        '+1 234 567 890',
                        () => _message(
                          'Phone: +1 234 567 890',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _contactCard(
    IconData icon,
    String title,
    String detail,
    VoidCallback onTap,
  ) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(
      8,
    ),
    child: Container(
      height: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xffFAFAFA),
        borderRadius:
            BorderRadius.circular(8),
        border: Border.all(
          color: const Color(
            0xffEEEEEE,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 18,
            color: AppColors.primary,
          ),
          const Spacer(),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight:
                  FontWeight.w600,
            ),
          ),
          Text(
            detail,
            maxLines: 1,
            overflow:
                TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 9,
              color: Color(0xff999999),
            ),
          ),
        ],
      ),
    ),
  );

  void _confirmLogout() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape:
          const RoundedRectangleBorder(
            borderRadius:
                BorderRadius.vertical(
                  top: Radius.circular(
                    20,
                  ),
                ),
          ),
      builder: (context) => SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.fromLTRB(
                20,
                20,
                20,
                14,
              ),
          child: Column(
            mainAxisSize:
                MainAxisSize.min,
            crossAxisAlignment:
                CrossAxisAlignment
                    .start,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(
                      0xffDDDDDD,
                    ),
                    borderRadius:
                        BorderRadius.circular(
                          4,
                        ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Logout',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight:
                      FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Are you sure you want to log out of your account?',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(
                    0xff777777,
                  ),
                ),
              ),
              const SizedBox(
                height: 18,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(
                      context,
                    );
                    await FirebaseAuth
                        .instance
                        .signOut();
                    widget.onLogout();
                  },
                  style:
                      ElevatedButton.styleFrom(
                        backgroundColor:
                            AppColors
                                .primary,
                        foregroundColor:
                            Colors
                                .white,
                      ),
                  child: const Text(
                    'Logout',
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () =>
                      Navigator.pop(
                        context,
                      ),
                  child: const Text(
                    'Cancel',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _message(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
