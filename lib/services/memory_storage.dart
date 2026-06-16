import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../models/memory.dart';

// Aqui mora toda a parte de "salvar na unha": a lista de memórias vai pra um
// arquivo memories.json e as fotos ficam numa pasta images/ dentro do app.
// Nada de SQLite nem SharedPreferences.
class MemoryStorage {
  static const _fileName = 'memories.json';
  static const _imagesDir = 'images';

  Future<Directory> _baseDir() => getApplicationDocumentsDirectory();

  Future<File> _jsonFile() async {
    final dir = await _baseDir();
    return File(p.join(dir.path, _fileName));
  }

  // cria a pasta de imagens se ainda não existir
  Future<Directory> _imagesFolder() async {
    final dir = await _baseDir();
    final images = Directory(p.join(dir.path, _imagesDir));
    if (!await images.exists()) {
      await images.create(recursive: true);
    }
    return images;
  }

  // Lê tudo que tá salvo. Se o arquivo não existe ainda (primeira vez) ou se
  // deu algum problema na leitura, devolvo lista vazia pra não quebrar o app.
  Future<List<Memory>> loadMemories() async {
    try {
      final file = await _jsonFile();
      if (!await file.exists()) return [];

      final content = await file.readAsString();
      if (content.trim().isEmpty) return [];

      final list = jsonDecode(content) as List;
      final memories = list.map((e) => Memory.fromJson(e)).toList();

      // mostro as mais recentes primeiro
      memories.sort((a, b) => b.date.compareTo(a.date));
      return memories;
    } catch (_) {
      return [];
    }
  }

  // reescreve o json inteiro com a lista atual
  Future<void> _save(List<Memory> memories) async {
    final file = await _jsonFile();
    final data = memories.map((m) => m.toJson()).toList();
    await file.writeAsString(jsonEncode(data), flush: true);
  }

  // Copia a foto que veio da galeria pra pasta do app e devolve o novo
  // caminho (esse sim é o que eu guardo na memória).
  Future<String> saveImageToAppDir(String sourcePath) async {
    final images = await _imagesFolder();
    final fileName = 'mem_${DateTime.now().millisecondsSinceEpoch}'
        '${p.extension(sourcePath)}';
    final dest = p.join(images.path, fileName);

    await File(sourcePath).copy(dest);
    return dest;
  }

  Future<void> addMemory(Memory memory) async {
    final memories = await loadMemories();
    memories.insert(0, memory);
    await _save(memories);
  }

  // Apaga a memória do json E remove a foto do disco.
  Future<void> deleteMemory(String id) async {
    final memories = await loadMemories();
    final index = memories.indexWhere((m) => m.id == id);
    if (index == -1) return;

    final removed = memories.removeAt(index);

    // tento apagar a imagem, mas se falhar não deixo travar a exclusão
    try {
      final img = File(removed.imagePath);
      if (await img.exists()) await img.delete();
    } catch (_) {}

    await _save(memories);
  }
}
