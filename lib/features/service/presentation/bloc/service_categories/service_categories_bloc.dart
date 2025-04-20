import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:spa_mobile/features/service/data/model/category_model.dart';

part 'service_categories_event.dart';
part 'service_categories_state.dart';

class ServiceCategoriesBloc extends Bloc<ServiceCategoriesEvent, ServiceCategoriesState> {
  ServiceCategoriesBloc() : super(ServiceCategoriesInitial()) {
    on<ServiceCategoriesEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
