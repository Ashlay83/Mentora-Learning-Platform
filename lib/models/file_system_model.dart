import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path_util;
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FileNode {
  String name;
  String id;
  bool isFolder;
  bool isExpanded;
  FileNode? parent;
  List<FileNode> children;
  String? physicalPath; // Actual path on the file system
  DateTime? lastModified;
  int? size; // Size in bytes for files

  FileNode({
    required this.name,
    required this.id,
    this.isFolder = false,
    this.isExpanded = false,
    this.parent,
    this.physicalPath,
    this.lastModified,
    this.size,
    List<FileNode>? children,
  }) : children = children ?? [];

  String get path {
    if (parent == null) {
      return name;
    }
    return path_util.join(parent!.path, name);
  }

  String get extension {
    if (isFolder) return '';
    return path_util.extension(name).toLowerCase();
  }

  IconData get icon {
    if (isFolder) {
      return isExpanded ? Icons.folder_open : Icons.folder;
    }

    // Map common file extensions to icons
    switch (extension) {
      case '.dart':
        return Icons.code;
      case '.py':
        return Icons.code;
      case '.js':
      case '.ts':
        return Icons.javascript;
      case '.html':
        return Icons.html;
      case '.css':
        return Icons.css;
      case '.json':
        return Icons.data_object;
      case '.md':
        return Icons.description;
      case '.jpg':
      case '.jpeg':
      case '.png':
      case '.gif':
      case '.bmp':
        return Icons.image;
      case '.mp4':
      case '.avi':
      case '.mov':
      case '.wmv':
        return Icons.video_file;
      case '.mp3':
      case '.wav':
      case '.ogg':
        return Icons.audio_file;
      case '.pdf':
        return Icons.picture_as_pdf;
      case '.doc':
      case '.docx':
        return Icons.article;
      case '.xls':
      case '.xlsx':
        return Icons.table_chart;
      case '.ppt':
      case '.pptx':
        return Icons.slideshow;
      case '.zip':
      case '.rar':
      case '.7z':
        return Icons.archive;
      case '.exe':
        return Icons.app_shortcut;
      default:
        return Icons.insert_drive_file;
    }
  }

  Color get iconColor {
    if (isFolder) {
      return const Color(0xFFDDB100);
    }

    // Color coding for different file types
    switch (extension) {
      case '.dart':
        return const Color(0xFF40C4FF);
      case '.py':
        return const Color(0xFF4CAF50);
      case '.js':
        return const Color(0xFFF0DB4F);
      case '.ts':
        return const Color(0xFF007ACC);
      case '.html':
        return const Color(0xFFE44D26);
      case '.css':
        return const Color(0xFF563D7C);
      case '.json':
        return const Color(0xFFFFA000);
      case '.md':
        return const Color(0xFF42A5F5);
      case '.jpg':
      case '.jpeg':
      case '.png':
      case '.gif':
      case '.bmp':
        return const Color(0xFF9C27B0);
      case '.mp4':
      case '.avi':
      case '.mov':
      case '.wmv':
        return const Color(0xFFE91E63);
      case '.mp3':
      case '.wav':
      case '.ogg':
        return const Color(0xFF673AB7);
      default:
        return Colors.white70;
    }
  }
}

class FileSystemModel extends ChangeNotifier {
  FileNode root = FileNode(
    name: 'Workspace',
    id: 'root',
    isFolder: true,
    isExpanded: true,
  );

  String? _currentWorkspacePath;
  FileNode? _selectedNode;
  List<String> _recentWorkspaces = [];
  bool _loading = false;

  FileSystemModel() {
    _loadRecentWorkspaces();
  }

  FileNode? get selectedNode => _selectedNode;
  String? get currentWorkspacePath => _currentWorkspacePath;
  List<String> get recentWorkspaces => _recentWorkspaces;
  bool get isLoading => _loading;

  set selectedNode(FileNode? node) {
    _selectedNode = node;
    notifyListeners();
  }

  Future<void> _loadRecentWorkspaces() async {
    final prefs = await SharedPreferences.getInstance();
    _recentWorkspaces = prefs.getStringList('recentWorkspaces') ?? [];
    notifyListeners();
  }

  Future<void> _saveRecentWorkspaces() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('recentWorkspaces', _recentWorkspaces);
  }

  Future<void> openWorkspace() async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath(
      dialogTitle: 'Select Workspace Folder',
    );

    if (selectedDirectory != null) {
      await setWorkspace(selectedDirectory);
    }
  }

  Future<void> setWorkspace(String workspacePath) async {
    try {
      _loading = true;
      notifyListeners();

      _currentWorkspacePath = workspacePath;

      // Update recent workspaces list
      _recentWorkspaces.remove(workspacePath);
      _recentWorkspaces.insert(0, workspacePath);
      if (_recentWorkspaces.length > 10) {
        _recentWorkspaces = _recentWorkspaces.sublist(0, 10);
      }
      await _saveRecentWorkspaces();

      // Reset and rebuild the file tree
      root = FileNode(
        name: path_util.basename(workspacePath),
        id: workspacePath,
        isFolder: true,
        isExpanded: true,
        physicalPath: workspacePath,
      );

      await _loadDirectoryContents(root);
      _loading = false;
      notifyListeners();
    } catch (e) {
      _loading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> _loadDirectoryContents(FileNode folderNode) async {
    if (folderNode.physicalPath == null) return;

    try {
      final dir = Directory(folderNode.physicalPath!);
      if (!await dir.exists()) return;

      final entities = await dir.list().toList();
      folderNode.children.clear();

      for (var entity in entities) {
        final isDir = entity is Directory;
        final name = path_util.basename(entity.path);

        // Skip hidden files/folders that start with a dot
        if (name.startsWith('.')) continue;

        final stats = await entity.stat();

        final node = FileNode(
          name: name,
          id: entity.path,
          isFolder: isDir,
          parent: folderNode,
          physicalPath: entity.path,
          lastModified: stats.modified,
          size: isDir ? null : stats.size,
        );

        folderNode.children.add(node);
      }

      // Sort: folders first, then files, both alphabetically
      folderNode.children.sort((a, b) {
        if (a.isFolder && !b.isFolder) return -1;
        if (!a.isFolder && b.isFolder) return 1;
        return a.name.toLowerCase().compareTo(b.name.toLowerCase());
      });
    } catch (e) {
      debugPrint('Error loading directory contents: $e');
    }
  }

  List<FileNode> get allNodes {
    List<FileNode> result = [];
    _collectNodes(root, result);
    return result;
  }

  void _collectNodes(FileNode node, List<FileNode> result) {
    result.add(node);
    for (var child in node.children) {
      _collectNodes(child, result);
    }
  }

  FileNode? findNodeById(String id) {
    for (var node in allNodes) {
      if (node.id == id) {
        return node;
      }
    }
    return null;
  }

  Future<void> toggleExpanded(String nodeId) async {
    final node = findNodeById(nodeId);
    if (node != null && node.isFolder) {
      node.isExpanded = !node.isExpanded;

      // Load contents when expanding a folder
      if (node.isExpanded && node.children.isEmpty) {
        await _loadDirectoryContents(node);
      }

      notifyListeners();
    }
  }

  Future<void> createNewFolder(String name, {String? parentId}) async {
    final parent = parentId != null ? findNodeById(parentId) : root;

    if (parent != null && parent.isFolder && parent.physicalPath != null) {
      // Check if folder with same name exists
      final existingNames = parent.children.map((e) => e.name).toList();
      String newName = name;
      int counter = 1;

      while (existingNames.contains(newName)) {
        newName = '$name ($counter)';
        counter++;
      }

      try {
        // Create the physical directory
        final newDirPath = path_util.join(parent.physicalPath!, newName);
        final newDir = await Directory(newDirPath).create();

        // Create the node
        final newNode = FileNode(
          name: newName,
          id: newDir.path,
          isFolder: true,
          parent: parent,
          physicalPath: newDir.path,
          lastModified: DateTime.now(),
        );

        parent.children.add(newNode);
        parent.isExpanded = true; // Expand parent to show new folder

        // Sort the parent's children
        parent.children.sort((a, b) {
          if (a.isFolder && !b.isFolder) return -1;
          if (!a.isFolder && b.isFolder) return 1;
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        });

        notifyListeners();
      } catch (e) {
        debugPrint('Error creating folder: $e');
        rethrow;
      }
    }
  }

  Future<void> createNewFile(String name, {String? parentId}) async {
    final parent = parentId != null ? findNodeById(parentId) : root;

    if (parent != null && parent.isFolder && parent.physicalPath != null) {
      // Check if file with same name exists
      final existingNames = parent.children.map((e) => e.name).toList();
      String newName = name;
      int counter = 1;

      while (existingNames.contains(newName)) {
        final baseName = name.contains('.')
            ? name.substring(0, name.lastIndexOf('.'))
            : name;
        final extension =
            name.contains('.') ? name.substring(name.lastIndexOf('.')) : '';
        newName = '$baseName ($counter)$extension';
        counter++;
      }

      try {
        // Create the physical file
        final newFilePath = path_util.join(parent.physicalPath!, newName);
        final newFile = await File(newFilePath).create();

        // Create the node
        final newNode = FileNode(
          name: newName,
          id: newFile.path,
          isFolder: false,
          parent: parent,
          physicalPath: newFile.path,
          lastModified: DateTime.now(),
          size: 0,
        );

        parent.children.add(newNode);
        parent.isExpanded = true; // Expand parent to show new file

        // Sort the parent's children
        parent.children.sort((a, b) {
          if (a.isFolder && !b.isFolder) return -1;
          if (!a.isFolder && b.isFolder) return 1;
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        });

        notifyListeners();
      } catch (e) {
        debugPrint('Error creating file: $e');
        rethrow;
      }
    }
  }

  Future<void> renameNode(String nodeId, String newName) async {
    final node = findNodeById(nodeId);
    if (node != null && node.physicalPath != null) {
      // Check for name conflicts with siblings
      final siblings = node.parent?.children ?? [];
      final existingNames =
          siblings.where((e) => e.id != nodeId).map((e) => e.name).toList();

      if (existingNames.contains(newName)) {
        // Handle name conflict
        int counter = 1;
        String adjustedName = newName;

        while (existingNames.contains(adjustedName)) {
          if (node.isFolder) {
            adjustedName = '$newName ($counter)';
          } else {
            final baseName = newName.contains('.')
                ? newName.substring(0, newName.lastIndexOf('.'))
                : newName;
            final extension = newName.contains('.')
                ? newName.substring(newName.lastIndexOf('.'))
                : '';
            adjustedName = '$baseName ($counter)$extension';
          }
          counter++;
        }

        newName = adjustedName;
      }

      try {
        final oldPath = node.physicalPath!;
        final parentPath = path_util.dirname(oldPath);
        final newPath = path_util.join(parentPath, newName);

        if (node.isFolder) {
          // Rename directory
          final dir = Directory(oldPath);
          await dir.rename(newPath);
        } else {
          // Rename file
          final file = File(oldPath);
          await file.rename(newPath);
        }

        // Update the node
        node.name = newName;
        node.physicalPath = newPath;
        node.id = newPath;

        notifyListeners();
      } catch (e) {
        debugPrint('Error renaming: $e');
        rethrow;
      }
    }
  }

  Future<void> deleteNode(String nodeId) async {
    final node = findNodeById(nodeId);
    if (node != null && node.parent != null && node.physicalPath != null) {
      try {
        if (node.isFolder) {
          // Delete directory
          final dir = Directory(node.physicalPath!);
          await dir.delete(recursive: true);
        } else {
          // Delete file
          final file = File(node.physicalPath!);
          await file.delete();
        }

        // Remove from parent's children
        node.parent!.children.removeWhere((child) => child.id == nodeId);

        // If this was the selected node, clear selection
        if (_selectedNode?.id == nodeId) {
          _selectedNode = null;
        }

        notifyListeners();
      } catch (e) {
        debugPrint('Error deleting: $e');
        rethrow;
      }
    }
  }

  Future<void> refresh({String? nodeId}) async {
    final node = nodeId != null ? findNodeById(nodeId) : root;
    if (node != null && node.isFolder && node.physicalPath != null) {
      await _loadDirectoryContents(node);
      notifyListeners();
    }
  }

  Future<void> collapseAll() async {
    _setExpandedStateRecursively(root, false);
    notifyListeners();
  }

  Future<void> expandAll() async {
    await _expandAllRecursively(root);
    notifyListeners();
  }

  void _setExpandedStateRecursively(FileNode node, bool isExpanded) {
    if (node.isFolder && node != root) {
      node.isExpanded = isExpanded;
    }

    for (var child in node.children) {
      _setExpandedStateRecursively(child, isExpanded);
    }
  }

  Future<void> _expandAllRecursively(FileNode node) async {
    if (node.isFolder) {
      node.isExpanded = true;

      if (node.children.isEmpty && node.physicalPath != null) {
        await _loadDirectoryContents(node);
      }

      for (var child in node.children) {
        await _expandAllRecursively(child);
      }
    }
  }
}
