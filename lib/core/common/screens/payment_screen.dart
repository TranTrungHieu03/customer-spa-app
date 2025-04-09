import 'package:flutter/material.dart';
import 'package:spa_mobile/core/common/bloc/web_view/web_view_bloc.dart';
import 'package:spa_mobile/core/common/widgets/appbar.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';
import 'package:spa_mobile/core/utils/constants/exports_navigators.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentSuccessPage extends StatelessWidget {
  const PaymentSuccessPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppbar(
        title: const Text('Thanh toán thành công'),
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
              'Thanh toán thành công!',
              style: Theme
                  .of(context)
                  .textTheme
                  .displaySmall,
            ),
            const SizedBox(height: TSizes.md),
            Text(
              'Giao dịch của bạn đã được xử lý thành công.',
              textAlign: TextAlign.center,
              style: Theme
                  .of(context)
                  .textTheme
                  .bodyMedium,
            ),
            const SizedBox(height: TSizes.lg),
            ElevatedButton(
              onPressed: () {
                goHome();
              },
              child: const Text('Về trang chủ'),
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
        title: const Text('Thanh toán thất bại'),
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
              'Thanh toán thất bại',
              style: Theme
                  .of(context)
                  .textTheme
                  .displaySmall,
            ),
            const SizedBox(height: TSizes.md),
            Text(
              'Đã xảy ra lỗi trong quá trình xử lý thanh toán. Vui lòng thử lại.',
              textAlign: TextAlign.center,
              style: Theme
                  .of(context)
                  .textTheme
                  .bodyMedium,
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
              child: const Text('Về trang chủ'),
            ),
          ],
        ),
      ),
    );
  }
}
