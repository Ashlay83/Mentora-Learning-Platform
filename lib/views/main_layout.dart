import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vscode_explorer/services/auth_service.dart';
import 'package:vscode_explorer/views/login_screen.dart';
import '../models/file_system_model.dart';
import 'explorer_view.dart';
import 'empty_state.dart';
import 'question_paper_generator.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({Key? key}) : super(key: key);

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  double _explorerWidth = 250;
  bool _resizing = false;
// Add this method to the _MainLayoutState class:
  void _showQuestionPaperGenerator(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const QuestionPaperGeneratorScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final fileSystem = Provider.of<FileSystemModel>(context);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Row(
          children: [
            const Text('Mentora'),
            if (fileSystem.currentWorkspacePath != null) ...[
              const SizedBox(width: 16),
              Text(
                '- ${fileSystem.root.name}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: Colors.white70,
                ),
              ),
            ],
          ],
        ),
        actions: [
          // Add this to the AppBar actions array in main_layout.dart
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Logout'),
                  content: const Text(
                    'Are you sure you want to logout?',
                    style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Provider.of<AuthService>(context, listen: false)
                            .logout();
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                      child: const Text('Logout'),
                    ),
                  ],
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.folder_open),
            tooltip: 'Open Folder',
            onPressed: () async {
              try {
                await fileSystem.openWorkspace();
              } catch (e) {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error opening folder: $e')),
                );
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.assignment),
            tooltip: 'Generate Question Paper',
            onPressed: () {
              _showQuestionPaperGenerator(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh Explorer',
            onPressed: fileSystem.isLoading ? null : () => fileSystem.refresh(),
          ),
          PopupMenuButton<String>(
            tooltip: 'More Options',
            onSelected: (value) async {
              switch (value) {
                case 'collapse_all':
                  await fileSystem.collapseAll();
                  break;
                case 'expand_all':
                  await fileSystem.expandAll();
                  break;
                case 'new_file':
                  await _showNewFileDialog(context);
                  break;
                case 'new_folder':
                  await _showNewFolderDialog(context);
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'collapse_all',
                child: Text('Collapse All'),
              ),
              const PopupMenuItem(
                value: 'expand_all',
                child: Text('Expand All'),
              ),
              const PopupMenuItem(
                value: 'new_file',
                child: Text('New File'),
              ),
              const PopupMenuItem(
                value: 'new_folder',
                child: Text('New Folder'),
              ),
            ],
          ),
        ],
      ),
      body: fileSystem.currentWorkspacePath == null
          ? const EmptyState()
          : Row(
              children: [
                // Explorer panel
                SizedBox(
                  width: _explorerWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        color: const Color(0xFF252526),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'EXPLORER',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white70,
                              ),
                            ),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () => _showNewFileDialog(context),
                                  child: const Tooltip(
                                    message: 'New File',
                                    child: Icon(
                                      Icons.note_add,
                                      size: 16,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                InkWell(
                                  onTap: () => _showNewFolderDialog(context),
                                  child: const Tooltip(
                                    message: 'New Folder',
                                    child: Icon(
                                      Icons.create_new_folder,
                                      size: 16,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                InkWell(
                                  onTap: fileSystem.isLoading
                                      ? null
                                      : () => fileSystem.refresh(),
                                  child: const Tooltip(
                                    message: 'Refresh',
                                    child: Icon(
                                      Icons.refresh,
                                      size: 16,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      if (fileSystem.isLoading) const LinearProgressIndicator(),
                      const Expanded(
                        child: ExplorerView(),
                      ),
                    ],
                  ),
                ),

                // Resizer
                GestureDetector(
                  onHorizontalDragStart: (details) {
                    setState(() {
                      _resizing = true;
                    });
                  },
                  onHorizontalDragUpdate: (details) {
                    setState(() {
                      _explorerWidth += details.delta.dx;
                      // Enforce minimum and maximum width
                      _explorerWidth = _explorerWidth.clamp(150.0, 500.0);
                    });
                  },
                  onHorizontalDragEnd: (details) {
                    setState(() {
                      _resizing = false;
                    });
                  },
                  child: MouseRegion(
                    cursor: SystemMouseCursors.resizeLeftRight,
                    child: Container(
                      width: 5,
                      color: _resizing
                          ? Theme.of(context).colorScheme.secondary
                          : Colors.grey[800],
                    ),
                  ),
                ),

                // Main content area
                Expanded(
                  child: fileSystem.selectedNode == null
                      ? _buildWelcomeContent()
                      : _buildFileContent(fileSystem.selectedNode!),
                ),
              ],
            ),
    );
  }

  Future<void> _showNewFileDialog(BuildContext context) async {
    final TextEditingController controller =
        TextEditingController(text: 'newfile.txt');
    final fileSystem = Provider.of<FileSystemModel>(context, listen: false);

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Create New File'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'File Name',
              hintText: 'e.g. myfile.txt',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (controller.text.trim().isNotEmpty) {
                  try {
                    await fileSystem.createNewFile(
                      controller.text.trim(),
                      parentId: fileSystem.selectedNode?.isFolder == true
                          ? fileSystem.selectedNode?.id
                          : fileSystem.selectedNode?.parent?.id,
                    );
                    if (!mounted) return;
                    Navigator.of(context).pop();
                  } catch (e) {
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error creating file: $e')),
                    );
                  }
                }
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showNewFolderDialog(BuildContext context) async {
    final TextEditingController controller =
        TextEditingController(text: 'New Folder');
    final fileSystem = Provider.of<FileSystemModel>(context, listen: false);

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Create New Folder'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Folder Name',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (controller.text.trim().isNotEmpty) {
                  try {
                    await fileSystem.createNewFolder(
                      controller.text.trim(),
                      parentId: fileSystem.selectedNode?.isFolder == true
                          ? fileSystem.selectedNode?.id
                          : fileSystem.selectedNode?.parent?.id,
                    );
                    if (!mounted) return;
                    Navigator.of(context).pop();
                  } catch (e) {
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error creating folder: $e')),
                    );
                  }
                }
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildWelcomeContent() {
    return Container(
      color: const Color(0xFF1E1E1E),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.description_outlined,
              size: 64,
              color: Colors.white30,
            ),
            const SizedBox(height: 16),
            const Text(
              'Select a file to view its contents',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 8),
            Text(
              'Or create a new file using the explorer panel',
              style: TextStyle(
                color: Colors.white.withAlpha(128),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFileContent(FileNode node) {
    if (node.isFolder) {
      return _buildFolderContent(node);
    }

    // Simple text file preview
    return FutureBuilder<String>(
      future: _readFileContents(node.physicalPath!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error loading file: ${snapshot.error}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        return Container(
          color: const Color(0xFF1E1E1E),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                color: const Color(0xFF252526),
                child: Row(
                  children: [
                    Icon(
                      node.icon,
                      size: 16,
                      color: node.iconColor,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      node.name,
                      style: const TextStyle(color: Colors.white),
                    ),
                    const Spacer(),
                    Text(
                      'Last modified: ${_formatDate(node.lastModified)}',
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E1E),
                    border: Border.all(color: const Color(0xFF333333)),
                  ),
                  child: SingleChildScrollView(
                    child: SelectableText(
                      snapshot.data ?? '',
                      style: const TextStyle(
                        fontFamily: 'Consolas, monospace',
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFolderContent(FileNode node) {
    return Container(
      color: const Color(0xFF1E1E1E),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.folder_open,
              size: 64,
              color: node.iconColor,
            ),
            const SizedBox(height: 16),
            Text(
              node.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${node.children.length} item${node.children.length != 1 ? 's' : ''}',
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text('Refresh Folder'),
              onPressed: () {
                Provider.of<FileSystemModel>(context, listen: false)
                    .refresh(nodeId: node.id);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0078D7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> _readFileContents(String path) async {
    try {
      final file = File(path);
      if (await file.exists()) {
        // Check file size before reading
        final fileSize = await file.length();
        if (fileSize > 1024 * 1024) {
          // Larger than 1MB
          return '[File is too large to display]';
        }

        // Try to read the file as text
        return await file.readAsString();
      } else {
        return '[File does not exist]';
      }
    } catch (e) {
      // Return placeholder for binary files
      return '[Unable to display content: File may be binary or use an unsupported encoding]';
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Unknown';
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
