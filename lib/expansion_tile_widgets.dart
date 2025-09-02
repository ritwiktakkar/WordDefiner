import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'styles.dart';

/// Reusable expansion tile widgets for WordDefiner
class ExpansionTileWidgets {
  /// Creates a definitions expansion tile
  static Widget definitionsExpansionTile({
    required BuildContext context,
    required Map meaningDefinitionsMap,
    required Map meaningSynonymMap,
    required Map meaningAntonymMap,
    required String pronounciationAudioSource,
    required String pronounciationSourceUrl,
    required String licenseNames,
    required String licenseUrls,
    required String sourceUrls,
    required bool isExpanded,
    required Function(bool) onExpansionChanged,
  }) {
    return ExpansionTile(
      tilePadding: EdgeInsets.all(0),
      expandedAlignment: Alignment.topLeft,
      title: Text(
        (meaningDefinitionsMap.keys.length > 1)
            ? "Definitions for ${meaningDefinitionsMap.keys.length} parts of speech"
            : "Definition",
        style: AppStyles.sectionTitle(context),
      ),
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.all(0),
              shrinkWrap: true,
              itemCount: meaningDefinitionsMap.keys.length,
              itemBuilder: (BuildContext context, int index) {
                String key = meaningDefinitionsMap.keys.elementAt(index);
                String value = meaningDefinitionsMap.values
                    .elementAt(index)
                    .toString()
                    .substring(1, meaningDefinitionsMap.values.elementAt(index).toString().length - 1)
                    .replaceAll('.,', '\n\u2022');
                List<String>? meaningSynonymList = meaningSynonymMap[meaningDefinitionsMap.keys.elementAt(index)] as List<String>;
                List<String>? meaningAntonymList = meaningAntonymMap[meaningDefinitionsMap.keys.elementAt(index)] as List<String>;
                
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${index + 1}. Part of speech: ${key[0].toUpperCase()}${key.substring(1).toLowerCase()}",
                      style: AppStyles.partOfSpeech(context),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        "\u2022 ${value.toString()}",
                        style: AppStyles.definition(context),
                      ),
                    ),
                    Visibility(
                      visible: meaningSynonymList.isNotEmpty,
                      child: Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          'Synonyms: ${meaningSynonymList.join(', ')}',
                          style: AppStyles.synonyms(context),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: meaningAntonymList.isNotEmpty,
                      child: Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          'Antonyms: ${meaningAntonymList.join(', ')}',
                          style: AppStyles.antonyms(context),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0, bottom: 10),
              child: ListBody(
                children: [
                  Visibility(
                    visible: pronounciationAudioSource != '',
                    child: Text(
                      'Audio: $pronounciationSourceUrl',
                      style: AppStyles.corporate(context),
                    ),
                  ),
                  SelectableText(
                    "License name: $licenseNames",
                    style: AppStyles.corporate(context),
                    maxLines: 1,
                  ),
                  SelectableText(
                    "License URLs: $licenseUrls",
                    style: AppStyles.corporate(context),
                    maxLines: 1,
                  ),
                  SelectableText(
                    "Source URLs: $sourceUrls",
                    style: AppStyles.corporate(context),
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
      onExpansionChanged: (bool expanded) {
        HapticFeedback.lightImpact();
        onExpansionChanged(expanded);
      },
      initiallyExpanded: true,
    );
  }

  /// Creates a simple word list expansion tile
  static Widget wordListExpansionTile({
    required BuildContext context,
    required String title,
    required String content,
    required TextStyle contentStyle,
    required bool isExpanded,
    required Function(bool) onExpansionChanged,
    Widget? titleSuffix,
  }) {
    return ExpansionTile(
      tilePadding: EdgeInsets.all(0),
      expandedAlignment: Alignment.topLeft,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(title, style: AppStyles.sectionTitle(context)),
          if (titleSuffix != null) titleSuffix,
        ],
      ),
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: SelectableText(content, style: contentStyle),
            ),
          ],
        ),
      ],
      onExpansionChanged: (bool expanded) {
        HapticFeedback.lightImpact();
        onExpansionChanged(expanded);
      },
    );
  }

  /// Creates an info tooltip icon
  static Widget infoTooltip({
    required BuildContext context,
    required String message,
  }) {
    return Tooltip(
      message: message,
      child: Icon(
        Icons.info_outline,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
        size: 16,
      ),
    );
  }
}
