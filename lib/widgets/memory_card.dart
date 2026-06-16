import 'dart:io';

import 'package:flutter/material.dart';

import '../models/memory.dart';
import '../utils/date_formatter.dart';

// Cada item do feed: foto em cima, título e data embaixo.
class MemoryCard extends StatelessWidget {
  final Memory memory;
  final VoidCallback onTap;

  const MemoryCard({
    super.key,
    required this.memory,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: _Foto(path: memory.imagePath),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    memory.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.event,
                        size: 16,
                        color: theme.colorScheme.tertiary, // verdinho
                      ),
                      const SizedBox(width: 4),
                      Text(
                        DateFormatter.short(memory.date),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Mostra a foto do arquivo. Se por algum motivo o arquivo sumiu, coloco um
// ícone no lugar pra não dar erro feio na tela.
class _Foto extends StatelessWidget {
  final String path;

  const _Foto({required this.path});

  @override
  Widget build(BuildContext context) {
    final file = File(path);

    if (!file.existsSync()) {
      return Container(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: const Center(
          child: Icon(Icons.broken_image_outlined, size: 48),
        ),
      );
    }

    return Image.file(file, fit: BoxFit.cover, width: double.infinity);
  }
}
