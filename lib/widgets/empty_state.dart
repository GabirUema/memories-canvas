import 'package:flutter/material.dart';

// Aparece quando ainda não tem nenhuma memória salva.
class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.photo_album_outlined,
              size: 96,
              color: theme.colorScheme.primary.withOpacity(0.4),
            ),
            const SizedBox(height: 24),
            Text(
              'Nenhuma memória registrada ainda',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Comece a criar! Toque no botão + pra guardar\no seu primeiro momento marcante.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
