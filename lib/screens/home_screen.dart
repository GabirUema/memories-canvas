import 'package:flutter/material.dart';

import '../models/memory.dart';
import '../services/memory_storage.dart';
import '../widgets/empty_state.dart';
import '../widgets/memory_card.dart';
import 'add_memory_screen.dart';
import 'memory_detail_screen.dart';

// Tela principal: a lista (feed) de memórias.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _storage = MemoryStorage();

  List<Memory> _memories = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    // assim que a tela abre, já carrego o que tá salvo no arquivo
    _carregar();
  }

  Future<void> _carregar() async {
    setState(() => _loading = true);
    final memories = await _storage.loadMemories();
    if (!mounted) return;
    setState(() {
      _memories = memories;
      _loading = false;
    });
  }

  // Abre o cadastro. Se voltar com "true" (salvou), recarrego a lista.
  Future<void> _novaMemoria() async {
    final salvou = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const AddMemoryScreen()),
    );

    if (salvou == true) {
      await _carregar();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Memória salva!')),
      );
    }
  }

  // Abre os detalhes mandando a memória pelo construtor. Se voltar "true"
  // foi porque excluiu lá dentro, então atualizo o feed.
  Future<void> _abrirDetalhe(Memory memory) async {
    final excluiu = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => MemoryDetailScreen(memory: memory)),
    );

    if (excluiu == true) {
      await _carregar();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Memória excluída.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _carregar,
        child: CustomScrollView(
          slivers: [
            const SliverAppBar.large(
              title: Text('MemoriesCanvas'),
              floating: true,
              pinned: true,
            ),
            _corpo(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _novaMemoria,
        icon: const Icon(Icons.add_a_photo_outlined),
        label: const Text('Nova memória'),
      ),
    );
  }

  Widget _corpo() {
    if (_loading) {
      return const SliverFillRemaining(
        hasScrollBody: false,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    // sem memórias ainda -> mostro a mensagem de boas-vindas
    if (_memories.isEmpty) {
      return const SliverFillRemaining(
        hasScrollBody: false,
        child: EmptyState(),
      );
    }

    return SliverList.builder(
      itemCount: _memories.length,
      itemBuilder: (context, index) {
        final memory = _memories[index];
        return MemoryCard(
          memory: memory,
          onTap: () => _abrirDetalhe(memory),
        );
      },
    );
  }
}
