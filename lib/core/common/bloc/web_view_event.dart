import 'package:equatable/equatable.dart';

abstract class WebViewEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadUrlEvent extends WebViewEvent {
  final String url;

  LoadUrlEvent(this.url);

  @override
  List<Object?> get props => [url];
}

class InitializeWebViewEvent extends WebViewEvent {
  final String url;

  InitializeWebViewEvent(this.url);
}

class WebViewErrorEvent extends WebViewEvent {
  final String message;

  WebViewErrorEvent(this.message);

  @override
  List<Object?> get props => [message];
}
