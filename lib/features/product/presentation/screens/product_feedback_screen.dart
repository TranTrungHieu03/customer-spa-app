import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
                    'Hãy đánh giá sản phẩm của chúng tôi:',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 20),
                  RatingBar.builder(
                    initialRating: 5,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
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
                  Text(
                    'Bạn đã đánh giá: $_rating sao',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 20),
                  Form(
                    child: TextField(
                      controller: _controller,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: "Enter your feedback ...",
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
            padding: const EdgeInsets.all(TSizes.sm),
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
                      'Gửi đánh giá',
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
          title: const Text('Cảm ơn bạn!'),
          content: Text('Bạn đã đánh giá $_rating sao.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                goOrderProductDetail(widget.orderId);
              },
              child: const Text('Đóng'),
            ),
          ],
        );
      },
    );
  }
}
