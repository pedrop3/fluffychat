import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Para selecionar imagens e vídeos
//import 'package:amplify_flutter/amplify_flutter.dart';
//import 'package:amplify_storage_s3/amplify_storage_s3.dart';

class FileExplorerPage extends StatefulWidget {
  @override
  _FileExplorerPageState createState() => _FileExplorerPageState();
}

class _FileExplorerPageState extends State<FileExplorerPage> {
  List<StorageItem> files = [];
  bool isLoading = false;
  final ImagePicker _picker = ImagePicker(); // Para selecionar imagens e vídeos

  @override
  void initState() {
    super.initState();
    _listFiles(); // Carrega os arquivos assim que o widget é exibido
  }

  Future<void> _listFiles() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Chama a função do Amplify para listar os arquivos no bucket S3
      // final listResult = await Amplify.Storage.list();
      setState(() {
        files = [
          StorageItem(
            key: 'prova-1/arquivo1.pdf',
            size: 1024,
            lastModified: DateTime.now().subtract(Duration(days: 1)),
            eTag: '1234567890',
          ),
          StorageItem(
            key: 'documentos/foto1.png',
            size: 2048,
            lastModified: DateTime.now().subtract(Duration(days: 3)),
            eTag: '0987654321',
          ),
          StorageItem(
            key: 'documentos/video1.mp4',
            size: 5120,
            lastModified: DateTime.now().subtract(Duration(days: 7)),
            eTag: 'abcdefghij',
          ),
          StorageItem(
            key: 'documentos/arquivo2.pdf',
            size: 3072,
            lastModified: DateTime.now().subtract(Duration(days: 2)),
            eTag: '1122334455',
          ),
          StorageItem(
            key: 'documentos/foto2.jpg',
            size: 1024,
            lastModified: DateTime.now().subtract(Duration(days: 5)),
            eTag: '5566778899',
          ),
        ];
      });
    } catch (e) {
      print('Erro ao listar arquivos: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showActionSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Wrap(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.upload_file),
            title: Text('Upload de Arquivos'),
            onTap: () {
              Navigator.pop(context);
              _uploadFiles();
            },
          ),
          ListTile(
            leading: Icon(Icons.camera_alt),
            title: Text('Abrir Câmera'),
            onTap: () {
              Navigator.pop(context);
              _openCamera();
            },
          ),
          ListTile(
            leading: Icon(Icons.video_camera_back),
            title: Text('Abrir Vídeo'),
            onTap: () {
              Navigator.pop(context);
              _openVideo();
            },
          ),
          ListTile(
            leading: Icon(Icons.folder_open),
            title: Text('Criar Novo Caminho'),
            onTap: () {
              Navigator.pop(context);
              _createNewPath();
            },
          ),
        ],
      ),
    );
  }

  Future<void> _uploadFiles() async {
    // Implementar lógica para upload de arquivos
  }

  Future<void> _openCamera() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      // Faça algo com a imagem
      print('Imagem capturada: ${photo.path}');
    }
  }

  Future<void> _openVideo() async {
    final XFile? video = await _picker.pickVideo(source: ImageSource.camera);
    if (video != null) {
      // Faça algo com o vídeo
      print('Vídeo capturado: ${video.path}');
    }
  }

  Future<void> _createNewPath() async {
    final TextEditingController _controller = TextEditingController();

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // Não permite fechar o diálogo clicando fora dele
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Criar Novo Caminho'),
          content: TextField(
            controller: _controller,
            decoration: InputDecoration(hintText: 'Nome do novo caminho'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Criar'),
              onPressed: () {
                final pathName = _controller.text.trim();
                if (pathName.isNotEmpty) {
                  // Adicione a lógica para criar o novo caminho
                  print('Criar novo caminho: $pathName');
                  // Atualize a lista de arquivos se necessário
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Explorador de Arquivos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (isLoading)
              Center(child: CircularProgressIndicator())
            else if (files.isEmpty)
              Center(child: Text('Nenhum arquivo encontrado.', style: TextStyle(fontSize: 18)))
            else
              Expanded(
                child: ListView.builder(
                  itemCount: files.length,
                  itemBuilder: (context, index) {
                    final file = files[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 4,
                      child: ListTile(
                        leading: Icon(Icons.folder),
                        title: Text(
                          file.key, // Exibe o nome do arquivo/pasta
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        trailing: Icon(Icons.arrow_forward),
                        onTap: () {
                          // Ação ao clicar no arquivo/pasta
                        },
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showActionSheet,
        child: Icon(Icons.add),
        tooltip: 'Adicionar',
      ),
    );
  }
}
