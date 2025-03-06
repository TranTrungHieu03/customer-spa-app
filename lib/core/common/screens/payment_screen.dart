import 'package:flutter/material.dart';
import 'package:spa_mobile/core/common/widgets/appbar.dart';
import 'package:spa_mobile/core/utils/constants/exports_navigators.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';

class PaymentSuccessPage extends StatelessWidget {
  const PaymentSuccessPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppbar(
        title: const Text('Payment Successful'),
        showBackArrow: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle_outline,
              color: Colors.green,
              size: 100,
            ),
            const SizedBox(height: TSizes.md),
            Text(
              'Payment Successful!',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: TSizes.md),
            Text(
              'Your transaction has been completed successfully.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: TSizes.lg),
            ElevatedButton(
              onPressed: () {
                goHome();
              },
              child: const Text('Return to Home'),
            ),
          ],
        ),
      ),
    );
  }
}

// Failure page after payment
class PaymentFailurePage extends StatelessWidget {
  const PaymentFailurePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppbar(
        title: const Text('Payment Failed'),
        showBackArrow: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 100,
            ),
            const SizedBox(height: TSizes.md),
            Text(
              'Payment Failed',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: TSizes.md),
            Text(
              'There was an issue processing your payment. Please try again.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: TSizes.lg),
            ElevatedButton(
              onPressed: () {
                // context.read<PaymentBloc>().add(RetryPayment());
              },
              child: const Text('Try Again'),
            ),
            const SizedBox(height: TSizes.md),
            TextButton(
              onPressed: () {
                goHome();
              },
              child: const Text('Return to Home'),
            ),
          ],
        ),
      ),
    );
  }
}
