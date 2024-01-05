enum HasInternetAccessEnum {
  hasInternetAccess('Se recuperó la conexión a Internet'),
  noInternetAccess('Se ha perdido la conexión a Internet'),
  none('Desconocido');

  const HasInternetAccessEnum(this.message);

  final String message;
}
