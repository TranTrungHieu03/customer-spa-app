import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spa_mobile/core/utils/constants/colors.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';
import 'package:spa_mobile/features/home/presentation/blocs/navigation_bloc.dart';
import 'package:spa_mobile/features/home/presentation/screens/home_screen.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<NavigationBloc, NavigationState>(
        builder: (context, state) {
          if (state is NavigationIndexChangedState) {
            return state.screens[state.selectedIndex];
          } else {
            return const HomeScreen();
          }
        },
      ),
      bottomNavigationBar: BlocBuilder<NavigationBloc, NavigationState>(
        builder: (context, state) {
          return Container(
            height: 70,
            margin: const EdgeInsets.symmetric(horizontal: TSizes.sm),
            decoration: BoxDecoration(
              color: TColors.primary.withOpacity(0.2),
              borderRadius: const BorderRadius.all(Radius.circular(50)),
              backgroundBlendMode: BlendMode.multiply,
            ),
            child: BottomNavigationBar(
              currentIndex: state is NavigationIndexChangedState ? state.selectedIndex : 0,
              onTap: (index) {
                context.read<NavigationBloc>().add(ChangeSelectedIndexEvent(index));
              },
              type: BottomNavigationBarType.fixed,
              selectedItemColor: TColors.primary,
              unselectedItemColor: TColors.darkerGrey.withOpacity(0.8),
              landscapeLayout: BottomNavigationBarLandscapeLayout.spread,
              selectedLabelStyle: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
              unselectedIconTheme: const IconThemeData(size: 27),
              selectedIconTheme: const IconThemeData(size: 27),
              backgroundColor: TColors.primary.withOpacity(0.0),
              elevation: 0,
              showSelectedLabels: true,
              items: [
                BottomNavigationBarItem(icon: const Icon(Iconsax.home), label: AppLocalizations.of(context)!.home),
                BottomNavigationBarItem(icon: const Icon(Iconsax.mobile), label: AppLocalizations.of(context)!.products),
                BottomNavigationBarItem(icon: const Icon(Iconsax.note), label: AppLocalizations.of(context)!.services),
                BottomNavigationBarItem(icon: const Icon(Iconsax.setting_2), label: AppLocalizations.of(context)!.setting),
              ],
            ),
          );
        },
      ),
    );
  }
}
