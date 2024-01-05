part of 'global_bloc.dart';

sealed class GlobalEvent extends Equatable {
  const GlobalEvent();

  @override
  List<Object> get props => [];
}

class AddRequestError extends GlobalEvent {
  const AddRequestError(this.requestError);

  final DioErrorAdapter requestError;

  @override
  List<Object> get props => [requestError];
}

class RemoveRequestError extends GlobalEvent {
  const RemoveRequestError();

  @override
  List<Object> get props => [];
}

class ChangeHasInternetAccess extends GlobalEvent {
  const ChangeHasInternetAccess(this.hasInternetAccess);

  final HasInternetAccessEnum hasInternetAccess;

  @override
  List<Object> get props => [hasInternetAccess];
}
