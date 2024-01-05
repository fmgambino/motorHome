part of 'connectivity_bloc.dart';

sealed class ConnectivityEvent extends Equatable {
  const ConnectivityEvent();

  @override
  List<Object> get props => [];
}

class CheckConnectivity extends ConnectivityEvent {}

class ConnectivitySubscription extends ConnectivityEvent {}

class ConnectivityUnsubscription extends ConnectivityEvent {}

class HasInternetAccess extends ConnectivityEvent {}
