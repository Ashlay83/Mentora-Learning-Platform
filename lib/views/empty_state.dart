import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/file_system_model.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fileSystem = Provider.of<FileSystemModel>(context);

    return Container(
      color: const Color(0xFF1E1E1E),
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.folder_open_outlined,
              size: 80,
              color: Color(0xFF505050),
            ),
            const SizedBox(height: 24),
            const Text(
              'No Workspace Open',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Open a folder to start exploring files',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              icon: const Icon(
                Icons.folder_open,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
              label: const Text(
                'Open Folder',
                style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                backgroundColor: const Color.fromARGB(255, 25, 255, 55),
              ),
              onPressed: () async {
                try {
                  await fileSystem.openWorkspace();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error opening folder: $e')),
                  );
                }
              },
            ),
            const SizedBox(height: 24),
            if (fileSystem.recentWorkspaces.isNotEmpty) ...[
              const Text(
                'Recent Workspaces',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Column(
                  children: fileSystem.recentWorkspaces
                      .take(5)
                      .map((path) => ListTile(
                            title: Text(
                              path.split(RegExp(r'[/\\]')).last,
                              style: const TextStyle(color: Colors.white),
                            ),
                            subtitle: Text(
                              path,
                              style: const TextStyle(
                                color: Colors.white54,
                                fontSize: 12,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            leading: const Icon(
                              Icons.folder,
                              color: Color(0xFFDDB100),
                            ),
                            onTap: () => fileSystem.setWorkspace(path),
                          ))
                      .toList(),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
