import '../model/schedule_request_model.dart';

abstract class ScheduleRequestRepo {
  Future<List<ScheduleRequestModel>> getMySchedules();
  Future<List<ScheduleRequestModel>> getAllSchedules();
  Future<List<ScheduleRequestModel>> getApprovedSchedules();
  Future<void> createSchedule(dynamic data);
  Future<void> updateStatus(String id, String status);
  Future<void> updateBatchStatus(String groupId, String status);
  Future<void> deleteSchedule(String id);
  Future<void> deleteBatchSchedules(String groupId);
}
