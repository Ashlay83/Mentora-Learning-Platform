import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A comprehensive settings model that manages application preferences
/// with proper state management and persistence capabilities.
class SettingsModel extends ChangeNotifier {
  static const String _prefsKey = 'app_settings';

  // Window settings
  Size? _windowSize;
  Offset? _windowPosition;

  // UI settings
  double _explorerWidth = 250.0;
  bool _showHiddenFiles = false;
  String? _lastOpenedDirectory;
  List<String> _recentDirectories = [];

  // Theme settings
  bool _useDarkTheme = true;
  Color _accentColor = const Color(0xFF007ACC); // VS Code blue

  // PDF viewer settings
  double _pdfZoomLevel = 1.0;
  bool _pdfAutoHideControls = true;

  // File associations
  Map<String, String> _fileAssociations = {};

  // Editor settings
  bool _showLineNumbers = true;
  bool _wordWrap = false;
  double _fontSize = 14.0;
  String _fontFamily = 'Consolas';

  /// Creates a new instance of [SettingsModel] and loads saved settings.
  SettingsModel() {
    _loadSettings();
  }

  /// Getters
  Size? get windowSize => _windowSize;
  Offset? get windowPosition => _windowPosition;
  double get explorerWidth => _explorerWidth;
  bool get showHiddenFiles => _showHiddenFiles;
  String? get lastOpenedDirectory => _lastOpenedDirectory;
  List<String> get recentDirectories => List.unmodifiable(_recentDirectories);
  bool get useDarkTheme => _useDarkTheme;
  Color get accentColor => _accentColor;
  double get pdfZoomLevel => _pdfZoomLevel;
  bool get pdfAutoHideControls => _pdfAutoHideControls;
  Map<String, String> get fileAssociations =>
      Map.unmodifiable(_fileAssociations);
  bool get showLineNumbers => _showLineNumbers;
  bool get wordWrap => _wordWrap;
  double get fontSize => _fontSize;
  String get fontFamily => _fontFamily;

  /// Updates the window size and persists the change.
  Future<void> setWindowSize(Size size) async {
    _windowSize = size;
    await _saveSettings();
    notifyListeners();
  }

  /// Updates the window position and persists the change.
  Future<void> setWindowPosition(Offset position) async {
    _windowPosition = position;
    await _saveSettings();
    notifyListeners();
  }

  /// Updates the explorer panel width and persists the change.
  Future<void> setExplorerWidth(double width) async {
    _explorerWidth = width.clamp(150.0, 500.0); // Enforce reasonable limits
    await _saveSettings();
    notifyListeners();
  }

  /// Toggles visibility of hidden files and persists the change.
  Future<void> setShowHiddenFiles(bool show) async {
    _showHiddenFiles = show;
    await _saveSettings();
    notifyListeners();
  }

  /// Updates the last opened directory and manages recent directories list.
  Future<void> setLastOpenedDirectory(String? path) async {
    _lastOpenedDirectory = path;

    if (path != null && path.isNotEmpty) {
      // Remove if already exists (to move it to the top)
      _recentDirectories.removeWhere((dir) => dir == path);

      // Add to the beginning of the list
      _recentDirectories.insert(0, path);

      // Limit to 10 recent directories
      if (_recentDirectories.length > 10) {
        _recentDirectories = _recentDirectories.sublist(0, 10);
      }
    }

    await _saveSettings();
    notifyListeners();
  }

  /// Clears the list of recent directories.
  Future<void> clearRecentDirectories() async {
    _recentDirectories.clear();
    await _saveSettings();
    notifyListeners();
  }

  /// Updates the theme mode and persists the change.
  Future<void> setUseDarkTheme(bool useDark) async {
    _useDarkTheme = useDark;
    await _saveSettings();
    notifyListeners();
  }

  /// Updates the accent color and persists the change.
  Future<void> setAccentColor(Color color) async {
    _accentColor = color;
    await _saveSettings();
    notifyListeners();
  }

  /// Updates the default PDF zoom level and persists the change.
  Future<void> setPdfZoomLevel(double level) async {
    _pdfZoomLevel = level.clamp(0.5, 3.0); // Enforce reasonable limits
    await _saveSettings();
    notifyListeners();
  }

  /// Toggles auto-hiding of PDF controls and persists the change.
  Future<void> setPdfAutoHideControls(bool autoHide) async {
    _pdfAutoHideControls = autoHide;
    await _saveSettings();
    notifyListeners();
  }

  /// Associates a file extension with a specific handler and persists the change.
  Future<void> setFileAssociation(String extension, String handler) async {
    // Normalize extension format (ensure it starts with a dot)
    final normalizedExt = extension.startsWith('.') ? extension : '.$extension';
    _fileAssociations[normalizedExt.toLowerCase()] = handler;
    await _saveSettings();
    notifyListeners();
  }

  /// Removes a file association and persists the change.
  Future<void> removeFileAssociation(String extension) async {
    final normalizedExt = extension.startsWith('.') ? extension : '.$extension';
    _fileAssociations.remove(normalizedExt.toLowerCase());
    await _saveSettings();
    notifyListeners();
  }

  /// Updates editor line number visibility and persists the change.
  Future<void> setShowLineNumbers(bool show) async {
    _showLineNumbers = show;
    await _saveSettings();
    notifyListeners();
  }

  /// Updates editor word wrap setting and persists the change.
  Future<void> setWordWrap(bool wrap) async {
    _wordWrap = wrap;
    await _saveSettings();
    notifyListeners();
  }

  /// Updates editor font size and persists the change.
  Future<void> setFontSize(double size) async {
    _fontSize = size.clamp(8.0, 32.0); // Enforce reasonable limits
    await _saveSettings();
    notifyListeners();
  }

  /// Updates editor font family and persists the change.
  Future<void> setFontFamily(String family) async {
    _fontFamily = family;
    await _saveSettings();
    notifyListeners();
  }

  /// Resets all settings to their default values.
  Future<void> resetToDefaults() async {
    _windowSize = null;
    _windowPosition = null;
    _explorerWidth = 250.0;
    _showHiddenFiles = false;
    _lastOpenedDirectory = null;
    _recentDirectories = [];
    _useDarkTheme = true;
    _accentColor = const Color(0xFF007ACC);
    _pdfZoomLevel = 1.0;
    _pdfAutoHideControls = true;
    _fileAssociations = {};
    _showLineNumbers = true;
    _wordWrap = false;
    _fontSize = 14.0;
    _fontFamily = 'Consolas';

    await _saveSettings();
    notifyListeners();
  }

  /// Loads settings from SharedPreferences.
  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final settingsJson = prefs.getString(_prefsKey);

      if (settingsJson != null) {
        final Map<String, dynamic> settings = jsonDecode(settingsJson);

        // Window settings
        if (settings.containsKey('windowWidth') &&
            settings.containsKey('windowHeight')) {
          _windowSize = Size(
            settings['windowWidth'].toDouble(),
            settings['windowHeight'].toDouble(),
          );
        }

        if (settings.containsKey('windowX') &&
            settings.containsKey('windowY')) {
          _windowPosition = Offset(
            settings['windowX'].toDouble(),
            settings['windowY'].toDouble(),
          );
        }

        // UI settings
        _explorerWidth = settings['explorerWidth']?.toDouble() ?? 250.0;
        _showHiddenFiles = settings['showHiddenFiles'] ?? false;
        _lastOpenedDirectory = settings['lastOpenedDirectory'];
        _recentDirectories =
            List<String>.from(settings['recentDirectories'] ?? []);

        // Theme settings
        _useDarkTheme = settings['useDarkTheme'] ?? true;
        if (settings.containsKey('accentColor')) {
          _accentColor = Color(settings['accentColor']);
        }

        // PDF viewer settings
        _pdfZoomLevel = settings['pdfZoomLevel']?.toDouble() ?? 1.0;
        _pdfAutoHideControls = settings['pdfAutoHideControls'] ?? true;

        // File associations
        if (settings.containsKey('fileAssociations')) {
          _fileAssociations =
              Map<String, String>.from(settings['fileAssociations']);
        }

        // Editor settings
        _showLineNumbers = settings['showLineNumbers'] ?? true;
        _wordWrap = settings['wordWrap'] ?? false;
        _fontSize = settings['fontSize']?.toDouble() ?? 14.0;
        _fontFamily = settings['fontFamily'] ?? 'Consolas';
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Error loading settings: $e');
      // Continue with default settings in case of error
    }
  }

  /// Saves settings to SharedPreferences.
  Future<void> _saveSettings() async {
    try {
      final Map<String, dynamic> settings = {
        // Window settings
        if (_windowSize != null) ...{
          'windowWidth': _windowSize!.width,
          'windowHeight': _windowSize!.height,
        },
        if (_windowPosition != null) ...{
          'windowX': _windowPosition!.dx,
          'windowY': _windowPosition!.dy,
        },

        // UI settings
        'explorerWidth': _explorerWidth,
        'showHiddenFiles': _showHiddenFiles,
        'lastOpenedDirectory': _lastOpenedDirectory,
        'recentDirectories': _recentDirectories,

        // Theme settings
        'useDarkTheme': _useDarkTheme,
        'accentColor': _accentColor.value,

        // PDF viewer settings
        'pdfZoomLevel': _pdfZoomLevel,
        'pdfAutoHideControls': _pdfAutoHideControls,

        // File associations
        'fileAssociations': _fileAssociations,

        // Editor settings
        'showLineNumbers': _showLineNumbers,
        'wordWrap': _wordWrap,
        'fontSize': _fontSize,
        'fontFamily': _fontFamily,
      };

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefsKey, jsonEncode(settings));
    } catch (e) {
      debugPrint('Error saving settings: $e');
    }
  }
}
