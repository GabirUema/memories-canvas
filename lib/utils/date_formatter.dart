import 'package:intl/intl.dart';

// Atalhos pra formatar data em português.
class DateFormatter {
  DateFormatter._();

  // 16/06/2026
  static String short(DateTime date) {
    return DateFormat('dd/MM/yyyy', 'pt_BR').format(date);
  }

  // 16 de junho de 2026
  static String long(DateTime date) {
    return DateFormat("d 'de' MMMM 'de' y", 'pt_BR').format(date);
  }
}
