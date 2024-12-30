import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:spa_mobile/core/common/widgets/loader.dart';
import 'package:spa_mobile/core/common/widgets/show_snackbar.dart';
import 'package:spa_mobile/core/helpers/helper_functions.dart';
import 'package:spa_mobile/core/utils/constants/exports_navigators.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';
import 'package:spa_mobile/features/home/presentation/blocs/image_bloc.dart';

class BasicScreenImage extends StatefulWidget {
  const BasicScreenImage({super.key, required this.image});

  final String image;

  @override
  State<BasicScreenImage> createState() => _BasicScreenImageState();
}

class _BasicScreenImageState extends State<BasicScreenImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Your Photo")),
      body: BlocConsumer<ImageBloc, ImageState>(
        listener: (context, state) {
          if (state is ImageInvalid) {
            TSnackBar.warningSnackBar(context, message: state.error);
            goHome();
          } else if (state is ImageValid) {}
        },
        builder: (context, state) {
          if (state is ImageLoading) {
            return const TLoader();
          } else if (state is ImagePicked) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    width: THelperFunctions.screenWidth(context),
                    height: THelperFunctions.screenHeight(context) * 0.6,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(TSizes.md),
                    ),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(TSizes.md),
                        child: Image.file(
                          File(state.imagePath),
                          fit: BoxFit.cover,
                        ))),
                const SizedBox(height: TSizes.md),
                ElevatedButton(
                  onPressed: () {
                    context
                        .read<ImageBloc>()
                        .add(ValidateImageEvent(state.imagePath));
                  },
                  child: Text(AppLocalizations.of(context)!.submit),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
