import 'package:get/get.dart';

import '../../services/contacts/contacts_repository.dart';

class ContactsHubController extends GetxController {
  late final ContactsRepository repo;

  @override
  void onInit() {
    repo = Get.find<ContactsRepository>();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    repo.loadContacts();
  }
}
