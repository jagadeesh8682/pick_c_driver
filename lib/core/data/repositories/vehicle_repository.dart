import '../../network/network_service.dart';
import '../../constants/app_url.dart';

class VehicleRepository {
  final NetworkService _networkService;

  VehicleRepository({required NetworkService networkService})
    : _networkService = networkService;

  /// Get vehicle group list
  Future<List<Map<String, dynamic>>> getVehicleGroupList() async {
    try {
      final url = AppUrl.baseUrl + 'master/vehiclegroup/list';
      final response = await _networkService.getGetApiResponse(url);

      if (response is List) {
        return response.map((item) => Map<String, dynamic>.from(item)).toList();
      } else {
        return [];
      }
    } catch (e) {
      throw Exception('Failed to get vehicle group list: ${e.toString()}');
    }
  }

  /// Get vehicle type list
  Future<List<Map<String, dynamic>>> getVehicleTypeList() async {
    try {
      final url = AppUrl.baseUrl + 'master/vehicletype/list';
      final response = await _networkService.getGetApiResponse(url);

      if (response is List) {
        return response.map((item) => Map<String, dynamic>.from(item)).toList();
      } else {
        return [];
      }
    } catch (e) {
      throw Exception('Failed to get vehicle type list: ${e.toString()}');
    }
  }

  /// Get rate card list
  Future<List<Map<String, dynamic>>> getRateCardList() async {
    try {
      final url = AppUrl.baseUrl + 'master/ratecard/list';
      final response = await _networkService.getGetApiResponse(url);

      if (response is List) {
        return response.map((item) => Map<String, dynamic>.from(item)).toList();
      } else {
        return [];
      }
    } catch (e) {
      throw Exception('Failed to get rate card list: ${e.toString()}');
    }
  }

  /// Get cargo type list
  Future<List<Map<String, dynamic>>> getCargoTypeList() async {
    try {
      final url = AppUrl.baseUrl + 'master/cargotype/list';
      final response = await _networkService.getGetApiResponse(url);

      if (response is List) {
        return response.map((item) => Map<String, dynamic>.from(item)).toList();
      } else {
        return [];
      }
    } catch (e) {
      throw Exception('Failed to get cargo type list: ${e.toString()}');
    }
  }
}

