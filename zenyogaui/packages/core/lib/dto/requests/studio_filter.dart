class StudioFilter {
  String? search;
  int? cityId;

 StudioFilter({this.search, this.cityId});

  Map<String, dynamic> toQuery() {
    return {
      if (search != null && search!.isNotEmpty) 'search': search,
      if (cityId != null) 'cityId': cityId,
    };
  }
}