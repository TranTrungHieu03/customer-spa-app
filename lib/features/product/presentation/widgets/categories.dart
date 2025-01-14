import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spa_mobile/core/utils/constants/colors.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';
import 'package:spa_mobile/features/service/presentation/bloc/category/list_category_bloc.dart';
import 'package:spa_mobile/features/service/presentation/widgets/category_shimmer_card.dart';

class TCategories extends StatefulWidget {
  const TCategories({super.key});

  @override
  _TCategoriesState createState() => _TCategoriesState();
}

class _TCategoriesState extends State<TCategories> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<ListCategoryBloc>().add(GetListCategoriesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListCategoryBloc, ListCategoryState>(
      builder: (context, state) {
        if (state is ListCategoryLoading) {
          return const TCategoryShimmerCard();
        } else if (state is ListCategoryLoaded) {
          final categories = state.categories;
          return SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (_, index) {
                final category = categories[index];
                final bool isSelected = _selectedIndex == index;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  child: Container(
                    constraints: const BoxConstraints(minWidth: 80),
                    padding: const EdgeInsets.symmetric(
                      horizontal: TSizes.md,
                      vertical: TSizes.sm / 2,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? TColors.primary : TColors.lightGrey,
                      borderRadius: BorderRadius.circular(70),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: TColors.primary.withOpacity(0.5),
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ]
                          : [],
                    ),
                    child: Center(
                      child: Text(
                        category.name,
                        style: Theme.of(context).textTheme.titleLarge!.apply(color: isSelected ? TColors.white : TColors.black),
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (_, __) => const SizedBox(width: TSizes.spacebtwSections),
              itemCount: categories.length,
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
