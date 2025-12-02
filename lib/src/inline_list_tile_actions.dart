import 'package:flutter/material.dart';
import 'models/action_item.dart';

/// The layout direction for displaying actions.
enum ActionLayout {
  /// Display actions in a horizontal row.
  row,

  /// Display actions in a vertical column.
  column,
}

/// Where to position the actions when expanded.
enum ActionPosition {
  /// Display actions below the ListTile (default).
  below,

  /// Display actions inline, sliding from the right like Slidable.
  inline,
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
    this.actionPosition = ActionPosition.inline,
    this.animationDuration = const Duration(milliseconds: 300),
    this.actionSpacing = 8.0,
    this.actionWidth = 80.0,
    this.showLabels = true,
    this.closeOnActionTap = true,
    this.actionPadding = const EdgeInsets.all(8.0),
    this.actionsAlignment = MainAxisAlignment.start,
    this.actionsCrossAlignment = CrossAxisAlignment.center,
    this.backgroundColor,
    this.borderRadius,
    this.onExpansionChanged,
  });

  /// The list of actions to display when expanded.
  final List<ActionItem> actions;

  /// The child widget, typically a [ListTile].
  final Widget child;

  /// The icon to display in the trailing position that triggers the actions menu.
  final IconData triggerIcon;

  /// The layout direction for displaying actions (row or column).
  ///
  /// Only applies when [actionPosition] is [ActionPosition.below].
  final ActionLayout actionLayout;

  /// Where to position the actions when expanded.
  final ActionPosition actionPosition;

  /// The duration of the expand/collapse animation.
  final Duration animationDuration;

  /// The spacing between action items.
  ///
  /// Only applies when [actionPosition] is [ActionPosition.below].
  final double actionSpacing;

  /// The width of each action button.
  ///
  /// For [ActionPosition.inline]: Used to calculate slide distance and set button width.
  /// For [ActionPosition.below]: Sets a consistent width for all action buttons.
  ///
  /// Defaults to 80.0, which follows Material Design guidelines for touch targets.
  /// Recommended range: 60.0 - 100.0
  final double actionWidth;

  /// Whether to show labels below/beside action icons.
  final bool showLabels;

  /// Whether to automatically close the actions when an action is tapped.
  final bool closeOnActionTap;

  /// Padding around the actions container.
  ///
  /// Only applies when [actionPosition] is [ActionPosition.below].
  final EdgeInsets actionPadding;

  /// Main axis alignment for actions in below mode.
  ///
  /// Controls horizontal alignment when [actionLayout] is [ActionLayout.row],
  /// or vertical alignment when [actionLayout] is [ActionLayout.column].
  /// Only applies when [actionPosition] is [ActionPosition.below].
  final MainAxisAlignment actionsAlignment;

  /// Cross axis alignment for actions in below mode.
  ///
  /// Controls vertical alignment when [actionLayout] is [ActionLayout.row],
  /// or horizontal alignment when [actionLayout] is [ActionLayout.column].
  /// Only applies when [actionPosition] is [ActionPosition.below].
  final CrossAxisAlignment actionsCrossAlignment;

  /// Background color for the actions container.
  ///
  /// Only applies when [actionPosition] is [ActionPosition.below].
  final Color? backgroundColor;

  /// Border radius for the actions container.
  ///
  /// Only applies when [actionPosition] is [ActionPosition.below].
  final BorderRadius? borderRadius;

  /// Callback invoked when the expansion state changes.
  ///
  /// This is useful for closing other expanded action menus when this one opens.
  /// The callback receives `true` when expanding and `false` when collapsing.
  final void Function(bool isExpanded)? onExpansionChanged;

  @override
  State<InlineListTileActions> createState() => InlineListTileActionsState();
}

/// The state for [InlineListTileActions].
///
/// This is public to allow access to the [close] method via GlobalKey.
class InlineListTileActionsState extends State<InlineListTileActions>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animationController;
  Animation<Offset>? _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Build the slide animation using actual device width
    _slideAnimation ??= _buildSlideAnimation(context);
  }

  Animation<Offset> _buildSlideAnimation(BuildContext context) {
    // Get actual device width
    final double deviceWidth = MediaQuery.of(context).size.width;

    // Calculate total width needed for all actions
    final double totalActionsWidth = widget.actions.length * widget.actionWidth;

    // Calculate what percentage of the screen width we need to slide
    // Add some padding (16px on each side) to account for list padding
    final double slideDistance = totalActionsWidth / (deviceWidth - 32);

    // Clamp between reasonable bounds: don't slide less than 30% or more than 85%
    final double clampedDistance = slideDistance.clamp(0.3, 0.85);

    return Tween<Offset>(
      begin: Offset.zero,
      end: Offset(-clampedDistance, 0),
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// Closes the actions menu if it's currently expanded.
  void close() {
    if (_isExpanded) {
      setState(() {
        _isExpanded = false;
        _animationController.reverse();
      });
      widget.onExpansionChanged?.call(false);
    }
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
        widget.onExpansionChanged?.call(true);
      } else {
        _animationController.reverse();
        widget.onExpansionChanged?.call(false);
      }
    });
  }

  void _handleActionTap(VoidCallback onPressed) {
    onPressed();
    if (widget.closeOnActionTap) {
      setState(() {
        _isExpanded = false;
        _animationController.reverse();
      });
    }
  }

  Widget _buildActionButton(ActionItem action) {
    final child = widget.showLabels && action.label != null
        ? Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                action.icon,
                color: action.foregroundColor ?? Colors.white,
                size: 20,
              ),
              const SizedBox(height: 4),
              Text(
                action.label!,
                style: TextStyle(
                  fontSize: 10,
                  color: action.foregroundColor ?? Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          )
        : Icon(
            action.icon,
            color: action.foregroundColor ?? Colors.white,
            size: 24,
          );

    final button = Material(
      color: action.backgroundColor ?? Colors.grey,
      child: InkWell(
        onTap: () => _handleActionTap(action.onPressed),
        child: Container(
          width: widget.actionWidth,
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
          child: Center(child: child),
        ),
      ),
    );

    return action.tooltip != null
        ? Tooltip(message: action.tooltip!, child: button)
        : button;
  }

  Widget _buildActionsPane() {
    final actionWidgets = widget.actions.map(_buildActionButton).toList();

    return Container(
      decoration: BoxDecoration(color: widget.backgroundColor),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: actionWidgets,
      ),
    );
  }

  Widget _buildInlineLayout() {
    // Slidable-style implementation with Stack and SlideTransition
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
              icon: Icon(_isExpanded ? Icons.close : widget.triggerIcon),
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
        onTap: listTile.onTap != null
            ? () {
                // Close actions before executing original onTap
                if (_isExpanded) {
                  setState(() {
                    _isExpanded = false;
                    _animationController.reverse();
                  });
                }
                listTile.onTap!();
              }
            : null,
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

    // Use Stack like Slidable does
    // Build animation if not already built
    final slideAnimation = _slideAnimation ?? _buildSlideAnimation(context);

    return ClipRect(
      child: Stack(
        children: [
          // Actions pane positioned on the right
          Positioned.fill(
            child: Align(
              alignment: Alignment.centerRight,
              child: _buildActionsPane(),
            ),
          ),
          // Child with slide animation - wrapped in Material for opaque background
          SlideTransition(
            position: slideAnimation,
            child: Material(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: childWithTrigger,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBelowLayout() {
    // Original layout - actions appear below
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
        onTap: listTile.onTap != null
            ? () {
                // Close actions before executing original onTap
                if (_isExpanded) {
                  setState(() {
                    _isExpanded = false;
                    _animationController.reverse();
                  });
                }
                listTile.onTap!();
              }
            : null,
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
                  child: _buildBelowActionsPane(),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildBelowActionsPane() {
    final actionWidgets = widget.actions.map((action) {
      final child = widget.showLabels && action.label != null
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(action.icon, color: action.foregroundColor, size: 20),
                const SizedBox(height: 4),
                Text(
                  action.label!,
                  style: TextStyle(fontSize: 10, color: action.foregroundColor),
                ),
              ],
            )
          : Icon(action.icon, color: action.foregroundColor, size: 20);

      final button = action.backgroundColor != null
          ? Material(
              color: action.backgroundColor,
              borderRadius: BorderRadius.circular(8),
              child: InkWell(
                onTap: () => _handleActionTap(action.onPressed),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: widget.actionWidth,
                  padding: const EdgeInsets.all(12.0),
                  child: Center(child: child),
                ),
              ),
            )
          : SizedBox(
              width: widget.actionWidth,
              child: IconButton(
                icon: child,
                onPressed: () => _handleActionTap(action.onPressed),
                padding: EdgeInsets.zero,
              ),
            );

      return action.tooltip != null
          ? Tooltip(message: action.tooltip!, child: button)
          : button;
    }).toList();

    return Container(
      padding: widget.actionPadding,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
      ),
      child: widget.actionLayout == ActionLayout.row
          ? Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: widget.actionsAlignment,
              crossAxisAlignment: widget.actionsCrossAlignment,
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
              mainAxisAlignment: widget.actionsAlignment,
              crossAxisAlignment: widget.actionsCrossAlignment,
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
    return widget.actionPosition == ActionPosition.inline
        ? _buildInlineLayout()
        : _buildBelowLayout();
  }
}
