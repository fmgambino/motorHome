part of 'global_bloc.dart';

class GlobalState extends Equatable {
  const GlobalState({
    required this.requestError,
    required this.hasInternetAccess,
  });

  factory GlobalState.fromJson(Map<String, dynamic> json) {
    return GlobalState(
      requestError: json['requestError'] as DioErrorAdapter?,
      hasInternetAccess: json['hasInternetAccess'] != null ? json['hasInternetAccess'] as HasInternetAccessEnum : null,
    );
  }

  factory GlobalState.initial() {
    return const GlobalState(
      requestError: null,
      hasInternetAccess: HasInternetAccessEnum.none,
    );
  }

  GlobalState copyWith({
    DioErrorAdapter? requestError,
    HasInternetAccessEnum? hasInternetAccess,
  }) {
    return GlobalState(
      requestError: requestError ?? this.requestError,
      hasInternetAccess: hasInternetAccess ?? this.hasInternetAccess,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'requestError': requestError,
    };
  }

  @override
  String toString() {
    return 'GlobalState { requestError: $requestError, hasInternetAccess: $hasInternetAccess}';
  }

  final DioErrorAdapter? requestError;
  final HasInternetAccessEnum? hasInternetAccess;

  @override
  List<Object?> get props => [
        requestError,
        hasInternetAccess,
      ];
}
