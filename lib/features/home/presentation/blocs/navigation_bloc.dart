import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:spa_mobile/features/home/presentation/screens/home_screen.dart';
import 'package:spa_mobile/features/product/presentation/screens/products_screen.dart';
import 'package:spa_mobile/features/service/presentation/screens/service_screen.dart';

part 'navigation_event.dart';
part 'navigation_state.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  final List<Widget> screens = [
    const HomeScreen(),
    const ProductsScreen(),
    const ServiceScreen(),
    const HomeScreen(),
  ];

  NavigationBloc() : super(NavigationInitialState(0, [])) {
    on<ChangeSelectedIndexEvent>((event, emit) {
      emit(NavigationIndexChangedState(event.index, screens));
    });
  }
}
