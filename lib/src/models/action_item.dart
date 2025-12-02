import 'package:flutter/material.dart';

/// Represents a single action that can be displayed in the inline actions menu.
///
/// Each [ActionItem] displays an icon, optional label, and executes a callback
/// when tapped.
class ActionItem {
  /// Creates an action item.
  ///
  /// The [icon] and [onPressed] parameters are required.
  const ActionItem({
    required this.icon,
    required this.onPressed,
    this.label,
    this.backgroundColor,
    this.foregroundColor,
    this.tooltip,
  });

  /// The icon to display for this action.
  final IconData icon;

  /// The callback to execute when this action is tapped.
  final VoidCallback onPressed;

  /// Optional text label to display below or beside the icon.
  final String? label;

  /// Optional background color for the action button.
  final Color? backgroundColor;

  /// Optional foreground/icon color for the action button.
  final Color? foregroundColor;

  /// Optional tooltip to display when long-pressing the action.
  final String? tooltip;
}
