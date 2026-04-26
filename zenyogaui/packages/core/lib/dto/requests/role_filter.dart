class RoleFilter {
  String? search;


  RoleFilter({this.search});

  Map<String, dynamic> toQuery() {
    return {
      if (search != null && search!.isNotEmpty) 'search': search,

    };
  }
}