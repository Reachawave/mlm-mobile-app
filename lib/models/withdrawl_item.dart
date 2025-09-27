class WithdrawlItem {
  final int id;
  final int agentId;
  final String name;
  final String referalId;
  final String email;
  final double amount;
  final String status;
  final String raisedDateStr;

  const WithdrawlItem({
    required this.id,
    required this.agentId,
    required this.name,
    required this.referalId,
    required this.email,
    required this.amount,
    required this.status,
    required this.raisedDateStr,
  });

  DateTime? get raisedDate => DateTime.tryParse(raisedDateStr);
}
