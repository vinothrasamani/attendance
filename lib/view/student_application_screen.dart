import 'package:attendance/view_model/application_viewmodel.dart';
import 'package:attendance/widget/student_application/academic_details.dart';
import 'package:attendance/widget/student_application/personal_details.dart';
import 'package:attendance/widget/student_application/student_identities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

class StudentApplicationScreen extends ConsumerStatefulWidget {
  const StudentApplicationScreen({super.key, required this.isApp});
  final bool isApp;

  @override
  ConsumerState<StudentApplicationScreen> createState() =>
      _StudentApplicationScreenState();
}

class _StudentApplicationScreenState
    extends ConsumerState<StudentApplicationScreen> {
  final _formKey = GlobalKey<FormState>();
  String? query;

  @override
  void initState() {
    ApplicationViewmodel.fetchCredentials(ref);
    super.initState();
  }

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
    if (ref.read(ApplicationViewmodel.credentials) != null) {
      await ApplicationViewmodel.submitInfo(ref, widget.isApp);
    }
  }

  void searchSibiling() async {
    if (query != null) {
      ApplicationViewmodel.fetchApplication(ref, query!);
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
    final student = ref.watch(ApplicationViewmodel.student);
    final credentials = ref.watch(ApplicationViewmodel.credentials);

    return Scaffold(
      appBar: AppBar(
          title: Text(widget.isApp ? 'Student Application' : 'Student Master')),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
          child: OutlinedButton(
            onPressed: isLoading
                ? null
                : student != null
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
                      Text(student != null ? 'Saving..' : 'searching..'),
                    ],
                  )
                : Text(
                    student != null
                        ? 'Save Application'
                        : widget.isApp
                            ? 'Search Sibilings'
                            : 'Search Application',
                  ),
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: student != null
                ? Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (widget.isApp)
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
                                    'Sibiling Information',
                                    Icons.verified_user),
                                const SizedBox(height: 10),
                                info(
                                    '🤵 Name : ',
                                    student.firstName == null &&
                                            student.lastName == null
                                        ? 'No Name available!'
                                        : '${student.firstName} ${student.lastName ?? ''}'),
                                SizedBox(height: 10),
                                info('✨ Application No : ',
                                    student.applicationNo),
                              ],
                            ),
                          ),
                        if (widget.isApp) Divider(),
                        const SizedBox(height: 10),
                        PersonalDetails(
                            isApp: widget.isApp,
                            genders:
                                credentials != null ? credentials.gender : []),
                        const SizedBox(height: 10),
                        AcademicDetails(
                            isApp: widget.isApp, cInfo: credentials),
                        const SizedBox(height: 10),
                        StudentIdentities(
                          isApp: widget.isApp,
                          pcd: credentials != null ? credentials.phys : [],
                          bldGrp: credentials != null ? credentials.blood : [],
                        ),
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
                          '✨ Search ${widget.isApp ? 'sibilings' : 'application'} by application number!',
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
