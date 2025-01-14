import 'package:equatable/equatable.dart';
import 'package:webview_flutter/webview_flutter.dart';

abstract class WebViewState extends Equatable {
  @override
  List<Object?> get props => [];
}

class WebViewInitial extends WebViewState {}

class WebViewInitialized extends WebViewState {
  final WebViewController controller;

  WebViewInitialized(this.controller);

  @override
  List<Object?> get props => [controller];
}

class WebViewLoading extends WebViewState {}
//
// class WebViewLoaded extends WebViewState {
//   final String url;
//
//   WebViewLoaded(this.url);
//
//   @override
//   List<Object?> get props => [url];
// }

class WebViewError extends WebViewState {
  final String message;

  WebViewError(this.message);

  @override
  List<Object?> get props => [message];
}
