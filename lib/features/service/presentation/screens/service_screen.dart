import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spa_mobile/core/common/widgets/appbar.dart';
import 'package:spa_mobile/core/common/widgets/grid_layout.dart';
import 'package:spa_mobile/core/common/widgets/rounded_container.dart';
import 'package:spa_mobile/core/common/widgets/rounded_icon.dart';
import 'package:spa_mobile/core/common/widgets/show_snackbar.dart';
import 'package:spa_mobile/core/utils/constants/colors.dart';
import 'package:spa_mobile/core/utils/constants/exports_navigators.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';
import 'package:spa_mobile/features/service/presentation/bloc/category/list_category_bloc.dart';
import 'package:spa_mobile/features/service/presentation/bloc/list_service/list_service_bloc.dart';
import 'package:spa_mobile/features/service/presentation/widgets/category_shimmer_card.dart';
import 'package:spa_mobile/features/service/presentation/widgets/service_shimmer_card.dart';
import 'package:spa_mobile/features/service/presentation/widgets/service_vertical_card.dart';
import 'package:spa_mobile/init_dependencies.dart';

class WrapperServiceScreen extends StatefulWidget {
  const WrapperServiceScreen({super.key});

  @override
  State<WrapperServiceScreen> createState() => _WrapperServiceScreenState();
}

class _WrapperServiceScreenState extends State<WrapperServiceScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ListServiceBloc>(
      create: (context) => ListServiceBloc(serviceLocator()),
      child: const ServiceScreen(),
    );
  }
}

class ServiceScreen extends StatefulWidget {
  const ServiceScreen({super.key});

  @override
  _ServiceScreenState createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  late ScrollController _scrollController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    context.read<ListCategoryBloc>().add(GetListCategoriesEvent());
    context.read<ListServiceBloc>().add(GetListServicesEvent(1));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.extentAfter < 200) {
      final currentState = context.read<ListServiceBloc>().state;
      if (currentState is ListServiceLoaded &&
          !currentState.isLoadingMore &&
          currentState.pagination.page < currentState.pagination.totalPage) {
        context
            .read<ListServiceBloc>()
            .add(GetListServicesEvent(currentState.pagination.page + 1));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ListServiceBloc, ListServiceState>(
      listener: (context, state) {
        if (state is ListServiceFailure) {
          TSnackBar.errorSnackBar(context, message: state.message);
        }
      },
      child: Scaffold(
        appBar: TAppbar(
          title: Text(
            AppLocalizations.of(context)!.service,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          actions: [
            TRoundedIcon(
              icon: Iconsax.ticket,
              onPressed: () => goServiceHistory(),
            )
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(TSizes.sm),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: goSearch,
                    child: TRoundedContainer(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: TSizes.md),
                            child: Text('Search',
                                style: Theme.of(context).textTheme.bodySmall),
                          ),
                          TRoundedIcon(icon: Iconsax.search_favorite)
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: TSizes.md),
                  BlocBuilder<ListCategoryBloc, ListCategoryState>(
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
                                  constraints:
                                      const BoxConstraints(minWidth: 80),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: TSizes.md,
                                    vertical: TSizes.sm / 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? TColors.primary
                                        : TColors.lightGrey,
                                    borderRadius: BorderRadius.circular(70),
                                    boxShadow: isSelected
                                        ? [
                                            BoxShadow(
                                              color: TColors.primary
                                                  .withOpacity(0.5),
                                              blurRadius: 10,
                                              offset: const Offset(0, 3),
                                            ),
                                          ]
                                        : [],
                                  ),
                                  child: Center(
                                    child: Text(
                                      category.name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge!
                                          .apply(
                                              color: isSelected
                                                  ? TColors.white
                                                  : TColors.black),
                                    ),
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (_, __) =>
                                const SizedBox(width: TSizes.spacebtwSections),
                            itemCount: categories.length,
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: TSizes.md),
            Expanded(
              child: BlocBuilder<ListServiceBloc, ListServiceState>(
                builder: (context, state) {
                  if (state is ListServiceLoading) {
                    return TGridLayout(
                        crossAxisCount: 2,
                        itemCount: 4,
                        itemBuilder: (context, _) {
                          return const TServiceCardShimmer();
                        });
                  } else if (state is ListServiceEmpty) {
                    return const Center(
                      child: Text('No services available.',
                          style: TextStyle(fontSize: 16)),
                    );
                  } else if (state is ListServiceLoaded) {
                    return NotificationListener<ScrollNotification>(
                        onNotification: (scrollNotification) {
                          if (scrollNotification is ScrollEndNotification &&
                              _scrollController.position.extentAfter < 200) {
                            final currentState = state;
                            if (currentState.pagination.page <
                                currentState.pagination.totalPage) {
                              context.read<ListServiceBloc>().add(
                                  GetListServicesEvent(
                                      currentState.pagination.page + 1));
                            }
                          }
                          return false;
                        },
                        child: TGridLayout(
                          controller: _scrollController,
                          itemCount: state.services.length + 2,
                          crossAxisCount: 2,
                          itemBuilder: (context, index) {
                            if (index == state.services.length ||
                                index == state.services.length + 1) {
                              return state.isLoadingMore
                                  ? const TServiceCardShimmer()
                                  : const SizedBox.shrink();
                            }
                            final service = state.services[index];
                            return TServiceCard(
                              service: service,
                            );
                          },
                        ));
                  }
                  return const Center(child: Text('Please come back later.'));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
