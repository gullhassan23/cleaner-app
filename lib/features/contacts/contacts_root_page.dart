import 'package:cleaner_app/features/contacts/contacts_backup_page.dart';
import 'package:cleaner_app/features/contacts/contacts_duplicates_page.dart';
import 'package:cleaner_app/features/contacts/contacts_hub_page.dart';
import 'package:cleaner_app/features/contacts/contacts_incomplete_page.dart';
import 'package:cleaner_app/features/contacts/contacts_list_page.dart';
import 'package:cleaner_app/features/contacts/contacts_nav_routes.dart';
import 'package:flutter/material.dart';

/// Nested stack for Contacts so inner [Back] does not leave the bottom tab.
class ContactsRootPage extends StatelessWidget {
  const ContactsRootPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      initialRoute: ContactsNavRoutes.hub,
      onGenerateRoute: (RouteSettings settings) {
        Widget child;
        switch (settings.name) {
          case ContactsNavRoutes.hub:
            child = const ContactsHubPage();
            break;
          case ContactsNavRoutes.list:
            child = const ContactsListPage();
            break;
          case ContactsNavRoutes.backup:
            child = const ContactsBackupPage();
            break;
          case ContactsNavRoutes.duplicates:
            child = const ContactsDuplicatesPage();
            break;
          case ContactsNavRoutes.incomplete:
            child = const ContactsIncompletePage();
            break;
          default:
            child = const ContactsHubPage();
        }
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => child,
        );
      },
    );
  }
}
