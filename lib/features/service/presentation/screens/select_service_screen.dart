import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import "package:iconsax/iconsax.dart";
import 'package:spa_mobile/core/common/widgets/loader.dart';
import 'package:spa_mobile/core/common/widgets/rounded_icon.dart';
import 'package:spa_mobile/core/common/widgets/sliver_delegate.dart';
import 'package:spa_mobile/core/helpers/helper_functions.dart';
import 'package:spa_mobile/core/local_storage/local_storage.dart';
import 'package:spa_mobile/core/utils/constants/colors.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';
import 'package:spa_mobile/core/utils/formatters/formatters.dart';
import 'package:spa_mobile/features/product/presentation/widgets/product_title.dart';
import 'package:spa_mobile/features/service/presentation/bloc/list_service/list_service_bloc.dart';

class SelectServiceScreen extends StatefulWidget {
  const SelectServiceScreen({super.key});

  @override
  State<SelectServiceScreen> createState() => _SelectServiceScreenState();
}

class _SelectServiceScreenState extends State<SelectServiceScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;
  int? selectedBranch;
  int? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadLocalData();
    context.read<ListServiceBloc>().add(GetListServicesForSelectionEvent(1, selectedBranch ?? 0, 100));
  }

  Future<void> _loadLocalData() async {
    final branchId = await LocalStorage.getData(LocalStorageKey.defaultBranch);
    setState(() {
      selectedBranch = branchId != null ? int.parse(branchId) : 0;
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.offset > 30 && !_isScrolled) {
      setState(() {
        _isScrolled = true;
      });
    } else if (_scrollController.offset <= 30 && _isScrolled) {
      setState(() {
        _isScrolled = false;
      });
    }

    _checkScrollPositionForCategoryChange();
  }

  void _scrollToCategory(int categoryId) {
    final state = context.read<ListServiceBloc>().state;
    if (state is ListServiceLoadedForSelection) {
      final categoryIndex = state.categories.indexWhere((cat) => cat.categoryId == categoryId);
      if (categoryIndex >= 0) {
        // Calculate position based on previous categories' heights
        double scrollPosition = 0;

        // Add height of SliverAppBar and Category header
        scrollPosition += 120.0; // SliverAppBar expandedHeight
        scrollPosition += 70.0; // Category header height

        // Calculate height for each category before the target category
        for (int i = 0; i < categoryIndex; i++) {
          final category = state.categories[i];
          final services = state.groupedServices[category.categoryId] ?? [];

          // Category title + description: ~80px (adjust based on actual UI)
          final headerHeight = 80.0;

          // Calculate service items height
          // Each service item: row + spacing + divider = ~100px
          final servicesHeight = services.length * 100.0;

          scrollPosition += headerHeight + servicesHeight;
        }

        // Scroll to the calculated position with animation
        _scrollController.animateTo(
          scrollPosition,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    }
  }

// Phương thức kiểm tra vị trí cuộn và cập nhật danh mục đang được chọn
  void _checkScrollPositionForCategoryChange() {
    final state = context.read<ListServiceBloc>().state;
    if (state is ListServiceLoadedForSelection) {
      // Current scroll position
      final scrollOffset = _scrollController.offset;

      // Account for headers (SliverAppBar + Category header)
      double headerOffset = 120.0 + 70.0; // AppBar + Category header heights
      double adjustedOffset = scrollOffset - headerOffset;

      if (adjustedOffset < 0) {
        // We're still in the headers, select first category by default
        if (state.categories.isNotEmpty && _selectedCategoryId != state.categories.first.categoryId) {
          setState(() {
            _selectedCategoryId = state.categories.first.categoryId;
          });
          context.read<ListServiceBloc>().add(SelectCategoryEvent(_selectedCategoryId!));
        }
        return;
      }

      // Track accumulated height as we iterate through categories
      double accumulatedHeight = 0.0;
      int? newCategoryId;

      // Find which category is currently visible
      for (int i = 0; i < state.categories.length; i++) {
        final category = state.categories[i];
        final services = state.groupedServices[category.categoryId] ?? [];

        final categoryHeaderHeight = 70.0; // Title + description
        final servicesHeight = services.length * 80.0; // Each service item row
        final categoryTotalHeight = categoryHeaderHeight + servicesHeight;

        // If our adjusted offset is within this category's height range
        if (adjustedOffset >= accumulatedHeight && adjustedOffset < accumulatedHeight + categoryTotalHeight) {
          newCategoryId = category.categoryId;
          break;
        }

        accumulatedHeight += categoryTotalHeight;
      }

      // If we found a visible category and it's different from current selection
      if (newCategoryId != null && _selectedCategoryId != newCategoryId) {
        setState(() {
          _selectedCategoryId = newCategoryId;
        });
        context.read<ListServiceBloc>().add(SelectCategoryEvent(_selectedCategoryId!));
      }
    }
  }

  // Phương thức để xử lý khi người dùng chọn một danh mục
  void _onCategorySelected(int categoryId) {
    setState(() {
      _selectedCategoryId = categoryId;
    });

    // Cập nhật bloc với danh mục đã chọn
    context.read<ListServiceBloc>().add(SelectCategoryEvent(categoryId));

    // Cuộn đến danh mục đã chọn
    _scrollToCategory(categoryId);
  }

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.white,
            pinned: true,
            expandedHeight: 120.0,
            leading: IconButton(
              icon: const Icon(Iconsax.arrow_left),
              onPressed: () => Navigator.of(context).pop(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.only(
                left: _isScrolled ? 56.0 : 16.0,
                bottom: _isScrolled ? 16.0 : 16.0,
              ),
              title: Text(
                "Select services",
                style: Theme.of(context).textTheme.displaySmall,
              ),
            ),
            actions: [
              TRoundedIcon(
                icon: Iconsax.scissor_1,
                onPressed: () {
                  // _showModelLeave(context);
                },
              ),
              const SizedBox(
                width: TSizes.md,
              )
            ],
            bottom: _isScrolled
                ? PreferredSize(
                    preferredSize: const Size.fromHeight(1),
                    child: Container(
                      height: 1,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: TColors.darkGrey.withOpacity(0.3),
                            blurRadius: 1,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                    ),
                  )
                : null,
          ),
          // const SizedBox(height: TSizes.md,),
          SliverPersistentHeader(
            pinned: true,
            delegate: TSliverPersistentHeaderDelegate(
              maxHeight: 70,
              minHeight: 70,
              child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: TSizes.sm, vertical: TSizes.md),
                  child: TCategories(
                    selectedCategoryId: _selectedCategoryId,
                    onCategorySelected: _onCategorySelected,
                  )),
            ),
          ),
          BlocBuilder<ListServiceBloc, ListServiceState>(
            builder: (context, state) {
              if (state is ListServiceLoadingForSelection) {
                return const SliverToBoxAdapter(child: TLoader());
              } else if (state is ListServiceLoadedForSelection) {
                // if (state.selectedCategoryId != null) {
                //   // Show services for a specific category
                //   final categoryId = state.selectedCategoryId!;
                //   final categoryServices = state.groupedServices[categoryId] ?? [];
                //   final category = state.categories.firstWhere((x) => x.categoryId == categoryId, orElse: () => state.categories.first);
                //
                //   return SliverToBoxAdapter(
                //     child: Column(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: [
                //         // Category title
                //         Padding(
                //           padding: const EdgeInsets.only(left: TSizes.md, right: TSizes.md, top: TSizes.lg),
                //           child: Column(
                //             crossAxisAlignment: CrossAxisAlignment.start,
                //             children: [
                //               Text(
                //                 category.name,
                //                 style: Theme.of(context).textTheme.titleLarge?.copyWith(
                //                       fontWeight: FontWeight.bold,
                //                     ),
                //               ),
                //               Text(category.description, style: Theme.of(context).textTheme.bodyMedium)
                //             ],
                //           ),
                //         ),
                //
                //         // Services in this category
                //         ListView.builder(
                //           physics: const NeverScrollableScrollPhysics(),
                //           shrinkWrap: true,
                //           itemCount: categoryServices.length,
                //           itemBuilder: (context, i) {
                //             final service = categoryServices[i];
                //             return Padding(
                //               padding: const EdgeInsets.symmetric(horizontal: TSizes.md),
                //               child: Column(
                //                 children: [
                //                   Row(
                //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //                     children: [
                //                       Expanded(
                //                         child: Column(
                //                           crossAxisAlignment: CrossAxisAlignment.start,
                //                           children: [
                //                             TProductTitleText(
                //                               title: service.name,
                //                               smallSize: true,
                //                             ),
                //                             const SizedBox(height: TSizes.xs),
                //                             Text(
                //                               "${service.duration} ${AppLocalizations.of(context)?.minutes ?? 'minutes'}",
                //                               style: Theme.of(context).textTheme.bodySmall!.copyWith(
                //                                     color: TColors.darkerGrey,
                //                                   ),
                //                             ),
                //                             const SizedBox(height: TSizes.xs),
                //                             Text(
                //                               formatMoney(service.price.toString()),
                //                               style: Theme.of(context).textTheme.bodySmall!.copyWith(
                //                                     fontWeight: FontWeight.w500,
                //                                   ),
                //                             ),
                //                           ],
                //                         ),
                //                       ),
                //                       TRoundedIcon(
                //                         icon: Iconsax.add,
                //                         width: 40,
                //                         height: 40,
                //                         size: 24,
                //                         backgroundColor: TColors.primaryBackground,
                //                         color: TColors.primary,
                //                         borderRadius: TSizes.sm,
                //                         onPressed: () {
                //                           // Handle service selection
                //                         },
                //                       ),
                //                     ],
                //                   ),
                //                   const SizedBox(height: TSizes.sm),
                //                   Divider(
                //                     color: dark ? TColors.darkGrey : TColors.grey,
                //                     thickness: 0.5,
                //                   ),
                //                 ],
                //               ),
                //             );
                //           },
                //         ),
                //
                //         // const Divider(height: 32),
                //       ],
                //     ),
                //   );
                // } else {
                  // Show all categories in a correct sliver structure
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final category = state.categories[index];
                        final categoryServices = state.groupedServices[category.categoryId] ?? [];

                        return Column(
                          key: ValueKey('category_${category.categoryId}'),
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Category title
                            Padding(
                              padding: const EdgeInsets.only(left: TSizes.md, right: TSizes.md, top: TSizes.lg),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    category.name,
                                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  Text(category.description, style: Theme.of(context).textTheme.bodyMedium)
                                ],
                              ),
                            ),

                            // Services in this category
                            ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: categoryServices.length,
                              itemBuilder: (context, i) {
                                final service = categoryServices[i];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: TSizes.md),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                TProductTitleText(
                                                  title: service.name,
                                                  smallSize: true,
                                                ),
                                                const SizedBox(height: TSizes.xs),
                                                Text(
                                                  "${service.duration} ${AppLocalizations.of(context)?.minutes ?? 'minutes'}",
                                                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                                        color: TColors.darkerGrey,
                                                      ),
                                                ),
                                                const SizedBox(height: TSizes.xs),
                                                Text(
                                                  formatMoney(service.price.toString()),
                                                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          TRoundedIcon(
                                            icon: Iconsax.add,
                                            width: 40,
                                            height: 40,
                                            size: 24,
                                            backgroundColor: TColors.primaryBackground,
                                            color: TColors.primary,
                                            borderRadius: TSizes.sm,
                                            onPressed: () {
                                              // Handle service selection
                                            },
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: TSizes.sm),
                                      Divider(
                                        color: dark ? TColors.darkGrey : TColors.grey,
                                        thickness: 0.5,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),

                            // const Divider(height: 32),
                          ],
                        );
                      },
                      childCount: state.categories.length,
                    ),
                  );
                }
              // }
              return const SliverToBoxAdapter(child: SizedBox()); // Return an empty sliver
            },
          )
        ],
      ),
    );
  }
}

class TCategories extends StatelessWidget {
  final int? selectedCategoryId;
  final Function(int) onCategorySelected;

  const TCategories({
    Key? key,
    this.selectedCategoryId,
    required this.onCategorySelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListServiceBloc, ListServiceState>(
      builder: (context, state) {
        if (state is ListServiceLoadedForSelection) {
          return SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: state.categories.length,
              itemBuilder: (_, index) {
                final category = state.categories[index];
                final isSelected = selectedCategoryId == category.categoryId;

                return Padding(
                  padding: const EdgeInsets.only(right: TSizes.sm),
                  child: GestureDetector(
                    onTap: () => onCategorySelected(category.categoryId),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: TSizes.md),
                      decoration: BoxDecoration(
                        color: isSelected ? TColors.primary : TColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(TSizes.md),
                      ),
                      child: Center(
                        child: Text(
                          category.name,
                          style: Theme.of(context).textTheme.labelLarge!.copyWith(
                                color: isSelected ? TColors.white : TColors.dark,
                              ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}
