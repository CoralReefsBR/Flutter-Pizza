class PedidoPizzaria {
  final int? id;
  final int? remoteId;
  final double valor;
  final int numeroMesa;
  final bool sincronizado;

  const PedidoPizzaria({
    this.id,
    this.remoteId,
    required this.valor,
    required this.numeroMesa,
    this.sincronizado = false,
  });

  PedidoPizzaria copyWith({int? id, int? remoteId, bool? sincronizado}) => PedidoPizzaria(
        id: id ?? this.id,
        remoteId: remoteId ?? this.remoteId,
        valor: valor,
        numeroMesa: numeroMesa,
        sincronizado: sincronizado ?? this.sincronizado,
      );

  Map<String, Object?> toMap() => {
        'id': id,
        'remote_id': remoteId,
        'valor': valor,
        'numero_mesa': numeroMesa,
        'sincronizado': sincronizado ? 1 : 0,
      };

  factory PedidoPizzaria.fromMap(Map<String, Object?> map) => PedidoPizzaria(
        id: map['id'] as int?,
        remoteId: map['remote_id'] as int?,
        valor: (map['valor'] as num).toDouble(),
        numeroMesa: map['numero_mesa'] as int,
        sincronizado: (map['sincronizado'] as int? ?? 0) == 1,
      );

  Map<String, Object?> toApiJson() => {
        'valor': valor,
        'numero_mesa': numeroMesa,
      };

  factory PedidoPizzaria.fromApiJson(Map<String, dynamic> json) => PedidoPizzaria(
        remoteId: int.tryParse('${json['id']}'),
        // PostgreSQL NUMERIC and BIGINT values are commonly serialized as strings.
        valor: double.parse('${json['valor']}'),
        numeroMesa: int.parse('${json['numero_mesa'] ?? json['numeroMesa']}'),
        sincronizado: true,
      );
}
