import '../../core/paging_defaults.dart';

class PagedRequest {
  final int page;
  final int pageSize;

  PagedRequest({
    this.page = PagingDefaults.firstPage,
    this.pageSize = PagingDefaults.pageSize,
  });

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'pageSize': pageSize,
    };
  }
}