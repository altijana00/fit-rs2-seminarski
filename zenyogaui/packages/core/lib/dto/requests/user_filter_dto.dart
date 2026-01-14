class UserFilter {
  String? search;
  int? roleId;
  int? cityId;

  UserFilter({this.search, this.roleId, this.cityId});

  Map<String, dynamic> toQuery() {
    return {
      if (search != null && search!.isNotEmpty) 'search': search,
      if (roleId != null) 'roleId': roleId,
      if (cityId != null) 'cityId': cityId,
    };
  }
}