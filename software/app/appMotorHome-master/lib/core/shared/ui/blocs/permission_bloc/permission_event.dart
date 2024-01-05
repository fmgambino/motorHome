part of 'permission_bloc.dart';

sealed class PermissionEvent extends Equatable {
  const PermissionEvent();

  @override
  List<Object> get props => [];
}

class RequestPermissionEvent extends PermissionEvent {}

class UpdatePermissionEvent extends PermissionEvent {}
