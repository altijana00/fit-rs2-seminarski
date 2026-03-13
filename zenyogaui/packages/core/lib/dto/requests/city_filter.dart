class CityFilter {
  String? search;


  CityFilter({this.search});

  Map<String, dynamic> toQuery() {
    return {
      if (search != null && search!.isNotEmpty) 'search': search,

    };
  }
}