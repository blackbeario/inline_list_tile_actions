# inline_list_tile_actions

A Flutter widget that displays inline expandable actions for ListTile items. Tap an icon to smoothly reveal action buttons.

## Features

- **Smooth Animations**: Uses `AnimatedSize` for smooth expand/collapse transitions
- **Customizable Actions**: Define icons, labels, colors, and callbacks for each action
- **Flexible Layouts**: Display actions in horizontal rows or vertical columns
- **Easy Integration**: Simple API that wraps your existing ListTile widgets
- **Highly Configurable**: Control animation duration, spacing, styling, and behavior
- **Accessibility**: Supports tooltips and follows Material Design guidelines

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  inline_list_tile_actions: ^0.1.0
```

Then run:

```bash
flutter pub get
```

## Usage

### Basic Example

```dart
import 'package:flutter/material.dart';
import 'package:inline_list_tile_actions/inline_list_tile_actions.dart';

InlineListTileActions(
  actions: [
    ActionItem(
      icon: Icons.delete,
      label: 'Delete',
      backgroundColor: Colors.red,
      foregroundColor: Colors.white,
      onPressed: () => print('Delete tapped'),
    ),
    ActionItem(
      icon: Icons.share,
      label: 'Share',
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
      onPressed: () => print('Share tapped'),
    ),
  ],
  child: ListTile(
    title: Text('My Item'),
    subtitle: Text('Tap the icon to see actions'),
  ),
)
```

### Advanced Configuration

```dart
InlineListTileActions(
  // Layout options
  actionLayout: ActionLayout.column,  // or ActionLayout.row (default)
  actionPosition: ActionPosition.inline,  // or ActionPosition.below (default)

  // Styling
  backgroundColor: Colors.grey[200],
  borderRadius: BorderRadius.circular(16),
  actionPadding: EdgeInsets.all(12.0),
  actionWidth: 70.0,  // Custom width for action buttons

  // Animation
  animationDuration: Duration(milliseconds: 500),

  // Behavior
  showLabels: false,  // Hide action labels
  closeOnActionTap: true,  // Auto-close after tapping action (default)
  triggerIcon: Icons.menu,  // Custom trigger icon

  // Alignment (below mode only)
  actionsAlignment: MainAxisAlignment.spaceEvenly,
  actionsCrossAlignment: CrossAxisAlignment.center,

  // Actions
  actions: [
    ActionItem(
      icon: Icons.edit,
      label: 'Edit',
      tooltip: 'Edit this item',
      backgroundColor: Colors.green,
      foregroundColor: Colors.white,
      onPressed: () => print('Edit tapped'),
    ),
  ],

  child: ListTile(
    leading: Icon(Icons.email),
    title: Text('Important Email'),
    subtitle: Text('Tap to see actions'),
  ),
)
```

### Managing Multiple Action Menus

When you have multiple `InlineListTileActions` on the same screen, you may want to close other menus when one opens, and ensure all menus close when navigating away. Here's how to implement that:

```dart
class MyListScreen extends StatefulWidget {
  @override
  State<MyListScreen> createState() => _MyListScreenState();
}

class _MyListScreenState extends State<MyListScreen> {
  final List<GlobalKey<InlineListTileActionsState>> _actionKeys = [];

  @override
  void initState() {
    super.initState();
    // Create keys for each list item
    for (int i = 0; i < items.length; i++) {
      _actionKeys.add(GlobalKey<InlineListTileActionsState>());
    }
  }

  void _closeOtherMenus(int expandedIndex) {
    for (int i = 0; i < _actionKeys.length; i++) {
      if (i != expandedIndex) {
        _actionKeys[i].currentState?.close();
      }
    }
  }

  void _closeAllMenus() {
    for (var key in _actionKeys) {
      key.currentState?.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return InlineListTileActions(
          key: _actionKeys[index],
          onExpansionChanged: (isExpanded) {
            if (isExpanded) {
              _closeOtherMenus(index);
            }
          },
          actions: [
            ActionItem(
              icon: Icons.delete,
              label: 'Delete',
              onPressed: () => print('Delete $index'),
            ),
          ],
          child: ListTile(
            title: Text('Item $index'),
            onTap: () {
              // Close all menus before navigating
              _closeAllMenus();

              // Navigate to detail screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailScreen(item: items[index]),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
```

**Important Notes:**
- Use `onExpansionChanged` to close other menus when one opens (ensures only one menu is open at a time)
- Call `_closeAllMenus()` before navigation to ensure clean state when returning
- The `InlineListTileActionsState` class is public to allow access to the `close()` method via GlobalKey

## API Reference

### InlineListTileActions

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `actions` | `List<ActionItem>` | **required** | The list of actions to display |
| `child` | `Widget` | **required** | The child widget (typically a ListTile) |
| `triggerIcon` | `IconData` | `Icons.more_vert` | Icon that triggers the actions menu |
| `actionLayout` | `ActionLayout` | `ActionLayout.row` | Layout direction for actions |
| `actionPosition` | `ActionPosition` | `ActionPosition.inline` | Position of actions (inline or below) |
| `animationDuration` | `Duration` | `300ms` | Duration of expand/collapse animation |
| `actionSpacing` | `double` | `8.0` | Spacing between action items |
| `actionWidth` | `double` | `80.0` | Width of each action button |
| `showLabels` | `bool` | `true` | Whether to show labels on actions |
| `closeOnActionTap` | `bool` | `true` | Auto-close after action tap |
| `actionPadding` | `EdgeInsets` | `EdgeInsets.all(8.0)` | Padding around actions container |
| `actionsAlignment` | `MainAxisAlignment` | `MainAxisAlignment.start` | Main axis alignment (below mode only) |
| `actionsCrossAlignment` | `CrossAxisAlignment` | `CrossAxisAlignment.center` | Cross axis alignment (below mode only) |
| `backgroundColor` | `Color?` | `null` | Background color for actions container |
| `borderRadius` | `BorderRadius?` | `BorderRadius.circular(8)` | Border radius for actions container |
| `onExpansionChanged` | `Function(bool)?` | `null` | Callback when expansion state changes |

### ActionItem

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `icon` | `IconData` | **required** | Icon to display |
| `onPressed` | `VoidCallback` | **required** | Callback when action is tapped |
| `label` | `String?` | `null` | Optional text label |
| `backgroundColor` | `Color?` | `null` | Background color for this action |
| `foregroundColor` | `Color?` | `null` | Icon/text color for this action |
| `tooltip` | `String?` | `null` | Tooltip text on long press |

## Examples

Check out the [example](example/) directory for a complete demo app showcasing all features:

- Basic usage with multiple actions
- Vertical layout example
- Custom styling
- Different trigger icons
- With and without labels

Run the example:

```bash
cd example
flutter run
```

## Why This Package?

While Flutter has great packages like `flutter_slidable` for swipe actions, there wasn't a simple solution for inline expandable actions that appear on tap. This package fills that gap with:

- **No gestures required**: Simple tap to expand
- **Better discoverability**: Users can see the trigger icon
- **More control**: Fine-tune animations, layouts, and styling
- **Accessibility**: Works better for users who struggle with swipe gestures

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Author

Created by Jeff Frazier

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for version history.
