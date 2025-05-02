import 'dart:async';

import 'package:http/http.dart' as http;
import 'dart:convert';

var baseDatamuseURL = 'https://api.datamuse.com/words?';
var spelledLikeURL = baseDatamuseURL + 'sp=';
var soundsLikeURL = baseDatamuseURL + 'sl=';
var relatedToURL = baseDatamuseURL + 'rel_trg=';
var rhymesWithURL = baseDatamuseURL + 'rel_rhy=';
var followedByURL = baseDatamuseURL + 'lc=';
var precededByURL = baseDatamuseURL + 'rc=';
var nounsModifiedURL = baseDatamuseURL + 'rel_jja=';
var adjectivesModifiedURL = baseDatamuseURL + 'rel_jjb=';
var synonymsURL = baseDatamuseURL + 'rel_syn=';
var antonymsURL = baseDatamuseURL + 'rel_ant=';
var hypernymsURL = baseDatamuseURL + 'rel_spc=';
var hyponymsURL = baseDatamuseURL + 'rel_gen=';
var holonymsURL = baseDatamuseURL + 'rel_com=';
var meronymsURL = baseDatamuseURL + 'rel_par=';

Future<List<String>?> getSimilarSpeltWords(String wordToDefine) async {
  List<String>? similarSpeltWords = [];
  try {
    final response = await http
        .get(
      Uri.parse(spelledLikeURL + wordToDefine + '&max=100'),
    )
        .timeout(const Duration(seconds: 5), onTimeout: () {
      throw TimeoutException("getSimilarSpeltWords() timeout");
    });
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      final parsedJson = json.decode(response.body);
      var rest = parsedJson as List;
      for (var i = 0; i < rest.length; i++) {
        if (rest[i]["word"].toLowerCase() == wordToDefine.toLowerCase()) {
          continue;
        }
        String word = rest[i]["word"][0].toUpperCase() +
            rest[i]["word"].substring(1).toLowerCase();
        similarSpeltWords.add(word);
      }

      // debugPrint('similarWordsList: ${similarSpeltWords}');
      return similarSpeltWords;
    } else if (response.statusCode == 404) {}
  } on TimeoutException catch (_) {
    return null;
  }
  return null;
}

Future<List<String>?> getSimilarSoundingWords(String wordToDefine) async {
  List<String>? similarSoundingWords = [];
  try {
    final response = await http
        .get(
      Uri.parse(soundsLikeURL + wordToDefine + '&max=100'),
    )
        .timeout(const Duration(seconds: 5), onTimeout: () {
      throw TimeoutException("getSimilarSoundingWords() timeout");
    });
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      final parsedJson = json.decode(response.body);
      var rest = parsedJson as List;
      for (var i = 0; i < rest.length; i++) {
        if (rest[i]["word"].toLowerCase() == wordToDefine.toLowerCase()) {
          continue;
        }
        String word = rest[i]["word"][0].toUpperCase() +
            rest[i]["word"].substring(1).toLowerCase();
        similarSoundingWords.add(word);
      }

      // debugPrint('similarSoundingWords: ${similarSoundingWords}');
      return similarSoundingWords;
    } else if (response.statusCode == 404) {}
  } on TimeoutException catch (_) {
    return null;
  }
  return null;
}

Future<List<String>?> getRelatedWords(String wordToDefine) async {
  List<String>? relatedWords = [];
  try {
    final response = await http
        .get(
      Uri.parse(relatedToURL + wordToDefine + '&max=100'),
    )
        .timeout(const Duration(seconds: 5), onTimeout: () {
      throw TimeoutException("getRelatedWords() timeout");
    });
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      final parsedJson = json.decode(response.body);
      var rest = parsedJson as List;
      for (var i = 0; i < rest.length; i++) {
        if (rest[i]["word"].toLowerCase() == wordToDefine.toLowerCase()) {
          continue;
        }
        String word = rest[i]["word"][0].toUpperCase() +
            rest[i]["word"].substring(1).toLowerCase();
        relatedWords.add(word);
      }
      return relatedWords;
    } else if (response.statusCode == 404) {}
  } on TimeoutException catch (_) {
    return null;
  }
  return null;
}

Future<List<String>?> getRhymingWords(String wordToDefine) async {
  List<String>? relatedWords = [];
  try {
    final response = await http
        .get(
      Uri.parse(rhymesWithURL + wordToDefine + '&max=100'),
    )
        .timeout(const Duration(seconds: 5), onTimeout: () {
      throw TimeoutException("getRhymingWords() timeout");
    });
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      final parsedJson = json.decode(response.body);
      var rest = parsedJson as List;
      for (var i = 0; i < rest.length; i++) {
        if (rest[i]["word"].toLowerCase() == wordToDefine.toLowerCase()) {
          continue;
        }
        String word = rest[i]["word"][0].toUpperCase() +
            rest[i]["word"].substring(1).toLowerCase();
        relatedWords.add(word);
      }
      return relatedWords;
    } else if (response.statusCode == 404) {}
  } on TimeoutException catch (_) {
    return null;
  }
  return null;
}

Future<List<String>?> getFollowedByWords(String wordToDefine) async {
  List<String>? relatedWords = [];
  try {
    final response = await http
        .get(
      Uri.parse(followedByURL + wordToDefine + '&sp=*' + '&max=100'),
    )
        .timeout(const Duration(seconds: 5), onTimeout: () {
      throw TimeoutException("getFollowedByWords() timeout");
    });
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      final parsedJson = json.decode(response.body);
      var rest = parsedJson as List;
      for (var i = 0; i < rest.length; i++) {
        if (rest[i]["word"].toLowerCase() == wordToDefine.toLowerCase()) {
          continue;
        }
        String word = rest[i]["word"][0].toUpperCase() +
            rest[i]["word"].substring(1).toLowerCase();
        relatedWords.add(word);
      }
      return relatedWords;
    } else if (response.statusCode == 404) {}
  } on TimeoutException catch (_) {
    return null;
  }
  return null;
}

Future<List<String>?> getPrecededByWords(String wordToDefine) async {
  List<String>? relatedWords = [];
  try {
    final response = await http
        .get(
      Uri.parse(precededByURL + wordToDefine + '&sp=*' + '&max=100'),
    )
        .timeout(const Duration(seconds: 5), onTimeout: () {
      throw TimeoutException("getPrecededByWords() timeout");
    });
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      final parsedJson = json.decode(response.body);
      var rest = parsedJson as List;
      for (var i = 0; i < rest.length; i++) {
        if (rest[i]["word"].toLowerCase() == wordToDefine.toLowerCase()) {
          continue;
        }
        String word = rest[i]["word"][0].toUpperCase() +
            rest[i]["word"].substring(1).toLowerCase();
        relatedWords.add(word);
      }
      return relatedWords;
    } else if (response.statusCode == 404) {}
  } on TimeoutException catch (_) {
    return null;
  }
  return null;
}

Future<List<String>?> getNounsModified(String wordToDefine) async {
  List<String>? relatedWords = [];
  try {
    final response = await http
        .get(
      Uri.parse(nounsModifiedURL + wordToDefine + '&max=100'),
    )
        .timeout(const Duration(seconds: 5), onTimeout: () {
      throw TimeoutException("getNounsModified() timeout");
    });
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      final parsedJson = json.decode(response.body);
      var rest = parsedJson as List;
      for (var i = 0; i < rest.length; i++) {
        if (rest[i]["word"].toLowerCase() == wordToDefine.toLowerCase()) {
          continue;
        }
        String word = rest[i]["word"][0].toUpperCase() +
            rest[i]["word"].substring(1).toLowerCase();
        relatedWords.add(word);
      }
      return relatedWords;
    } else if (response.statusCode == 404) {}
  } on TimeoutException catch (_) {
    return null;
  }
  return null;
}

Future<List<String>?> getAdjectivesModified(String wordToDefine) async {
  List<String>? relatedWords = [];
  try {
    final response = await http
        .get(
      Uri.parse(adjectivesModifiedURL + wordToDefine + '&max=100'),
    )
        .timeout(const Duration(seconds: 5), onTimeout: () {
      throw TimeoutException("getAdjectivesModified() timeout");
    });
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      final parsedJson = json.decode(response.body);
      var rest = parsedJson as List;
      for (var i = 0; i < rest.length; i++) {
        if (rest[i]["word"].toLowerCase() == wordToDefine.toLowerCase()) {
          continue;
        }
        String word = rest[i]["word"][0].toUpperCase() +
            rest[i]["word"].substring(1).toLowerCase();
        relatedWords.add(word);
      }
      return relatedWords;
    } else if (response.statusCode == 404) {}
  } on TimeoutException catch (_) {
    return null;
  }
  return null;
}

Future<List<String>?> getSynonyms(String wordToDefine) async {
  List<String>? relatedWords = [];
  try {
    final response = await http
        .get(
      Uri.parse(synonymsURL + wordToDefine + '&max=100'),
    )
        .timeout(const Duration(seconds: 5), onTimeout: () {
      throw TimeoutException("getSynonyms() timeout");
    });
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      final parsedJson = json.decode(response.body);
      var rest = parsedJson as List;
      for (var i = 0; i < rest.length; i++) {
        if (rest[i]["word"].toLowerCase() == wordToDefine.toLowerCase()) {
          continue;
        }
        String word = rest[i]["word"][0].toUpperCase() +
            rest[i]["word"].substring(1).toLowerCase();
        relatedWords.add(word);
      }
      return relatedWords;
    } else if (response.statusCode == 404) {}
  } on TimeoutException catch (_) {
    return null;
  }
  return null;
}

Future<List<String>?> getAntonyms(String wordToDefine) async {
  List<String>? relatedWords = [];
  try {
    final response = await http
        .get(
      Uri.parse(antonymsURL + wordToDefine + '&max=100'),
    )
        .timeout(const Duration(seconds: 5), onTimeout: () {
      throw TimeoutException("getAntonyms() timeout");
    });
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      final parsedJson = json.decode(response.body);
      var rest = parsedJson as List;
      for (var i = 0; i < rest.length; i++) {
        if (rest[i]["word"].toLowerCase() == wordToDefine.toLowerCase()) {
          continue;
        }
        String word = rest[i]["word"][0].toUpperCase() +
            rest[i]["word"].substring(1).toLowerCase();
        relatedWords.add(word);
      }
      return relatedWords;
    } else if (response.statusCode == 404) {}
  } on TimeoutException catch (_) {
    return null;
  }
  return null;
}

Future<List<String>?> getHypernyms(String wordToDefine) async {
  List<String>? relatedWords = [];
  try {
    final response = await http
        .get(
      Uri.parse(hypernymsURL + wordToDefine + '&max=100'),
    )
        .timeout(const Duration(seconds: 5), onTimeout: () {
      throw TimeoutException("getHypernyms() timeout");
    });
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      final parsedJson = json.decode(response.body);
      var rest = parsedJson as List;
      for (var i = 0; i < rest.length; i++) {
        if (rest[i]["word"].toLowerCase() == wordToDefine.toLowerCase()) {
          continue;
        }
        String word = rest[i]["word"][0].toUpperCase() +
            rest[i]["word"].substring(1).toLowerCase();
        relatedWords.add(word);
      }
      return relatedWords;
    } else if (response.statusCode == 404) {}
  } on TimeoutException catch (_) {
    return null;
  }
  return null;
}

Future<List<String>?> getHyponyms(String wordToDefine) async {
  List<String>? relatedWords = [];
  try {
    final response = await http
        .get(
      Uri.parse(hyponymsURL + wordToDefine + '&max=100'),
    )
        .timeout(const Duration(seconds: 5), onTimeout: () {
      throw TimeoutException("getHyponyms() timeout");
    });
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      final parsedJson = json.decode(response.body);
      var rest = parsedJson as List;
      for (var i = 0; i < rest.length; i++) {
        if (rest[i]["word"].toLowerCase() == wordToDefine.toLowerCase()) {
          continue;
        }
        String word = rest[i]["word"][0].toUpperCase() +
            rest[i]["word"].substring(1).toLowerCase();
        relatedWords.add(word);
      }
      return relatedWords;
    } else if (response.statusCode == 404) {}
  } on TimeoutException catch (_) {
    return null;
  }
  return null;
}

Future<List<String>?> getHolonyms(String wordToDefine) async {
  List<String>? relatedWords = [];
  try {
    final response = await http
        .get(
      Uri.parse(holonymsURL + wordToDefine + '&max=100'),
    )
        .timeout(const Duration(seconds: 5), onTimeout: () {
      throw TimeoutException("getHolonyms() timeout");
    });
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      final parsedJson = json.decode(response.body);
      var rest = parsedJson as List;
      for (var i = 0; i < rest.length; i++) {
        if (rest[i]["word"].toLowerCase() == wordToDefine.toLowerCase()) {
          continue;
        }
        String word = rest[i]["word"][0].toUpperCase() +
            rest[i]["word"].substring(1).toLowerCase();
        relatedWords.add(word);
      }
      return relatedWords;
    } else if (response.statusCode == 404) {}
  } on TimeoutException catch (_) {
    return null;
  }
  return null;
}

Future<List<String>?> getMeronyms(String wordToDefine) async {
  List<String>? relatedWords = [];
  try {
    final response = await http
        .get(
      Uri.parse(meronymsURL + wordToDefine + '&max=100'),
    )
        .timeout(const Duration(seconds: 5), onTimeout: () {
      throw TimeoutException("getMeronyms() timeout");
    });
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      final parsedJson = json.decode(response.body);
      var rest = parsedJson as List;
      for (var i = 0; i < rest.length; i++) {
        if (rest[i]["word"].toLowerCase() == wordToDefine.toLowerCase()) {
          continue;
        }
        String word = rest[i]["word"][0].toUpperCase() +
            rest[i]["word"].substring(1).toLowerCase();
        relatedWords.add(word);
      }
      return relatedWords;
    } else if (response.statusCode == 404) {}
  } on TimeoutException catch (_) {
    return null;
  }
  return null;
}
