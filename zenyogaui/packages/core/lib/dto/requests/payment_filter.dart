class PaymentFilter {
  String? search;


  PaymentFilter({this.search});

  Map<String, dynamic> toQuery() {
    return {
      if (search != null && search!.isNotEmpty) 'search': search,

    };
  }
}