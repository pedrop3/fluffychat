import 'package:flutter/material.dart';

import 'file_node.dart';
import 'folder_node.dart';

class FileExplorer extends StatefulWidget {
  final FolderNode rootFolder;

  FileExplorer(this.rootFolder);

  @override
  _FileExplorerState createState() => _FileExplorerState();
}

class _FileExplorerState extends State<FileExplorer> {
  late FolderNode _currentFolder;
  List<FolderNode> _folderHistory = [];

  @override
  void initState() {
    super.initState();
    _currentFolder = widget.rootFolder;
  }

  void _onFolderTap(FolderNode folder) {
    setState(() {
      // Add the current folder to the history stack before navigating
      _folderHistory.add(_currentFolder);
      _currentFolder = folder;
    });
  }

  void _onBackButtonPressed() {
    if (_folderHistory.isNotEmpty) {
      setState(() {
        // Pop the last folder from the history stack
        _currentFolder = _folderHistory.removeLast();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('File Explorer'),
        leading: _folderHistory.isNotEmpty
            ? IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: _onBackButtonPressed,
        )
            : null,
      ),
      body: ListView(
        children: _currentFolder.children.map<Widget>((node) {
          if (node is FolderNode) {
            return ListTile(
              title: Text(node.name),
              leading: Icon(Icons.folder),
              onTap: () => _onFolderTap(node),
            );
          } else if (node is FileNode) {
            return ListTile(
              title: Text(node.name),
              leading: Icon(Icons.insert_drive_file),
            );
          } else {
            return SizedBox.shrink();
          }
        }).toList(),
      ),
    );
  }
}
