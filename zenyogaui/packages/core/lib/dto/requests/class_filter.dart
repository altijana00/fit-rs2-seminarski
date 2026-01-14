class ClassFilter {
  String? search;
  int? yogaTypeId;

  ClassFilter({this.search, this.yogaTypeId});

  Map<String, dynamic> toQuery() {
    return {
      if (search != null && search!.isNotEmpty) 'search': search,
      if (yogaTypeId != null) 'yogaTypeId': yogaTypeId,
    };
  }
}