part of 'connectivity_bloc.dart';

class ConnectivityState extends Equatable {
  const ConnectivityState({
    required this.connectivityResult,
    required this.hasInternetAccessEnum,
  });

  factory ConnectivityState.fromJson(Map<String, dynamic> json) {
    return ConnectivityState(
      connectivityResult: json['connectivityResult'] != null ? ConnectivityResult.values[json['connectivityResult'] as int] : null,
      hasInternetAccessEnum: json['hasInternetAccessEnum'] != null ? HasInternetAccessEnum.values[json['hasInternetAccessEnum'] as int] : null,
    );
  }

  factory ConnectivityState.initial() => const ConnectivityState(
        connectivityResult: ConnectivityResult.none,
        hasInternetAccessEnum: null,
      );

  final ConnectivityResult? connectivityResult;
  final HasInternetAccessEnum? hasInternetAccessEnum;

  ConnectivityState copyWith({
    ConnectivityResult? connectivityResult,
    HasInternetAccessEnum? hasInternetAccessEnum,
  }) {
    return ConnectivityState(
      connectivityResult: connectivityResult ?? this.connectivityResult,
      hasInternetAccessEnum: hasInternetAccessEnum ?? this.hasInternetAccessEnum,
    );
  }

  // add this method toJson and fronJson
  Map<String, dynamic> toJson() {
    return {
      'connectivityResult': connectivityResult != null ? connectivityResult!.index : null,
      'hasInternetAccessEnum': hasInternetAccessEnum != null ? hasInternetAccessEnum!.index : null,
    };
  }

  @override
  List<Object?> get props => [
        connectivityResult,
        hasInternetAccessEnum,
      ];
}
