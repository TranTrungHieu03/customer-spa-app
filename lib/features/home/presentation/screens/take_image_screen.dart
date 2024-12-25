import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spa_mobile/features/home/presentation/blocs/image_bloc.dart';

class TakeImageScreen extends StatefulWidget {
  const TakeImageScreen({super.key});

  @override
  State<TakeImageScreen> createState() => _TakeImageScreenState();
}

class _TakeImageScreenState extends State<TakeImageScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ImageBloc(),
      child: Scaffold(
        appBar: AppBar(title: Text("Image Validation")),
        body: BlocConsumer<ImageBloc, ImageState>(
          listener: (context, state) {
            if (state is ImageInvalid) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            } else if (state is ImageValid) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Image is valid!")),
              );
            }
          },
          builder: (context, state) {
            if (state is ImageLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is ImagePicked) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.file(File(state.imagePath)),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context
                          .read<ImageBloc>()
                          .add(ValidateImageEvent(state.imagePath));
                    },
                    child: Text("Validate Image"),
                  ),
                ],
              );
            }

            return Center(
              child: ElevatedButton(
                onPressed: () {
                  context.read<ImageBloc>().add(PickImageEvent());
                },
                child: Text("Pick Image"),
              ),
            );
          },
        ),
      ),
    );
  }
}
