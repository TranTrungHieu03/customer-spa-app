import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:spa_mobile/core/common/widgets/appbar.dart';
import 'package:spa_mobile/core/common/widgets/loader.dart';
import 'package:spa_mobile/core/common/widgets/show_snackbar.dart';
import 'package:spa_mobile/core/local_storage/local_storage.dart';
import 'package:spa_mobile/core/utils/constants/images.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';
import 'package:spa_mobile/features/analysis_skin/data/model/routine_model.dart';
import 'package:spa_mobile/features/analysis_skin/presentation/blocs/routine/routine_bloc.dart';
import 'package:spa_mobile/features/product/data/model/product_model.dart';
import 'package:spa_mobile/features/product/domain/usecases/get_list_products.dart';
import 'package:spa_mobile/features/product/presentation/bloc/list_product/list_product_bloc.dart';
import 'package:spa_mobile/features/service/data/model/service_model.dart';
import 'package:spa_mobile/features/service/presentation/bloc/list_service/list_service_bloc.dart';
import 'package:spa_mobile/features/service/presentation/bloc/service/service_bloc.dart';
import 'package:spa_mobile/init_dependencies.dart';

class WrapperAddToRoutine extends StatelessWidget {
  const WrapperAddToRoutine({super.key, required this.routineId, required this.routine});

  final String routineId;
  final RoutineModel routine;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(create: (context) => ListProductBloc(getListProducts: serviceLocator())),
      BlocProvider(create: (context) => ListServiceBloc(getListService: serviceLocator())),
    ], child: AddToRoutineScreen(routineId: routineId, routine: routine));
  }
}

class AddToRoutineScreen extends StatefulWidget {
  const AddToRoutineScreen({
    super.key,
    required this.routineId,
    required this.routine,
  });

  final String routineId;
  final RoutineModel routine;

  @override
  State<AddToRoutineScreen> createState() => _AddToRoutineScreenState();
}

class _AddToRoutineScreenState extends State<AddToRoutineScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<ProductModel> _selectedProducts = [];
  final List<ServiceModel> _selectedServices = [];
  int? selectedBranch;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadLocalData();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    context.read<ListProductBloc>().add(GetListProductsEvent(
        GetListProductParams(brand: "", page: 1, branchId: selectedBranch ?? 1, categoryId: [], minPrice: -1, maxPrice: -1, sortBy: "")));
    context.read<ListServiceBloc>().add(GetListServicesForSelectionEvent(1, selectedBranch ?? 1, 100));

    // context.read<ListProductBloc>().add(GetListProductsEvent(
    //     GetListProductParams(brand: "", page: 1, branchId: selectedBranch ?? 1, categoryId: [], minPrice: -1, maxPrice: -1, sortBy: "")));
    // // Load available services
    // context.read<ListServiceBloc>().add(GetListServicesForSelectionEvent(1, selectedBranch ?? 1, 100));
  }

  Future<void> _loadLocalData() async {
    final branchId = await LocalStorage.getData(LocalStorageKey.defaultBranch);
    if (mounted) {
      if (branchId == "") {
        // TSnackBar.warningSnackBar(context, message: "Vui lòng chọn chi nhánh để tiếp tục.");
        setState(() {
          selectedBranch = 1;
        });
        // context.read<BranchBloc>().add(GetBranchDetailEvent(GetBranchDetailParams(1)));
      } else {
        // branchInfo = BranchModel(branchId: branchId, branchName: branchName, branchAddress: branchAddress, branchPhone: branchPhone, longAddress: longAddress, latAddress: latAddress, status: status, managerId: managerId, district: district, wardCode: wardCode).fromJson(json.decode(await LocalStorage.getData(LocalStorageKey.branchInfo)));
        // AppLogger.debug(branchInfo);
        setState(() {
          selectedBranch = int.parse(branchId);
          //   previousBranch = selectedBranch;
        });
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _addSelectedItemsToRoutine() {
    // Logic to add selected products and services to the routine
    if (_selectedProducts.isEmpty && _selectedServices.isEmpty) {
      TSnackBar.infoSnackBar(context, message: AppLocalizations.of(context)!.no_items_selected);
      return;
    }

    // Add items to routine
    // context.read<RoutineBloc>().add(
    //     AddItemsToRoutineEvent(
    //       routineId: widget.routineId,
    //       products: _selectedProducts,
    //       services: _selectedServices,
    //     )
    // );
  }

  void _toggleProductSelection(ProductModel product) {
    setState(() {
      if (_selectedProducts.contains(product)) {
        _selectedProducts.remove(product);
      } else {
        _selectedProducts.add(product);
      }
    });
  }

  void _toggleServiceSelection(ServiceModel service) {
    setState(() {
      if (_selectedServices.contains(service)) {
        _selectedServices.remove(service);
      } else {
        _selectedServices.add(service);
      }
    });
  }

  bool _isProductInRoutine(int productId) {
    return widget.routine.productRoutines.any((productRoutine) => productRoutine.productId == productId);
  }

  bool _isServiceInRoutine(int serviceId) {
    return widget.routine.serviceRoutines.any((serviceRoutine) => serviceRoutine.serviceId == serviceId);
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
            branchId: selectedBranch ?? 1,
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
            tabs: [
              Tab(text: AppLocalizations.of(context)!.products),
              Tab(text: AppLocalizations.of(context)!.services),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Products Tab
                _buildProductsTab(),

                // Services Tab
                _buildServicesTab(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BlocListener<RoutineBloc, RoutineState>(
          listener: (context, state) {
            // if (state is RoutineUpdated) {
            // TSnackBar.successSnackBar(
            //     context,
            //     message: AppLocalizations.of(context)!.items_added_to_routine
            // );
            //   Navigator.pop(context, true); // Return with success
            // } else
            if (state is RoutineError) {
              TSnackBar.errorSnackBar(context, message: state.message);
            }
          },
          child: Padding(
              padding: const EdgeInsets.all(TSizes.sm),
              child: ElevatedButton(
                onPressed: _addSelectedItemsToRoutine,
                child: Text(AppLocalizations.of(context)!.add_to_routine),
              ))),
    );
  }

  Widget _buildProductsTab() {
    return BlocBuilder<ListProductBloc, ListProductState>(
      builder: (context, state) {
        if (state is ListProductLoaded) {
          final products = state.products;
          _selectedProducts.addAll(products.where((product) => _isProductInRoutine(product.productId)));

          if (products.isEmpty) {
            return Center(
              child: Text(
                AppLocalizations.of(context)!.no_products_available,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            );
          }

          return ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(TSizes.sm),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              final isSelected = _selectedProducts.contains(product);
              return _buildProductItem(product, isSelected);
            },
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
          _selectedServices.addAll(state.services.where((service) => _isServiceInRoutine(service.serviceId)));
          if (services.isEmpty) {
            return Center(
              child: Text(
                AppLocalizations.of(context)!.no_services_available,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(TSizes.sm),
            itemCount: services.length,
            itemBuilder: (context, index) {
              final service = services[index];
              final isSelected = _selectedServices.contains(service);

              return _buildServiceItem(service, isSelected);
            },
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
        subtitle: Text(
          product.brand,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        trailing: Checkbox(
          value: isSelected,
          onChanged: (_) => _toggleProductSelection(product),
        ),
        onTap: () => _toggleProductSelection(product),
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
        subtitle: Text(
          "${service.duration} ${AppLocalizations.of(context)!.minutes}",
          style: Theme.of(context).textTheme.bodySmall,
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
