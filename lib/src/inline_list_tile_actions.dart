import 'package:flutter/material.dart';
import 'models/action_item.dart';

/// The layout direction for displaying actions.
enum ActionLayout {
  /// Display actions in a horizontal row.
  row,

  /// Display actions in a vertical column.
  column,
}

/// A widget that wraps a [ListTile] and displays expandable inline actions
/// when a trigger icon is tapped.
///
/// This widget provides a smooth, animated way to show action buttons inline
/// without requiring slidable gestures. It's perfect for lists where you want
/// to provide quick actions (like delete, edit, share) that appear on demand.
///
/// Example:
/// ```dart
/// InlineListTileActions(
///   actions: [
///     ActionItem(
///       icon: Icons.delete,
///       label: 'Delete',
///       backgroundColor: Colors.red,
///       foregroundColor: Colors.white,
///       onPressed: () => print('Delete tapped'),
///     ),
///     ActionItem(
///       icon: Icons.share,
///       label: 'Share',
///       onPressed: () => print('Share tapped'),
///     ),
///   ],
///   child: ListTile(
///     title: Text('My Item'),
///     subtitle: Text('Tap the icon to see actions'),
///   ),
/// )
/// ```
class InlineListTileActions extends StatefulWidget {
  /// Creates an inline list tile actions widget.
  ///
  /// The [actions] and [child] parameters are required.
  const InlineListTileActions({
    super.key,
    required this.actions,
    required this.child,
    this.triggerIcon = Icons.more_vert,
    this.actionLayout = ActionLayout.row,
    this.animationDuration = const Duration(milliseconds: 300),
    this.actionSpacing = 8.0,
    this.showLabels = true,
    this.closeOnActionTap = true,
    this.actionPadding = const EdgeInsets.all(8.0),
    this.backgroundColor,
    this.borderRadius,
  });

  /// The list of actions to display when expanded.
  final List<ActionItem> actions;

  /// The child widget, typically a [ListTile].
  final Widget child;

  /// The icon to display in the trailing position that triggers the actions menu.
  final IconData triggerIcon;

  /// The layout direction for displaying actions (row or column).
  final ActionLayout actionLayout;

  /// The duration of the expand/collapse animation.
  final Duration animationDuration;

  /// The spacing between action items.
  final double actionSpacing;

  /// Whether to show labels below/beside action icons.
  final bool showLabels;

  /// Whether to automatically close the actions when an action is tapped.
  final bool closeOnActionTap;

  /// Padding around the actions container.
  final EdgeInsets actionPadding;

  /// Background color for the actions container.
  final Color? backgroundColor;

  /// Border radius for the actions container.
  final BorderRadius? borderRadius;

  @override
  State<InlineListTileActions> createState() => _InlineListTileActionsState();
}

class _InlineListTileActionsState extends State<InlineListTileActions> {
  bool _isExpanded = false;

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  void _handleActionTap(VoidCallback onPressed) {
    onPressed();
    if (widget.closeOnActionTap) {
      setState(() {
        _isExpanded = false;
      });
    }
  }

  Widget _buildActionButton(ActionItem action) {
    final child = widget.showLabels && action.label != null
        ? Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                action.icon,
                color: action.foregroundColor,
              ),
              const SizedBox(height: 4),
              Text(
                action.label!,
                style: TextStyle(
                  fontSize: 12,
                  color: action.foregroundColor,
                ),
              ),
            ],
          )
        : Icon(
            action.icon,
            color: action.foregroundColor,
          );

    final button = action.backgroundColor != null
        ? Material(
            color: action.backgroundColor,
            borderRadius: BorderRadius.circular(8),
            child: InkWell(
              onTap: () => _handleActionTap(action.onPressed),
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: child,
              ),
            ),
          )
        : IconButton(
            icon: child,
            onPressed: () => _handleActionTap(action.onPressed),
          );

    return action.tooltip != null
        ? Tooltip(
            message: action.tooltip!,
            child: button,
          )
        : button;
  }

  Widget _buildActions() {
    final actionWidgets = widget.actions.map(_buildActionButton).toList();

    return Container(
      padding: widget.actionPadding,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
      ),
      child: widget.actionLayout == ActionLayout.row
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (int i = 0; i < actionWidgets.length; i++) ...[
                  actionWidgets[i],
                  if (i < actionWidgets.length - 1)
                    SizedBox(width: widget.actionSpacing),
                ],
              ],
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (int i = 0; i < actionWidgets.length; i++) ...[
                  actionWidgets[i],
                  if (i < actionWidgets.length - 1)
                    SizedBox(height: widget.actionSpacing),
                ],
              ],
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Clone the child and inject the trailing icon if it's a ListTile
    Widget childWithTrigger = widget.child;

    if (widget.child is ListTile) {
      final listTile = widget.child as ListTile;
      childWithTrigger = ListTile(
        key: listTile.key,
        leading: listTile.leading,
        title: listTile.title,
        subtitle: listTile.subtitle,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (listTile.trailing != null) listTile.trailing!,
            IconButton(
              icon: Icon(widget.triggerIcon),
              onPressed: _toggleExpanded,
            ),
          ],
        ),
        isThreeLine: listTile.isThreeLine,
        dense: listTile.dense,
        visualDensity: listTile.visualDensity,
        shape: listTile.shape,
        style: listTile.style,
        selectedColor: listTile.selectedColor,
        iconColor: listTile.iconColor,
        textColor: listTile.textColor,
        titleTextStyle: listTile.titleTextStyle,
        subtitleTextStyle: listTile.subtitleTextStyle,
        leadingAndTrailingTextStyle: listTile.leadingAndTrailingTextStyle,
        contentPadding: listTile.contentPadding,
        enabled: listTile.enabled,
        onTap: listTile.onTap,
        onLongPress: listTile.onLongPress,
        onFocusChange: listTile.onFocusChange,
        mouseCursor: listTile.mouseCursor,
        selected: listTile.selected,
        focusColor: listTile.focusColor,
        hoverColor: listTile.hoverColor,
        splashColor: listTile.splashColor,
        focusNode: listTile.focusNode,
        autofocus: listTile.autofocus,
        tileColor: listTile.tileColor,
        selectedTileColor: listTile.selectedTileColor,
        enableFeedback: listTile.enableFeedback,
        horizontalTitleGap: listTile.horizontalTitleGap,
        minVerticalPadding: listTile.minVerticalPadding,
        minLeadingWidth: listTile.minLeadingWidth,
        titleAlignment: listTile.titleAlignment,
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        childWithTrigger,
        AnimatedSize(
          duration: widget.animationDuration,
          curve: Curves.easeInOut,
          child: _isExpanded
              ? Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: _buildActions(),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}
