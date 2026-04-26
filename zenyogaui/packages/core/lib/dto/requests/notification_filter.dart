class NotificationFilter {
  String? search;


  NotificationFilter({this.search});

  Map<String, dynamic> toQuery() {
    return {
      if (search != null && search!.isNotEmpty) 'search': search,

    };
  }
}