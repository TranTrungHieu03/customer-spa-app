import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:spa_mobile/core/common/widgets/show_snackbar.dart';
import 'package:spa_mobile/core/utils/constants/exports_navigators.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';
import 'package:spa_mobile/features/product/domain/usecases/feedback_product.dart';
import 'package:spa_mobile/features/product/presentation/bloc/feedback_product/feedback_product_bloc.dart';
import 'package:spa_mobile/init_dependencies.dart';

class ProductFeedbackScreen extends StatefulWidget {
  const ProductFeedbackScreen({super.key, required this.customerId, required this.productId, required this.orderId});

  final int customerId;
  final int productId;
  final int orderId;

  @override
  State<ProductFeedbackScreen> createState() => _ProductFeedbackScreenState();
}

class _ProductFeedbackScreenState extends State<ProductFeedbackScreen> {
  double _rating = 5;
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FeedbackProductBloc>(
      create: (context) => FeedbackProductBloc(feedbackProduct: serviceLocator()),
      child: Scaffold(
        appBar: AppBar(),
        body: BlocListener<FeedbackProductBloc, FeedbackProductState>(
          listener: (context, state) {
            if (state is FeedbackProductLoaded) {
              _submitRating();
            } else if (state is FeedbackProductError) {
              TSnackBar.errorSnackBar(context, message: state.message);
            }
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(TSizes.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context)!.rate_our_product,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 20),
                  RatingBar.builder(
                    initialRating: 5,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: false,
                    itemCount: 5,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      setState(() {
                        _rating = rating;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  Form(
                    child: TextField(
                      controller: _controller,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!.enter_your_feedback,
                        contentPadding: const EdgeInsets.symmetric(horizontal: TSizes.sm, vertical: TSizes.md),
                        hintStyle: Theme.of(context).textTheme.bodySmall,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      onSubmitted: (value) {
                        setState(() {});
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Builder(
          builder: (context) => Padding(
            padding: EdgeInsets.only(
                top: TSizes.sm, left: TSizes.sm, right: TSizes.sm, bottom: TSizes.sm + MediaQuery.of(context).viewInsets.bottom),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<FeedbackProductBloc>().add(
                            SendFeedbackProductEvent(
                              FeedbackProductParams(
                                productId: widget.productId,
                                customerId: widget.customerId,
                                comment: _controller.text.trim(),
                                rating: _rating,
                              ),
                            ),
                          );
                    },
                    child: Text(
                      AppLocalizations.of(context)!.submit_review,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submitRating() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.thank_you),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                goOrderProductDetail(widget.orderId);
              },
              child: Text(AppLocalizations.of(context)!.close),
            ),
          ],
        );
      },
    );
  }
}
