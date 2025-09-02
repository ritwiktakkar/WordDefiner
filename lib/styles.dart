import 'dart:io';
import 'package:flutter/material.dart';

/// App-wide text styles for WordDefiner
class AppStyles {
  static TextStyle sectionTitle(BuildContext context) => TextStyle(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
        fontWeight: FontWeight.w500,
        fontSize: 17,
      );

  static TextStyle partOfSpeech(BuildContext context) => TextStyle(
        color: Theme.of(context).colorScheme.primary,
        fontSize: 18,
      );

  static TextStyle synonyms(BuildContext context) => TextStyle(
        color: Theme.of(context).colorScheme.secondary,
        fontSize: 18,
      );

  static TextStyle hint(BuildContext context) => TextStyle(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
        fontWeight: FontWeight.w300,
        fontSize: 16,
      );

  static TextStyle fail(BuildContext context) => TextStyle(
        color: Theme.of(context).colorScheme.error,
        fontWeight: FontWeight.w400,
        fontSize: 18,
      );

  static TextStyle antonyms(BuildContext context) => TextStyle(
        color: Theme.of(context).colorScheme.error,
        fontSize: 18,
      );

  static TextStyle subsectionTitle(BuildContext context) => TextStyle(
        color: Theme.of(context).colorScheme.onSurface,
        fontWeight: FontWeight.w300,
        fontSize: 18,
      );

  static TextStyle corporate(BuildContext context) => TextStyle(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
        fontSize: (Platform.isLinux || Platform.isWindows || Platform.isMacOS)
            ? 14
            : 10,
        fontWeight: FontWeight.w300,
      );

  static TextStyle wordTitle(BuildContext context) => TextStyle(
        color: Theme.of(context).colorScheme.onSurface,
        fontSize: 28,
        fontWeight: FontWeight.bold,
      );

  static TextStyle phonetic(BuildContext context) => TextStyle(
        color: Theme.of(context).colorScheme.secondary,
        fontWeight: FontWeight.w300,
        fontSize: 18,
      );

  static TextStyle searchInput(BuildContext context) => TextStyle(
        color: Theme.of(context).colorScheme.onSurface,
        fontSize: 18,
        fontWeight: FontWeight.w400,
      );

  static TextStyle searchHint(BuildContext context) => TextStyle(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
        fontSize: 18,
        fontWeight: FontWeight.w400,
      );

  static TextStyle lookingUp(BuildContext context) => TextStyle(
        color: Theme.of(context).colorScheme.onSurface,
        fontSize: 28,
      );

  static TextStyle definition(BuildContext context) => TextStyle(
        color: Theme.of(context).colorScheme.onSurface,
        fontSize: 18,
      );
}
