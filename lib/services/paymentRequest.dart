class PaymentRequest {
  PaymentRequest({required this.amount, required this.intent});

  String toString() {
    return "PaymentRequest{amount='$amount', intent='$intent'}";
  }

  String intent;
  int amount;
}
