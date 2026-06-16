import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/memory.dart';
import '../services/memory_storage.dart';

// Tela pra cadastrar uma memória nova: escolhe a foto, preenche título e
// descrição e salva. No fim volto pra Home com "true" pra ela atualizar.
class AddMemoryScreen extends StatefulWidget {
  const AddMemoryScreen({super.key});

  @override
  State<AddMemoryScreen> createState() => _AddMemoryScreenState();
}

class _AddMemoryScreenState extends State<AddMemoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tituloCtrl = TextEditingController();
  final _descricaoCtrl = TextEditingController();

  final _storage = MemoryStorage();
  final _picker = ImagePicker();

  File? _foto; // foto escolhida (ainda no caminho temporário da galeria)
  bool _salvando = false;

  @override
  void dispose() {
    _tituloCtrl.dispose();
    _descricaoCtrl.dispose();
    super.dispose();
  }

  Future<void> _escolherFoto() async {
    try {
      final img = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (img == null) return; // usuário cancelou
      setState(() => _foto = File(img.path));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Não consegui abrir a galeria: $e')),
      );
    }
  }

  Future<void> _salvar() async {
    final formOk = _formKey.currentState?.validate() ?? false;

    // a foto não tem validator no Form, então checo na mão
    if (_foto == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Escolha uma foto pra memória.')),
      );
      return;
    }
    if (!formOk) return;

    setState(() => _salvando = true);

    try {
      // copio a foto pra pasta do app antes de salvar a memória
      final caminho = await _storage.saveImageToAppDir(_foto!.path);

      final memory = Memory(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _tituloCtrl.text.trim(),
        description: _descricaoCtrl.text.trim(),
        date: DateTime.now(),
        imagePath: caminho,
      );

      await _storage.addMemory(memory);

      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      setState(() => _salvando = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nova memória')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _areaDaFoto(),
              const SizedBox(height: 24),
              TextFormField(
                controller: _tituloCtrl,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Título',
                  hintText: 'Ex.: Pôr do sol em Jericoacoara',
                  prefixIcon: Icon(Icons.title),
                  border: OutlineInputBorder(),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Coloca um título.';
                  }
                  if (v.trim().length < 3) {
                    return 'O título tá muito curto.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descricaoCtrl,
                textCapitalization: TextCapitalization.sentences,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Descrição',
                  hintText: 'Conta o que rolou nesse momento...',
                  alignLabelWithHint: true,
                  prefixIcon: Icon(Icons.notes),
                  border: OutlineInputBorder(),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Escreve uma descrição.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              FilledButton.icon(
                onPressed: _salvando ? null : _salvar,
                icon: _salvando
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.save_outlined),
                label: Text(_salvando ? 'Salvando...' : 'Salvar memória'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Caixa que mostra o preview da foto ou o convite pra escolher uma.
  Widget _areaDaFoto() {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: _escolherFoto,
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: theme.colorScheme.outlineVariant),
          ),
          clipBehavior: Clip.antiAlias,
          child: _foto == null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_photo_alternate_outlined,
                      size: 48,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(height: 8),
                    const Text('Toque pra escolher uma foto'),
                  ],
                )
              : Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.file(_foto!, fit: BoxFit.cover),
                    Positioned(
                      right: 8,
                      bottom: 8,
                      child: FilledButton.tonalIcon(
                        onPressed: _escolherFoto,
                        icon: const Icon(Icons.edit, size: 18),
                        label: const Text('Trocar'),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
