import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spa_mobile/core/common/bloc/payment_payos/payos_bloc.dart';
import 'package:spa_mobile/core/common/screens/payment_screen.dart';
import 'package:spa_mobile/core/common/widgets/appbar.dart';
import 'package:spa_mobile/core/logger/logger.dart';
import 'package:spa_mobile/core/utils/constants/exports_navigators.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebViewPage extends StatefulWidget {
  const PaymentWebViewPage({Key? key, required this.url, required this.id}) : super(key: key);
  final String url;
  final int id;

  @override
  _PaymentWebViewPageState createState() => _PaymentWebViewPageState();
}

class _PaymentWebViewPageState extends State<PaymentWebViewPage> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });

            if (url.contains('success')) {
              AppLogger.info("go success");
              context.read<PayosBloc>().add(PayosSuccessful());
            } else if (url.contains('cancel')) {
              context.read<PayosBloc>().add(PayosCancelled());
            } else if (url.contains('failure')) {
              context.read<PayosBloc>().add(PayosFailed());
            }
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('tel:') ||
                request.url.startsWith('mailto:') ||
                request.url.startsWith('sms:') ||
                request.url.startsWith('intent:') ||
                request.url.startsWith('app:')) {
              return NavigationDecision.prevent;
            }
            if (request.url.contains('success')) {
              AppLogger.info("go success");
              context.read<PayosBloc>().add(PayosSuccessful());
            } else if (request.url.contains('cancel')) {
              context.read<PayosBloc>().add(PayosCancelled());
            } else if (request.url.contains('failure')) {
              context.read<PayosBloc>().add(PayosFailed());
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PayosBloc, PayosState>(
      builder: (context, state) {
        if (state is PayosInitial) {
          context.read<PayosBloc>().add(PayosInitiated());
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is PayosLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is PayosWebViewLoaded) {
          return Scaffold(
            appBar: TAppbar(
              title: const Text('Payment'),
              showBackArrow: false,
              leadingIcon: Iconsax.arrow_left,
              leadingOnPressed: () => goBookingDetail(widget.id),
              actions: [
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () {
                    _controller.reload();
                  },
                ),
              ],
            ),
            body: Stack(
              children: [
                WebViewWidget(controller: _controller),
                if (_isLoading)
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
              ],
            ),
          );
        } else if (state is PayosSuccess) {
          return const PaymentSuccessPage();
        } else if (state is PayosFailure) {
          return const PaymentFailurePage();
        } else {
          return const Scaffold(
            body: Center(
              child: Text('Something went wrong'),
            ),
          );
        }
      },
    );
  }
}
