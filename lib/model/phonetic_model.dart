import 'package:iDefine/model/license_model.dart';

class PhoneticsList {
  final List<Phonetic> phonetics;

  PhoneticsList({
    required this.phonetics,
  });

  factory PhoneticsList.fromJson(List<dynamic> parsedJson) {
    List<Phonetic> phonetics = <Phonetic>[];
    phonetics = parsedJson.map((i) => Phonetic.fromJson(i)).toList();

    return new PhoneticsList(phonetics: phonetics);
  }
}

class Phonetic {
  final String text;
  final String audio;
  final String sourceUrl;
  final List<License> license;

  Phonetic({
    required this.text,
    required this.audio,
    required this.sourceUrl,
    required this.license,
  });

  factory Phonetic.fromJson(Map<String, dynamic> parsedJson) {
    var licensesFromJson = parsedJson['license'];
    List<License> licensesList = licensesFromJson.cast<Phonetic>();

    return Phonetic(
      text: parsedJson['text'],
      audio: parsedJson['audio'],
      sourceUrl: parsedJson['sourceUrl'],
      license: licensesList,
    );
  }
}
