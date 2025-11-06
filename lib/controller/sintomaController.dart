import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SintomaController extends GetxController {
  final RxList<String> symptoms = <String>[].obs;
  final RxString lastDiagnosis = ''.obs;

  static const _kKey = 'saved_symptoms';

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = prefs.getStringList(_kKey) ?? <String>[];
      symptoms.assignAll(list);
    } catch (e) {
      // ignorar erros de load para não quebrar a UI
      print('Erro ao carregar sintomas: $e');
    }
  }

  Future<void> add(String text) async {
    final t = text.trim();
    if (t.isEmpty) return;
    symptoms.add(t);
    lastDiagnosis.value = _generateDiagnosis(t);
    await _save();
  }

  Future<void> removeAt(int index) async {
    if (index < 0 || index >= symptoms.length) return;
    symptoms.removeAt(index);
    await _save();
  }

  /// Gera um diagnóstico (texto) a partir de uma descrição — público para uso pela UI
  String generateDiagnosis(String text) {
    return _generateDiagnosis(text);
  }

  Future<void> _save() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_kKey, symptoms.toList());
    } catch (e) {
      print('Erro ao salvar sintomas: $e');
    }
  }

  String _generateDiagnosis(String text) {
    final s = text.toLowerCase();
    // Regras simples iniciais — amplie conforme necessidade
    if (s.contains('febre')) {
      return 'Com base na sua descrição, parece que você está com febre. Observe temperatura e procure orientação médica se estiver alta.';
    }
    if (s.contains('tosse') ||
        s.contains('tosse seca') ||
        s.contains('tosse com')) {
      return 'A descrição sugere sintomas respiratórios (tosse). Pode ser um resfriado ou infecção — se houver febre ou falta de ar, procure atendimento.';
    }
    if (s.contains('dor de cabeça') ||
        s.contains('cefaleia') ||
        s.contains('dor cabeça')) {
      return 'Sintoma compatível com dor de cabeça. Verifique hidratação, descanso e sinais de alarme (vômito, confusão).';
    }
    if (s.contains('dor no peito') || s.contains('opressão no peito')) {
      return 'Dor no peito pode ser sinal sério — procure atendimento médico imediatamente.';
    }
    if (s.contains('náusea') || s.contains('enjoo') || s.contains('vômito')) {
      return 'Sintomas gastrointestinais (náusea/vômito). Mantenha hidratação; procure ajuda se persistir.';
    }
    // fallback genérico
    return 'Com base na sua descrição, pode ser um sintoma comum. Recomenda-se observar a evolução e buscar orientação profissional se houver piora.';
  }
}
