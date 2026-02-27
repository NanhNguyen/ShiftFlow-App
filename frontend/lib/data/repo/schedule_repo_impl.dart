import 'package:injectable/injectable.dart';
import '../api/api_client.dart';
import '../model/schedule_request_model.dart';
import 'schedule_request_repo.dart';

@LazySingleton(as: ScheduleRequestRepo)
class ScheduleRepoImpl implements ScheduleRequestRepo {
  final ApiClient _apiClient;

  ScheduleRepoImpl(this._apiClient);

  @override
  Future<List<ScheduleRequestModel>> getMySchedules() async {
    final response = await _apiClient.get('/schedules/my');
    return (response.data as List)
        .map((e) => ScheduleRequestModel.fromJson(e))
        .toList();
  }

  @override
  Future<List<ScheduleRequestModel>> getAllSchedules() async {
    final response = await _apiClient.get('/schedules/all');
    return (response.data as List)
        .map((e) => ScheduleRequestModel.fromJson(e))
        .toList();
  }

  @override
  Future<List<ScheduleRequestModel>> getApprovedSchedules() async {
    final response = await _apiClient.get('/schedules/approved');
    return (response.data as List)
        .map((e) => ScheduleRequestModel.fromJson(e))
        .toList();
  }

  @override
  Future<void> createSchedule(dynamic data) async {
    await _apiClient.post('/schedules', data: data);
  }

  @override
  Future<void> updateStatus(String id, String status) async {
    await _apiClient.patch('/schedules/$id/status', data: {'status': status});
  }

  @override
  Future<void> updateBatchStatus(String groupId, String status) async {
    await _apiClient.patch(
      '/schedules/batch/status',
      data: {'groupId': groupId, 'status': status},
    );
  }

  @override
  Future<void> deleteSchedule(String id) async {
    await _apiClient.delete('/schedules/$id');
  }

  @override
  Future<void> deleteBatchSchedules(String groupId) async {
    await _apiClient.delete('/schedules/batch/$groupId');
  }
}
