import 'package:flutter/material.dart';
//import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';

class FileExplorerPage extends StatefulWidget {
  @override
  _FileExplorerPageState createState() => _FileExplorerPageState();
}

class _FileExplorerPageState extends State<FileExplorerPage> {
  List<StorageItem> files = [];
  bool isLoading = false;

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
            // O botão foi removido para que o carregamento aconteça automaticamente
            // ElevatedButton(
            //   onPressed: _listFiles, // Chama a função ao clicar
            //   child: Text('Abrir'),
            //   style: ElevatedButton.styleFrom(
            //     padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            //     textStyle: TextStyle(fontSize: 20),
            //   ),
            // ),
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
    );
  }
}
