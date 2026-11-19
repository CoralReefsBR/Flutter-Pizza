import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pedido_pizzaria.dart';

class PedidoApiService {
  PedidoApiService({http.Client? client}) : _client = client ?? http.Client();
  final http.Client _client;
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://flutter-pizza-api.onrender.com',
  );

  Uri get _pedidosUri => Uri.parse('$baseUrl/pedidos');

  Future<List<PedidoPizzaria>> listar() async {
    final response = await _client.get(_pedidosUri).timeout(const Duration(seconds: 8));
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Falha ao buscar pedidos (${response.statusCode})');
    }
    final decoded = jsonDecode(response.body);
    final List<dynamic> items = decoded is List ? decoded : decoded['pedidos'] as List<dynamic>;
    return items.map((item) => PedidoPizzaria.fromApiJson(item as Map<String, dynamic>)).toList();
  }

  Future<void> criar(PedidoPizzaria pedido) async {
    final response = await _client
        .post(_pedidosUri,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(pedido.toApiJson()))
        .timeout(const Duration(seconds: 8));
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Falha ao enviar pedido (${response.statusCode})');
    }
  }
}
