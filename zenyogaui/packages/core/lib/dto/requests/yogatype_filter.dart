class YogaTypeFilter {
  String? search;


  YogaTypeFilter({this.search});

  Map<String, dynamic> toQuery() {
    return {
      if (search != null && search!.isNotEmpty) 'search': search,

    };
  }
}