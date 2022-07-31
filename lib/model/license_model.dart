class License {
  final String name;
  final String url;

  License({
    required this.name,
    required this.url,
  });

  factory License.fromJson(Map<String, dynamic> parsedJson) {
    return License(
      name: parsedJson['text'],
      url: parsedJson['url'],
    );
  }
}
