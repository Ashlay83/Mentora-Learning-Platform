import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// Add this import at the top of your file
import 'pdf_viewer_screen.dart';
import '../models/file_system_model.dart';

class ExplorerView extends StatelessWidget {
  const ExplorerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<FileSystemModel>(
      builder: (context, fileSystem, child) {
        return ListView(
          padding: const EdgeInsets.all(8),
          children: _buildTreeNodes(context, fileSystem.root, fileSystem),
        );
      },
    );
  }

  List<Widget> _buildTreeNodes(
      BuildContext context, FileNode node, FileSystemModel fileSystem,
      {int depth = 0}) {
    List<Widget> widgets = [];

    // Add the node itself
    if (node.id != 'root') {
      // Skip rendering the root itself
      widgets.add(
        GestureDetector(
          onSecondaryTap: () => _showContextMenu(context, node, fileSystem),
          child: InkWell(
            onTap: () {
              void _handleFileSelection(FileNode node) {
                if (!node.isFolder) {
                  if (node.physicalPath != null &&
                      node.name.toLowerCase().endsWith('.pdf')) {
                    // It's a PDF file, open it with the PDF viewer
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => PdfViewerScreen(
                          filePath: node.physicalPath!,
                          fileName: node.name,
                        ),
                      ),
                    );
                  } else {
                    // Handle other file types or show a message
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text(
                              'This file type is not supported for viewing')),
                    );
                  }
                }
              }

              if (node.isFolder) {
                fileSystem.toggleExpanded(node.id);
              } else {
                // Set selected node
                _handleFileSelection(node);
              }
            },
            child: Container(
              padding: EdgeInsets.only(
                left: 8.0 * depth,
                top: 6,
                bottom: 6,
                right: 8,
              ),
              child: Row(
                children: [
                  if (node.isFolder)
                    Icon(
                      node.isExpanded
                          ? Icons.arrow_drop_down
                          : Icons.arrow_right,
                      size: 16,
                      color: Colors.white70,
                    ),
                  if (!node.isFolder) const SizedBox(width: 16),
                  Icon(
                    node.icon,
                    size: 16,
                    color: node.iconColor,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      node.name,
                      style: TextStyle(
                        fontSize: 13,
                        color: fileSystem.selectedNode?.id == node.id
                            ? Colors.white
                            : Colors.white70,
                        fontWeight: fileSystem.selectedNode?.id == node.id
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    // Add children if expanded
    if ((node.isFolder && node.isExpanded) || node.id == 'root') {
      for (var child in node.children) {
        widgets.addAll(_buildTreeNodes(
          context,
          child,
          fileSystem,
          depth: node.id == 'root' ? depth : depth + 1,
        ));
      }
    }

    return widgets;
  }

  void _showContextMenu(
      BuildContext context, FileNode node, FileSystemModel fileSystem) {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final RenderBox button = context.findRenderObject() as RenderBox;
    final Offset position = button.localToGlobal(
      Offset.zero,
      ancestor: overlay,
    );

    showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy,
        position.dx + button.size.width,
        position.dy + button.size.height,
      ),
      items: [
        if (node.isFolder)
          const PopupMenuItem<String>(
            value: 'new_file',
            child: Row(
              children: [
                Icon(Icons.note_add, size: 16),
                SizedBox(width: 8),
                Text('New File'),
              ],
            ),
          ),
        if (node.isFolder)
          const PopupMenuItem<String>(
            value: 'new_folder',
            child: Row(
              children: [
                Icon(Icons.create_new_folder, size: 16),
                SizedBox(width: 8),
                Text('New Folder'),
              ],
            ),
          ),
        const PopupMenuItem<String>(
          value: 'rename',
          child: Row(
            children: [
              Icon(Icons.edit, size: 16),
              SizedBox(width: 8),
              Text('Rename'),
            ],
          ),
        ),
        const PopupMenuItem<String>(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete, size: 16),
              SizedBox(width: 8),
              Text('Delete'),
            ],
          ),
        ),
      ],
    ).then((value) {
      if (value == null) return;

      switch (value) {
        case 'new_file':
          _showNewFileDialog(context, node, fileSystem);
          break;
        case 'new_folder':
          _showNewFolderDialog(context, node, fileSystem);
          break;
        case 'rename':
          _showRenameDialog(context, node, fileSystem);
          break;
        case 'delete':
          _showDeleteConfirmation(context, node, fileSystem);
          break;
      }
    });
  }

  void _showNewFileDialog(
      BuildContext context, FileNode node, FileSystemModel fileSystem) {
    final TextEditingController controller =
        TextEditingController(text: 'newfile.txt');

    showDialog(
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
                      parentId: node.id,
                    );
                    Navigator.of(context).pop();
                  } catch (e) {
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

  void _showNewFolderDialog(
      BuildContext context, FileNode node, FileSystemModel fileSystem) {
    final TextEditingController controller =
        TextEditingController(text: 'New Folder');

    showDialog(
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
                      parentId: node.id,
                    );
                    Navigator.of(context).pop();
                  } catch (e) {
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

  void _showRenameDialog(
      BuildContext context, FileNode node, FileSystemModel fileSystem) {
    final TextEditingController controller =
        TextEditingController(text: node.name);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Rename ${node.isFolder ? 'Folder' : 'File'}'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Name',
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
                    await fileSystem.renameNode(
                        node.id, controller.text.trim());
                    Navigator.of(context).pop();
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error renaming: $e')),
                    );
                  }
                }
              },
              child: const Text('Rename'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmation(
      BuildContext context, FileNode node, FileSystemModel fileSystem) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete ${node.isFolder ? 'Folder' : 'File'}'),
          content: Text(
              'Are you sure you want to delete "${node.name}"? This cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              onPressed: () async {
                try {
                  await fileSystem.deleteNode(node.id);
                  Navigator.of(context).pop();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error deleting: $e')),
                  );
                }
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
