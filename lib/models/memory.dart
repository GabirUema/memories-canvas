// Uma memória do diário. O imagePath aponta pra foto que já foi copiada
// pra pasta do app (e não pro caminho temporário que a galeria devolve).
class Memory {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String imagePath;

  Memory({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.imagePath,
  });

  // Vira um mapa pra jogar no jsonEncode. Salvo a data em ISO pra não ter
  // dor de cabeça com formato/fuso na hora de ler de volta.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'imagePath': imagePath,
    };
  }

  // Caminho de volta: do mapa do jsonDecode pro objeto.
  factory Memory.fromJson(Map<String, dynamic> json) {
    return Memory(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      date: DateTime.parse(json['date']),
      imagePath: json['imagePath'],
    );
  }
}
