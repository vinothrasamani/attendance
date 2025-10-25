import 'package:attendance/view_model/application_viewmodel.dart';
import 'package:attendance/widget/student_application/academic_details.dart';
import 'package:attendance/widget/student_application/personal_details.dart';
import 'package:attendance/widget/student_application/student_identities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

class StudentApplicationScreen extends ConsumerStatefulWidget {
  const StudentApplicationScreen({super.key});

  @override
  ConsumerState<StudentApplicationScreen> createState() =>
      _StudentApplicationScreenState();
}

class _StudentApplicationScreenState
    extends ConsumerState<StudentApplicationScreen> {
  final _formKey = GlobalKey<FormState>();
  String? query;

  void submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      Get.snackbar(
        'Required!',
        'Please fill all the required fields to continue!',
        borderRadius: 5,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }
    await ApplicationViewmodel.submitInfo(ref);
  }

  void searchSibiling() async {
    if (query != null) {
      ApplicationViewmodel.fetchsibilings(ref, query!);
    }
  }

  Widget info(String title, String value) {
    return Text.rich(
      TextSpan(
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        text: title,
        children: [
          TextSpan(
            text: value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.normal,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(ApplicationViewmodel.isLoading);
    final sibiling = ref.watch(ApplicationViewmodel.sibiling);

    return Scaffold(
      appBar: AppBar(title: const Text('Student Application')),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
          child: OutlinedButton(
            onPressed: isLoading
                ? null
                : sibiling != null
                    ? submit
                    : searchSibiling,
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            child: isLoading
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 14,
                        width: 14,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      SizedBox(width: 8),
                      Text(sibiling != null ? 'Saving..' : 'searching..'),
                    ],
                  )
                : Text(
                    sibiling != null ? 'Save Application' : 'Search Sibilings'),
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: sibiling != null
                ? Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.grey.withAlpha(40),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ApplicationViewmodel().title(
                                  'Sibiling Information', Icons.verified_user),
                              const SizedBox(height: 10),
                              info(
                                  '🤵 Name : ',
                                  sibiling.firstName == null &&
                                          sibiling.lastName == null
                                      ? 'No Name available!'
                                      : '${sibiling.firstName} ${sibiling.lastName ?? ''}'),
                              SizedBox(height: 10),
                              info('✨ Application No : ',
                                  sibiling.applicationNo),
                            ],
                          ),
                        ),
                        Divider(),
                        const SizedBox(height: 10),
                        const PersonalDetails(),
                        const SizedBox(height: 10),
                        const AcademicDetails(),
                        const SizedBox(height: 10),
                        const StudentIdentities(),
                      ],
                    ),
                  )
                : Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.grey.withAlpha(40),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ApplicationViewmodel().title('Search', Icons.person),
                        SizedBox(height: 10),
                        TextField(
                          onChanged: (value) => query = value,
                          decoration: ApplicationViewmodel()
                              .decoration('Application No'),
                          onTapOutside: (event) =>
                              FocusScope.of(context).unfocus(),
                        ),
                        SizedBox(height: 10),
                        Text(
                          '✨ Search sibilings by application number!',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
