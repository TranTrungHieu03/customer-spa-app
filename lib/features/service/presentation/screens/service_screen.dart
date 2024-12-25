import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spa_mobile/core/common/widgets/appbar.dart';
import 'package:spa_mobile/core/common/widgets/grid_layout.dart';
import 'package:spa_mobile/core/common/widgets/loader.dart';
import 'package:spa_mobile/core/common/widgets/rounded_container.dart';
import 'package:spa_mobile/core/common/widgets/rounded_icon.dart';
import 'package:spa_mobile/core/utils/constants/colors.dart';
import 'package:spa_mobile/core/utils/constants/exports_navigators.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';
import 'package:spa_mobile/features/service/presentation/bloc/service_bloc.dart';
import 'package:spa_mobile/features/service/presentation/widgets/service_vertical_card.dart';

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
    context.read<ServiceBloc>().add(GetListServicesEvent(1));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.extentAfter < 200) {
      final currentState = context.read<ServiceBloc>().state;
      if (currentState is ListServiceLoaded &&
          currentState.pagination.page < currentState.pagination.totalPage) {
        context
            .read<ServiceBloc>()
            .add(GetListServicesEvent(currentState.pagination.page + 1));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                Container(
                  height: 40,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (_, index) {
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
                            color: isSelected
                                ? TColors.primary
                                : TColors.lightGrey,
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
                              "Massage",
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
                    itemCount: 8,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: TSizes.md),
          Expanded(
            child: BlocBuilder<ServiceBloc, ServiceState>(
              builder: (context, state) {
                if (state is ServiceLoading) {
                  return const TLoader();
                } else if (state is ListServiceLoaded) {
                  return NotificationListener<ScrollNotification>(
                      onNotification: (scrollNotification) {
                        if (scrollNotification is ScrollEndNotification &&
                            _scrollController.position.extentAfter < 200) {
                          final currentState = state;
                          if (currentState.pagination.page <
                              currentState.pagination.totalPage) {
                            context.read<ServiceBloc>().add(
                                GetListServicesEvent(
                                    currentState.pagination.page + 1));
                          }
                        }
                        return false;
                      },
                      child: TGridLayout(
                        controller: _scrollController,
                        itemCount: state.services.length + 1,
                        crossAxisCount: 1,
                        itemBuilder: (context, index) {
                          if (index == state.services.length) {
                            return state.isLoadingMore
                                ? const TLoader()
                                : const SizedBox.shrink();
                          }
                          final service = state.services[index];
                          return TServiceCard(
                            service: service,
                          );
                        },
                      ));
                } else if (state is ServiceFailure) {
                  return Center(child: Text(state.message));
                }
                return Center(child: Text('No services available.'));
              },
            ),
          ),
        ],
      ),
    );
  }
}
