import 'transaction_shopify.dart';

class PaymentShopify {
  final String id;
  final String amount;
  final TransactionShopify? transaction;
  final String? errorMessage;
  final bool ready;

  PaymentShopify({
    required this.id,
    required this.amount,
    this.transaction,
    this.errorMessage,
    required this.ready,
  });

  factory PaymentShopify.fromJson(Map<String, dynamic> json) {
    return PaymentShopify(
      id: json['id'],
      amount: json['amount']['amount'],
      ready: json['ready'],
      transaction: json['transaction'] != null
          ? TransactionShopify.fromJson(json['transaction'])
          : null,
      errorMessage: json['errorMessage'],
    );
  }
}
