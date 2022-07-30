class iDefinition {
  final String idefinition;

  iDefinition({this.idefinition});

  factory iDefinition.fromJson(Map<String, dynamic> json) {
    return iDefinition(
      idefinition: json['definition'],
    );
  }
}
