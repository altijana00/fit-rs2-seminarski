
import 'package:core/dto/responses/city_response_dto.dart';

import '../dto/requests/edit_city_dto.dart';
import '../models/city_model.dart';
import '../services/city_api_service.dart';


class CityRepository {
  final CityApiService api;

  CityRepository(this.api);

  Future<CityResponseDto> getCity(int id) async {
    final json = await api.getCityById(id);
    return CityResponseDto.fromJson(json);
  }

  Future<List<CityResponseDto>> getAllCities() async {
    final List<dynamic> jsonList = await api.getAllCities();
    return jsonList.map((json) => CityResponseDto.fromJson(json)).toList();
  }

  Future<List<CityResponseDto>> getCitiesQuery(String? search) async {
    final List<dynamic> jsonList = await api.getCitiesQuery(search);
    return jsonList.map((json) => CityResponseDto.fromJson(json)).toList();
  }

  Future<String> deleteCity(int? cityId) async {
    final json = await api.deleteCity(cityId!);
    return json.values.first;
  }

  Future<CityResponseDto> editCity(EditCityDto city, int? cityId) async {
    return await api.editCity(city, cityId!);

  }

}