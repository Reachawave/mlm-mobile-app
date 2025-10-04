class WithdrawlBalanceItem {
  final int agentId;
  final String name;
  final String referalId;
  final String email;
  final double balanceAmount;
  final String bankName;
  final String accountNumber;
  final String ifscCode;
  final String accountHolderName;

  const WithdrawlBalanceItem({
    required this.agentId,
    required this.name,
    required this.referalId,
    required this.email,
    required this.balanceAmount,
    required this.bankName,
    required this.accountNumber,
    required this.ifscCode,
    required this.accountHolderName,
  });

  factory WithdrawlBalanceItem.fromJson(Map<String, dynamic> j) {
    return WithdrawlBalanceItem(
      agentId: (j['agentId'] ?? 0) as int,
      name: (j['name'] ?? '').toString(),
      referalId: (j['referalId'] ?? '').toString(),
      email: (j['email'] ?? '').toString(),
      balanceAmount: (j['balanceAmount'] ?? 0).toDouble(),
      bankName: (j['bankName'] ?? '').toString(),
      accountNumber: (j['accountNumber'] ?? '').toString(),
      ifscCode: (j['ifscCode'] ?? '').toString(),
      accountHolderName: (j['accountHolderName'] ?? '').toString(),
    );
  }
}
