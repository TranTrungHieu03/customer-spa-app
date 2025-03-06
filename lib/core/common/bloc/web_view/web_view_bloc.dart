import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spa_mobile/core/common/bloc/web_view/web_view_event.dart';
import 'package:spa_mobile/core/common/bloc/web_view/web_view_state.dart';
import 'package:spa_mobile/core/logger/logger.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewBloc extends Bloc<WebViewEvent, WebViewState> {
  late final WebViewController _controller;

  WebViewBloc() : super(WebViewInitial()) {
    on<InitializeWebViewEvent>(_onInitializeWebView);
    on<LoadUrlEvent>(_onLoadUrl);
    on<WebViewErrorEvent>(_onWebViewError);
  }

  Future<void> _onInitializeWebView(
    InitializeWebViewEvent event,
    Emitter<WebViewState> emit,
  ) async {
    _controller = WebViewController();

    _controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            emit(WebViewLoading());
            AppLogger.info('WebView is loading (progress : $progress%)');
          },
          onPageStarted: (String url) {
            add(LoadUrlEvent(url));
          },
          onPageFinished: (String url) {
            add(LoadUrlEvent(url));
          },
          onWebResourceError: (WebResourceError error) {
            add(WebViewErrorEvent("Error loading page: ${error.description}"));
          },
        ),
      )
      ..loadRequest(Uri.parse(event.url));

    emit(WebViewInitialized(_controller));
  }

  Future<void> _onLoadUrl(LoadUrlEvent event, Emitter<WebViewState> emit) async {
    emit(WebViewLoading());
    try {
      await _controller.loadRequest(Uri.parse(event.url));
      // emit(  (event.url));
    } catch (e) {
      emit(WebViewError("Failed to load URL: ${e.toString()}"));
    }
  }

  Future<void> _onWebViewError(
    WebViewErrorEvent event,
    Emitter<WebViewState> emit,
  ) async {
    emit(WebViewError(event.message));
  }

  WebViewController get controller => _controller;
}
