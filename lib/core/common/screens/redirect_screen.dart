import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spa_mobile/core/common/widgets/appbar.dart';
import 'package:spa_mobile/core/common/widgets/loader.dart';
import 'package:spa_mobile/core/common/widgets/show_snackbar.dart';
import 'package:spa_mobile/core/utils/constants/exports_navigators.dart';
import 'package:spa_mobile/features/service/presentation/bloc/payment/payment_bloc.dart';

class RedirectScreen extends StatefulWidget {
  const RedirectScreen({super.key, required this.id});

  final int id;

  @override
  State<RedirectScreen> createState() => _RedirectScreenState();
}

class _RedirectScreenState extends State<RedirectScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TAppbar(
        title: Text("Redirect to PayOs"),
      ),
      body: BlocListener<PaymentBloc, PaymentState>(
        listener: (context, state) {
          if (state is PaymentError) {
            TSnackBar.errorSnackBar(context, message: state.message);
          }
        },
        child: BlocBuilder<PaymentBloc, PaymentState>(builder: (context, state) {
          if (state is PaymentLoading) {
            return const TLoader();
          } else if (state is PaymentSuccess) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              goWebPayment(state.link, widget.id);
            });
            return const TLoader();
          }
          return const SizedBox();
        }),
      ),
    );
  }
}
