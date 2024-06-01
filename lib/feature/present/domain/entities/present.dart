class Present {
  BigInt? id;
  BigInt? day;
  BigInt? month;
  BigInt? year;
  String? variety;
  List<dynamic>? employeesId;

  Present({
    this.id,
    this.day,
    this.month,
    this.year,
    this.variety,
    this.employeesId,
  });

  factory Present.fromJson(List<dynamic> json) {
    return Present(
      id: json[0],
      day: json[1],
      month: json[2],
      year: json[3],
      variety: json[4],
      employeesId: json[5],
    );
  }
}
