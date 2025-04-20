import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:spa_mobile/features/product/data/model/product_category_model.dart';

part 'product_categories_event.dart';
part 'product_categories_state.dart';

class ProductCategoriesBloc extends Bloc<ProductCategoriesEvent, ProductCategoriesState> {
  ProductCategoriesBloc() : super(ProductCategoriesInitial()) {
    on<ProductCategoriesEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
