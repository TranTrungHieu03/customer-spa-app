import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spa_mobile/core/common/bloc/web_view_bloc.dart';
import 'package:spa_mobile/core/common/bloc/web_view_event.dart';
import 'package:spa_mobile/core/common/bloc/web_view_state.dart';
import 'package:spa_mobile/core/common/screens/error_screen.dart';
import 'package:spa_mobile/core/common/widgets/appbar.dart';
import 'package:spa_mobile/core/common/widgets/loader.dart';
import 'package:spa_mobile/core/common/widgets/show_snackbar.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({super.key, required this.url});

  final String url;

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  @override
  void initState() {
    super.initState();
    context.read<WebViewBloc>().add(InitializeWebViewEvent(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TAppbar(
        showBackArrow: true,
      ),
      body: BlocConsumer<WebViewBloc, WebViewState>(
        builder: (context, state) {
          if (state is WebViewInitialized) {
            return WebViewWidget(controller: state.controller);
          } else if (state is WebViewLoading) {
            return const TLoader();
          }
          return const TErrorBody();
        },
        listener: (context, state) {
          if (state is WebViewError) {
            TSnackBar.errorSnackBar(context, message: state.message);
          }
        },
      ),
    );
  }
}
