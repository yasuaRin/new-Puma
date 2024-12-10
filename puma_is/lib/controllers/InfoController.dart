import 'package:puma_is/services/info_services.dart';

class InfoController {
  final InfoServices _infoServices = InfoServices();

  // Add new info
  Future<void> addInfo({
    required String title,
    required String content,
    required DateTime dateTime,
    required String contactPerson,
  }) {
    return _infoServices.addInfo(
      title: title,
      content: content,
      dateTime: dateTime,
      contactPerson: contactPerson,
    );
  }

  // Update existing info
  Future<void> updateInfo({
    required String infoId,
    required String title,
    required String content,
    required DateTime dateTime,
    required String contactPerson,
  }) {
    return _infoServices.updateInfo(
      infoId: infoId,
      title: title,
      content: content,
      dateTime: dateTime,
      contactPerson: contactPerson,
    );
  }

  // Delete info
  Future<void> deleteInfo(String infoId) {
    return _infoServices.deleteInfo(infoId);
  }

  // Fetch all info
  Future<List<Map<String, dynamic>>> fetchAllInfo() {
    return _infoServices.getAllInfo();
  }

  // Fetch info for a specific date
  Future<List<Map<String, dynamic>>> fetchInfoForDate(DateTime selectedDate) {
    return _infoServices.getInfoForDate(selectedDate);
  }
}
