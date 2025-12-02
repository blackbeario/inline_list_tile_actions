## [0.2.0] - 2025-12-02

### Major Update

#### Added
- **Inline positioning mode** (`ActionPosition.inline`) - actions slide from right like flutter_slidable
- **Below positioning mode** (`ActionPosition.below`) - actions appear below the ListTile (original behavior)
- **Responsive slide calculation** - uses MediaQuery for device-agnostic sliding distances
- **Consistent action button widths** - `actionWidth` parameter applies to both modes
- **Alignment controls** - `actionsAlignment` and `actionsCrossAlignment` for below mode
- **Multi-menu management** - `onExpansionChanged` callback for coordinating multiple menus
- **Public state class** - `InlineListTileActionsState` with `close()` method for programmatic control
- **Automatic menu closing** - actions close when ListTile is tapped for navigation

#### Improvements
- Stack-based architecture for inline mode (similar to flutter_slidable)
- SlideTransition with Material background for proper rendering
- Dynamic slide distance based on screen width and number of actions
- Comprehensive documentation with multi-menu management examples
- Updated API reference with all new parameters

#### Breaking Changes
- **Default position changed**: `actionPosition` now defaults to `ActionPosition.inline` instead of `ActionPosition.below` to align with the package name and primary use case. To maintain the old behavior, explicitly set `actionPosition: ActionPosition.below`

## [0.1.0] - 2025-12-01

### Initial Release

#### Added
- `InlineListTileActions` widget for displaying expandable actions inline
- `ActionItem` model for defining individual actions
- Support for horizontal (row) and vertical (column) action layouts
- Customizable animations with `AnimatedSize`
- Configurable trigger icon
- Optional action labels
- Custom styling options (colors, padding, border radius)
- Auto-close on action tap behavior
- Comprehensive example app demonstrating all features
- Full test coverage
- Complete API documentation

#### Features
- Smooth expand/collapse animations
- Accessibility support with tooltips
- Material Design compliance
- Theme-aware default styling
- Highly customizable action buttons
- Works seamlessly with existing ListTile widgets
