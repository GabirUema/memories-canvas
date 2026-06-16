import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:memories_canvas/models/memory.dart';
import 'package:memories_canvas/widgets/empty_state.dart';

void main() {
  test('Memory: salvar em json e ler de volta dá o mesmo objeto', () {
    final original = Memory(
      id: '123',
      title: 'Viagem à praia',
      description: 'Um fim de semana que não esqueço.',
      date: DateTime(2026, 6, 16, 10, 30),
      imagePath: '/data/images/mem_123.jpg',
    );

    final lido = Memory.fromJson(original.toJson());

    expect(lido.id, original.id);
    expect(lido.title, original.title);
    expect(lido.description, original.description);
    expect(lido.date, original.date);
    expect(lido.imagePath, original.imagePath);
  });

  testWidgets('EmptyState mostra a mensagem de feed vazio', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: EmptyState())),
    );

    expect(find.textContaining('Nenhuma memória registrada'), findsOneWidget);
  });
}
