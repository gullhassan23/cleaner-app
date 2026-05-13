import 'package:cleaner_app/controllers/contacts_hub_controller.dart';
import 'package:cleaner_app/controllers/contacts_list_controller.dart';
import 'package:cleaner_app/services/contacts/contacts_repository.dart';
import 'package:get/get.dart';

class ContactsBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ContactsRepository>()) {
      Get.put(ContactsRepository(), permanent: true);
    }
    if (!Get.isRegistered<ContactsHubController>()) {
      Get.lazyPut(ContactsHubController.new, fenix: true);
    }
    if (!Get.isRegistered<ContactsListController>()) {
      Get.lazyPut(ContactsListController.new, fenix: true);
    }
  }
}
