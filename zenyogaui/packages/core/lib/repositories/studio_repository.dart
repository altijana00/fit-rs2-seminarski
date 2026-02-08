import 'dart:io';
import '../dto/requests/add_studio_dto.dart';
import '../dto/requests/edit_studio_dto.dart';
import '../dto/responses/studio_response_dto.dart';
import '../models/studio_model.dart';
import '../services/studio_api_service.dart';


class StudioRepository {
  final StudioApiService api;

  StudioRepository(this.api);

  Future<List<StudioResponseDto>> getStudioByOwner(int id) async {
    final List<dynamic> jsonList = await api.getStudioByOwner(id);
    return jsonList.map((json) => StudioResponseDto.fromJson(json)).toList();
  }

  Future<StudioResponseDto> getStudioByInstructor(int id) async {
    final json = await api.getStudioByInstructor(id);
    return StudioResponseDto.fromJson(json);
  }

  Future<double> getPayments(int studioId) async {
    final json = await api.getPayments(studioId);
    return json;
  }

  Future<int> getParticipants(int studioId) async {
    final json = await api.getParticipants(studioId);
    return json;
  }


  Future<StudioResponseDto> getStudioByOwnerAndStudioName(int id, String name) async {
    final json = await api.getStudioByOwnerAndStudioName(id, name);
    return StudioResponseDto.fromJson(json);
  }

  Future<List<StudioResponseDto>> getAllStudios() async {
    final List<dynamic> jsonList = await api.getAllStudios();
    return jsonList.map((json) => StudioResponseDto.fromJson(json)).toList();
  }

  Future<List<StudioResponseDto>> getStudiosQuery(String? search, int? cityId) async {
    final List<dynamic> jsonList = await api.getStudiosQuery(search,  cityId);
    return jsonList.map((json) => StudioResponseDto.fromJson(json)).toList();
  }

  Future<List<String>> getStudioGalleryPhotos(int studioId) async {
    final gallery = await api.getStudioGalleryPhotos(studioId);
   return gallery;
  }

  Future<String> editStudio(EditStudioDto studioModel, int? studioId) async {
    final json = await api.editStudio(studioModel.toJson(), studioId!);
    return json.values.first;
  }

  Future<String> deleteStudio(int? studioId) async {
    final json = await api.deleteStudio(studioId!);
    return json.values.first;
  }

  Future<String> addStudio(AddStudioDto studioModel) async {
    final json = await api.addStudio(studioModel.toJson());
    return json.values.first;
  }

  Future<String> uploadStudioPhoto(File imageFile) async {
    final  image = await api.uploadStudioPhoto(imageFile);
    return image;

  }

  Future<String> editStudioPhoto(String? photoURL, int? studioId) async {
    final json = await api.editStudioPhoto(photoURL!, studioId!);
    return json;
  }

  Future<String> uploadStudioGalleryPhoto(int? studioId, File imageFile) async {
    final json = await api.uploadStudioGalleryPhoto(studioId!, imageFile);
    return json;
  }

  Future<String> deleteStudioGalleryPhoto(String photoURL, int? studioId) async {
    final json = await api.deleteStudioGalleryPhoto(photoURL, studioId!);
    return json.values.first;
  }
}