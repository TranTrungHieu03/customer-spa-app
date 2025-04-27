import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:spa_mobile/core/common/inherited/mix_data.dart';
import 'package:spa_mobile/core/common/widgets/appbar.dart';
import 'package:spa_mobile/core/common/widgets/loader.dart';
import 'package:spa_mobile/core/common/widgets/shimmer.dart';
import 'package:spa_mobile/core/common/widgets/show_snackbar.dart';
import 'package:spa_mobile/core/helpers/helper_functions.dart';
import 'package:spa_mobile/core/local_storage/local_storage.dart';
import 'package:spa_mobile/core/logger/logger.dart';
import 'package:spa_mobile/core/utils/constants/colors.dart';
import 'package:spa_mobile/core/utils/constants/exports_navigators.dart';
import 'package:spa_mobile/core/utils/constants/images.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';
import 'package:spa_mobile/features/analysis_skin/data/model/routine_model.dart';
import 'package:spa_mobile/features/analysis_skin/presentation/blocs/routine/routine_bloc.dart';
import 'package:spa_mobile/features/auth/data/models/user_model.dart';
import 'package:spa_mobile/features/product/data/model/product_model.dart';
import 'package:spa_mobile/features/product/domain/usecases/get_list_products.dart';
import 'package:spa_mobile/features/product/presentation/bloc/list_product/list_product_bloc.dart';
import 'package:spa_mobile/features/product/presentation/widgets/product_price.dart';
import 'package:spa_mobile/features/service/data/model/service_model.dart';
import 'package:spa_mobile/features/service/presentation/bloc/list_service/list_service_bloc.dart';
import 'package:spa_mobile/features/service/presentation/bloc/service/service_bloc.dart';
import 'package:spa_mobile/init_dependencies.dart';

class WrapperAddToRoutine extends StatelessWidget {
  const WrapperAddToRoutine({super.key, required this.routineId, required this.routine, required this.branchId, required this.controller});

  final String routineId;
  final RoutineModel routine;
  final int branchId;
  final MixDataController controller;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(create: (context) => ListProductBloc(getListProducts: serviceLocator())),
      BlocProvider(create: (context) => ListServiceBloc(getListService: serviceLocator())),
    ], child: AddToRoutineScreen(routineId: routineId, routine: routine, branchId: branchId, controller: controller));
  }
}

class AddToRoutineScreen extends StatefulWidget {
  const AddToRoutineScreen({
    super.key,
    required this.routineId,
    required this.routine,
    required this.branchId,
    required this.controller,
  });

  final String routineId;
  final RoutineModel routine;
  final int branchId;
  final MixDataController controller;

  @override
  State<AddToRoutineScreen> createState() => _AddToRoutineScreenState();
}

class _AddToRoutineScreenState extends State<AddToRoutineScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<ProductModel> _selectedProducts = [];
  final List<ServiceModel> _selectedServices = [];
  late ScrollController _scrollController;
  final Set<int> _manuallyRemovedProductIds = {};
  final Set<int> _manuallyRemovedServiceIds = {};
  double totalPrice = 0.0;
  bool _initialized = false;
  UserModel? user;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    _loadLocalData();
  }

  Future<void> _loadLocalData() async {
    final userJson = await LocalStorage.getData(LocalStorageKey.userKey);
    if (jsonDecode(userJson) != null) {
      user = UserModel.fromJson(jsonDecode(userJson));
    } else {
      goLoginNotBack();
    }

    // if (user?.district == 0 || user?.wardCode == 0) {
    //   TSnackBar.infoSnackBar(context, message: AppLocalizations.of(context)!.update_address_to_purchase);
    //   // goProfile();
    // }

    context.read<ListProductBloc>().add(GetListProductsEvent(
          GetListProductParams(
            brand: "",
            page: 1,
            branchId: widget.branchId,
            categoryId: [],
            minPrice: -1,
            maxPrice: -1,
            sortBy: "",
          ),
        ));

    context.read<ListServiceBloc>().add(GetListServicesForSelectionEvent(
          1,
          widget.branchId,
          100,
        ));
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _addSelectedItemsToRoutine() {
    if (_selectedProducts.isEmpty && _selectedServices.isEmpty) {
      TSnackBar.infoSnackBar(context, message: AppLocalizations.of(context)!.no_items_selected);
      return;
    }
  }

  void _calculateTotalPrice() {
    double newTotalPrice = 0.0;

    for (var product in _selectedProducts) {
      newTotalPrice += product.price;
    }

    for (var service in _selectedServices) {
      newTotalPrice += service.price;
    }

    setState(() {
      totalPrice = newTotalPrice;
    });
  }

  void _toggleProductSelection(ProductModel product) {
    setState(() {
      if (_selectedProducts.contains(product)) {
        _selectedProducts.remove(product);
        setState(() {
          totalPrice -= product.price;
        });
        if (_isProductInRoutine(product.productId)) {
          _manuallyRemovedProductIds.add(product.productId);
        }
      } else {
        _selectedProducts.add(product);
        setState(() {
          totalPrice += product.price;
        });
        _manuallyRemovedProductIds.remove(product.productId);
      }
    });
  }

  void _toggleServiceSelection(ServiceModel service) {
    setState(() {
      if (_selectedServices.contains(service)) {
        _selectedServices.remove(service);
        setState(() {
          totalPrice -= service.price;
        });
        if (_isServiceInRoutine(service.serviceId)) {
          _manuallyRemovedServiceIds.add(service.serviceId);
        }
      } else {
        _selectedServices.add(service);
        setState(() {
          totalPrice += service.price;
        });
        _manuallyRemovedServiceIds.remove(service.serviceId);
      }
    });
  }

  bool _isProductInRoutine(int productId) {
    return widget.routine.productRoutines.any((productRoutine) => productRoutine.productId == productId);
  }

  bool _isServiceInRoutine(int serviceId) {
    return widget.routine.serviceRoutines.any((serviceRoutine) => serviceRoutine.serviceId == serviceId);
  }

  void _initializeWithRoutineItems(List<ProductModel> products, List<ServiceModel> services) {
    if (_initialized) return;

    // Reset total price to ensure we don't double count
    totalPrice = 0.0;

    // Calculate initial price from products in routine
    for (var product in products) {
      if (_isProductInRoutine(product.productId) && !_manuallyRemovedProductIds.contains(product.productId)) {

        if (!_selectedProducts.any((p) => p.productId == product.productId)) {
          _selectedProducts.add(product);
          totalPrice += product.price;
        }
      }
    }

    // Calculate initial price from services in routine
    for (var service in services) {
      if (_isServiceInRoutine(service.serviceId) && !_manuallyRemovedServiceIds.contains(service.serviceId)) {
        if (!_selectedServices.any((s) => s.serviceId == service.serviceId)) {
          _selectedServices.add(service);
          totalPrice += service.price;
        }
      }
    }

    _initialized = true;
    // Force UI update to reflect the initial price
    // setState(() {});
  }

  void _onScroll() {
    if (_scrollController.position.extentAfter < 200) {
      final currentState = context.read<ListProductBloc>().state;
      if (currentState is ListProductLoaded &&
          !currentState.isLoadingMore &&
          currentState.pagination.page < currentState.pagination.totalPage) {
        context.read<ListProductBloc>().add(GetListProductsEvent(GetListProductParams(
            brand: "",
            page: currentState.pagination.page + 1,
            branchId: widget.branchId,
            categoryId: [],
            minPrice: -1,
            maxPrice: -1,
            sortBy: "")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppbar(
        showBackArrow: true,
        title: Text(
          AppLocalizations.of(context)!.add_to_routine,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            labelColor: TColors.primary,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.black,
            tabs: [
              Tab(text: AppLocalizations.of(context)!.products),
              Tab(text: AppLocalizations.of(context)!.services),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildProductsTab(),
                _buildServicesTab(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BlocListener<RoutineBloc, RoutineState>(
          listener: (context, state) {
            if (state is RoutineError) {
              TSnackBar.errorSnackBar(context, message: state.message);
            }
          },
          child: Padding(
              padding: const EdgeInsets.all(TSizes.sm),
              child: ElevatedButton(
                onPressed: () {
                  if (_selectedServices.isEmpty && _selectedProducts.isEmpty){
                    TSnackBar.warningSnackBar(context, message: "Vui lòng chọn ít nhất 1 sản phẩm hoặc dịch vụ để tiếp tục");
                    return;
                  }
                  widget.controller.updateProducts(_selectedProducts);
                  widget.controller.updateServices(_selectedServices);
                  widget.controller.updateUser(user ?? UserModel.empty());
                  goCustomize(widget.controller);
                },
                child: Text(AppLocalizations.of(context)!.add_to_routine),
              ))),
    );
  }

  Widget _buildProductsTab() {
    return BlocBuilder<ListProductBloc, ListProductState>(
      builder: (context, state) {
        if (state is ListProductLoaded) {
          final products = state.products;

          if (products.isNotEmpty) {
            // Get the services for initialization
            final serviceState = context.read<ListServiceBloc>().state;
            List<ServiceModel> services = [];
            if (serviceState is ListServiceLoadedForSelection) {
              services = serviceState.services;
            }

            // Initialize with items from routine
            _initializeWithRoutineItems(products, services);
          }

          return Column(
            children: [
              _buildSelectedItemsHeader(_selectedProducts, true),
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(TSizes.sm),
                  itemCount: products.length + (state.isLoadingMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == products.length && state.isLoadingMore) {
                      return TShimmerEffect(width: THelperFunctions.screenWidth(context), height: TSizes.shimmerMd);
                    }
                    final product = products[index];
                    final isSelected = _selectedProducts.contains(product);
                    return _buildProductItem(product, isSelected);
                  },
                ),
              ),
            ],
          );
        } else if (state is ListProductLoading) {
          return const Center(child: TLoader());
        } else {
          return Center(
            child: Text(
              AppLocalizations.of(context)!.failed_to_load_products,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          );
        }
      },
    );
  }

  Widget _buildServicesTab() {
    return BlocBuilder<ListServiceBloc, ListServiceState>(
      builder: (context, state) {
        if (state is ListServiceLoadedForSelection) {
          final services = state.services;

          if (services.isNotEmpty) {
            // Get the products for initialization
            final productState = context.read<ListProductBloc>().state;
            List<ProductModel> products = [];
            if (productState is ListProductLoaded) {
              products = productState.products;
            }

            // Initialize with items from routine
            _initializeWithRoutineItems(products, services);
          }

          return Column(
            children: [
              _buildSelectedItemsHeader(_selectedServices, false),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(TSizes.sm),
                  itemCount: services.length,
                  itemBuilder: (context, index) {
                    final service = services[index];
                    final isSelected = _selectedServices.contains(service);
                    return _buildServiceItem(service, isSelected);
                  },
                ),
              ),
            ],
          );
        } else if (state is ServiceLoading) {
          return const Center(child: TLoader());
        } else {
          return Center(
            child: Text(
              AppLocalizations.of(context)!.failed_to_load_services,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          );
        }
      },
    );
  }

  Widget _buildProductItem(ProductModel product, bool isSelected) {
    return Card(
      margin: const EdgeInsets.only(bottom: TSizes.sm),
      borderOnForeground: false,
      color: Colors.white,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: TSizes.md,
          vertical: TSizes.xs,
        ),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: product.images!.isNotEmpty ? NetworkImage(product.images![0]) : const AssetImage(TImages.product1) as ImageProvider,
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(TSizes.xs),
          ),
        ),
        title: Text(
          product.productName,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        subtitle: TProductPriceText(price: product.price.toString()),
        trailing: Checkbox(
          value: isSelected,
          onChanged: (_) => _toggleProductSelection(product),
        ),
        onTap: () => _toggleProductSelection(product),
      ),
    );
  }

  Widget _buildSelectedItemsHeader(List<dynamic> selectedItems, bool isProduct) {
    if (selectedItems.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TSizes.sm, vertical: TSizes.xs),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: selectedItems.map((item) {
            final name = isProduct ? (item as ProductModel).productName : (item as ServiceModel).name;
            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Chip(
                label: Text(name),
                backgroundColor: Colors.green.shade100,
                deleteIcon: const Icon(Icons.close),
                onDeleted: () {
                  setState(() {
                    if (isProduct) {
                      _toggleProductSelection(item as ProductModel);
                    } else {
                      _toggleServiceSelection(item as ServiceModel);
                    }
                  });
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildServiceItem(ServiceModel service, bool isSelected) {
    return Card(
      margin: const EdgeInsets.only(bottom: TSizes.sm),
      color: Colors.white,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: TSizes.md,
          vertical: TSizes.xs,
        ),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: service.images.isNotEmpty ? NetworkImage(service.images[0]) : const AssetImage(TImages.product1) as ImageProvider,
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(TSizes.xs),
          ),
        ),
        title: Text(
          service.name,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${service.duration} ${AppLocalizations.of(context)!.minutes}",
              style: Theme.of(context).textTheme.bodySmall,
            ),
            TProductPriceText(price: service.price.toString())
          ],
        ),
        trailing: Checkbox(
          value: isSelected,
          onChanged: (_) => _toggleServiceSelection(service),
        ),
        onTap: () => _toggleServiceSelection(service),
      ),
    );
  }
}
