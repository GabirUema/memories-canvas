import 'dart:io';

import 'package:flutter/material.dart';

import '../models/memory.dart';
import '../services/memory_storage.dart';
import '../utils/date_formatter.dart';

// Detalhes de uma memória. A memória chega pelo construtor (vinda da Home).
// Aqui dá pra ver a foto grande e excluir, se quiser.
class MemoryDetailScreen extends StatelessWidget {
  final Memory memory;

  const MemoryDetailScreen({super.key, required this.memory});

  Future<void> _excluir(BuildContext context) async {
    // pergunto antes pra evitar exclusão sem querer
    final confirma = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Excluir memória?'),
        content: const Text(
          'Não dá pra desfazer. A foto também vai sair do aparelho.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirma != true) return;

    await MemoryStorage().deleteMemory(memory.id);

    if (!context.mounted) return;
    Navigator.pop(context, true); // avisa a Home que excluiu
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foto = File(memory.imagePath);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // foto grande no topo, encolhe quando rola a tela
          SliverAppBar(
            expandedHeight: 320,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: foto.existsSync()
                  ? Image.file(foto, fit: BoxFit.cover)
                  : Container(
                      color: theme.colorScheme.surfaceContainerHighest,
                      child: const Center(
                        child: Icon(Icons.broken_image_outlined, size: 64),
                      ),
                    ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    memory.title,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // ListTile com a data (avatar verde combinando com o tema)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      backgroundColor: theme.colorScheme.tertiaryContainer,
                      foregroundColor: theme.colorScheme.onTertiaryContainer,
                      child: const Icon(Icons.event),
                    ),
                    title: const Text('Quando aconteceu'),
                    subtitle: Text(DateFormatter.long(memory.date)),
                  ),
                  const Divider(height: 32),
                  Text(
                    memory.description,
                    style: theme.textTheme.bodyLarge?.copyWith(height: 1.5),
                  ),
                  const SizedBox(height: 32),
                  OutlinedButton.icon(
                    onPressed: () => _excluir(context),
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('Excluir memória'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: theme.colorScheme.error,
                      side: BorderSide(color: theme.colorScheme.error),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      minimumSize: const Size.fromHeight(0),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
