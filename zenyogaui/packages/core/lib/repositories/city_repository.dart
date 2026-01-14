
import 'package:core/dto/responses/city_response_dto.dart';

import '../models/city_model.dart';
import '../services/city_api_service.dart';


class CityRepository {
  final CityApiService api;

  CityRepository(this.api);

  Future<CityModel> getCity(int id) async {
    final json = await api.getCityById(id);
    return CityModel.fromJson(json);
  }

  Future<List<CityModel>> getAllCities() async {
    final List<dynamic> jsonList = await api.getAllCities();
    return jsonList.map((json) => CityModel.fromJson(json)).toList();
  }

}