import 'package:attendance/model/credentials_model.dart';
import 'package:attendance/view_model/application_viewmodel.dart';
import 'package:attendance/view_model/home_service.dart';
import 'package:attendance/widget/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AcademicDetails extends ConsumerStatefulWidget {
  const AcademicDetails({super.key, required this.isApp, required this.cInfo});
  final bool isApp;
  final Credentials? cInfo;

  @override
  ConsumerState<AcademicDetails> createState() => _AcademicDetailsState();
}

class _AcademicDetailsState extends ConsumerState<AcademicDetails> {
  // Text editing controllers
  late TextEditingController appNoController;
  late TextEditingController lastSchoolController;
  late TextEditingController adminNoController;
  late TextEditingController penNoController;
  late TextEditingController apaarIdController;
  late TextEditingController emisController;
  late TextEditingController newEmisController;
  late TextEditingController tcNoController;

  @override
  void initState() {
    super.initState();
    // Initialize controllers
    appNoController = TextEditingController();
    lastSchoolController = TextEditingController();
    adminNoController = TextEditingController();
    penNoController = TextEditingController();
    apaarIdController = TextEditingController();
    emisController = TextEditingController();
    newEmisController = TextEditingController();
    tcNoController = TextEditingController();
  }

  @override
  void dispose() {
    // Dispose controllers
    appNoController.dispose();
    lastSchoolController.dispose();
    adminNoController.dispose();
    penNoController.dispose();
    apaarIdController.dispose();
    emisController.dispose();
    newEmisController.dispose();
    tcNoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = ApplicationViewmodel();
    final years = ref.watch(HomeService.years);
    final branches = ref.watch(HomeService.branches);
    final work = ['Father', 'Mother'];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      appNoController.text = ref.watch(ApplicationViewmodel.appNo) ?? '';
      lastSchoolController.text =
          ref.watch(ApplicationViewmodel.lastSchool) ?? '';
      adminNoController.text = ref.watch(ApplicationViewmodel.adminNo) ?? '';
      penNoController.text = ref.watch(ApplicationViewmodel.penNo) ?? '';
      apaarIdController.text = ref.watch(ApplicationViewmodel.apaarId) ?? '';
      emisController.text = ref.watch(ApplicationViewmodel.emis) ?? '';
      newEmisController.text = ref.watch(ApplicationViewmodel.newEmis) ?? '';
      tcNoController.text = ref.watch(ApplicationViewmodel.tcNo) ?? '';
    });
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.grey.withAlpha(40),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              vm.title('Academic Details', Icons.school),
              if (widget.isApp) ...[
                SizedBox(height: 15),
                Text('➡ Application No'),
                TextFormField(
                  controller: appNoController,
                  validator: vm.validate,
                  keyboardType: TextInputType.number,
                  decoration: vm.decoration('Application No'),
                  onChanged: (value) => ref
                      .read(ApplicationViewmodel.appNo.notifier)
                      .state = value,
                ),
              ],
              SizedBox(height: 15),
              Text('➡ Academic Year Joined'),
              DropdownButtonFormField<String>(
                decoration: vm.decoration('Academic Year'),
                validator: vm.validate,
                items: years
                    .map((item) => DropdownMenuItem<String>(
                        value: item, child: Text(item)))
                    .toList(),
                borderRadius: BorderRadius.circular(10),
                value: ref.watch(ApplicationViewmodel.academicYear),
                onChanged: (value) => ref
                    .read(ApplicationViewmodel.academicYear.notifier)
                    .state = value,
              ),
              SizedBox(height: 15),
              Text('➡ Branch'),
              DropdownButtonFormField<String>(
                decoration: vm.decoration('Branch'),
                validator: vm.validate,
                items: branches
                    .map((item) => DropdownMenuItem<String>(
                        value: item, child: Text(item)))
                    .toList(),
                borderRadius: BorderRadius.circular(10),
                value: ref.watch(ApplicationViewmodel.branch),
                onChanged: (value) => ref
                    .read(ApplicationViewmodel.branch.notifier)
                    .state = value,
              ),
              SizedBox(height: 15),
              Text('➡ Class Joined'),
              DropdownButtonFormField<String>(
                decoration: vm.decoration('Class'),
                validator: vm.validate,
                items: widget.cInfo == null || widget.cInfo!.dataClass.isEmpty
                    ? []
                    : widget.cInfo!.dataClass
                        .map((item) => DropdownMenuItem<String>(
                            value: item.oid, child: Text(item.description)))
                        .toList(),
                borderRadius: BorderRadius.circular(10),
                value: ref.watch(ApplicationViewmodel.classIs),
                onChanged: (value) => ref
                    .read(ApplicationViewmodel.classIs.notifier)
                    .state = value,
              ),
              if (widget.isApp) ...[
                SizedBox(height: 15),
                Text('➡ Preffered Group'),
                DropdownButtonFormField<String>(
                  decoration: vm.decoration('Group'),
                  validator: vm.validate,
                  items: widget.cInfo == null || widget.cInfo!.pGroup.isEmpty
                      ? []
                      : widget.cInfo!.pGroup
                          .map((item) => DropdownMenuItem<String>(
                              value: item.oid, child: Text(item.description)))
                          .toList(),
                  borderRadius: BorderRadius.circular(10),
                  value: ref.watch(ApplicationViewmodel.prefGrp),
                  onChanged: (value) => ref
                      .read(ApplicationViewmodel.prefGrp.notifier)
                      .state = value,
                ),
                SizedBox(height: 15),
                Text('➡ Previous school'),
                TextFormField(
                  controller: lastSchoolController,
                  decoration: vm.decoration('Preivous School'),
                  onChanged: (value) => ref
                      .read(ApplicationViewmodel.lastSchool.notifier)
                      .state = value,
                ),
              ],
              if (!widget.isApp) ...[
                SizedBox(height: 15),
                Text('➡ Section Joined'),
                DropdownButtonFormField<String>(
                  decoration: vm.decoration('Section'),
                  validator: vm.validate,
                  items: widget.cInfo == null || widget.cInfo!.sections.isEmpty
                      ? []
                      : widget.cInfo!.sections
                          .map((item) => DropdownMenuItem<String>(
                              value: item.oid, child: Text(item.description)))
                          .toList(),
                  borderRadius: BorderRadius.circular(10),
                  value: ref.watch(ApplicationViewmodel.sectionIs),
                  onChanged: (value) => ref
                      .read(ApplicationViewmodel.sectionIs.notifier)
                      .state = value,
                ),
              ],
            ],
          ),
        ),
        SizedBox(height: 10),
        if (!widget.isApp)
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.grey.withAlpha(40),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                vm.title('Academic Master', Icons.details_rounded),
                SizedBox(height: 15),
                Text('➡ Admission No'),
                TextFormField(
                  controller: adminNoController,
                  validator: vm.validate,
                  keyboardType: TextInputType.number,
                  decoration: vm.decoration('Admin No'),
                  onChanged: (value) => ref
                      .read(ApplicationViewmodel.adminNo.notifier)
                      .state = value,
                ),
                SizedBox(height: 15),
                Text('➡ Admission Date'),
                DateField(
                  value: ref
                      .watch(ApplicationViewmodel.adminDate)
                      .toIso8601String()
                      .split('T')
                      .first,
                  onTap: () async {
                    final date = await vm.pickADate(
                        context, ref.watch(ApplicationViewmodel.adminDate));
                    if (date != null) {
                      ref.read(ApplicationViewmodel.adminDate.notifier).state =
                          date;
                    }
                  },
                ),
                SizedBox(height: 15),
                Text('➡ PEN No'),
                TextFormField(
                  controller: penNoController,
                  decoration: vm.decoration('PEN No'),
                  onChanged: (value) => ref
                      .read(ApplicationViewmodel.penNo.notifier)
                      .state = value,
                ),
                SizedBox(height: 15),
                Text('➡ Apaar Id'),
                TextFormField(
                  controller: apaarIdController,
                  decoration: vm.decoration('Apaar Id'),
                  onChanged: (value) => ref
                      .read(ApplicationViewmodel.apaarId.notifier)
                      .state = value,
                ),
                SizedBox(height: 15),
                Text('➡ EMIS No'),
                TextFormField(
                  controller: emisController,
                  keyboardType: TextInputType.number,
                  decoration: vm.decoration('EMIS'),
                  onChanged: (value) => ref
                      .read(ApplicationViewmodel.emis.notifier)
                      .state = value,
                ),
                SizedBox(height: 15),
                Text('➡ New EMIS No'),
                TextFormField(
                  controller: newEmisController,
                  decoration: vm.decoration('New EMIS'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => ref
                      .read(ApplicationViewmodel.newEmis.notifier)
                      .state = value,
                ),
                SizedBox(height: 15),
                Text('➡ TC Number'),
                TextFormField(
                  controller: tcNoController,
                  decoration: vm.decoration('TC No'),
                  onChanged: (value) => ref
                      .read(ApplicationViewmodel.tcNo.notifier)
                      .state = value,
                ),
              ],
            ),
          ),
        SizedBox(height: 10),
        if (!widget.isApp)
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.grey.withAlpha(40),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                vm.title('Additional Info', Icons.info_outline),
                SizedBox(height: 15),
                Text('➡ Optional Subject'),
                DropdownButtonFormField<String>(
                  decoration: vm.decoration('Choose..'),
                  items: []
                      .map((item) => DropdownMenuItem<String>(
                          value: item, child: Text(item)))
                      .toList(),
                  borderRadius: BorderRadius.circular(10),
                  value: ref.watch(ApplicationViewmodel.oplSub),
                  onChanged: (value) => ref
                      .read(ApplicationViewmodel.oplSub.notifier)
                      .state = value,
                ),
                SizedBox(height: 15),
                Text('➡ School Id'),
                DropdownButtonFormField<String>(
                  decoration: vm.decoration('Choose..'),
                  items: []
                      .map((item) => DropdownMenuItem<String>(
                          value: item, child: Text(item)))
                      .toList(),
                  borderRadius: BorderRadius.circular(10),
                  value: ref.watch(ApplicationViewmodel.schlId),
                  onChanged: (value) => ref
                      .read(ApplicationViewmodel.schlId.notifier)
                      .state = value,
                ),
                SizedBox(height: 15),
                Text('➡ Current Academic Year'),
                DropdownButtonFormField<String>(
                  decoration: vm.decoration('Choose..'),
                  items: []
                      .map((item) => DropdownMenuItem<String>(
                          value: item, child: Text(item)))
                      .toList(),
                  borderRadius: BorderRadius.circular(10),
                  value: ref.watch(ApplicationViewmodel.currAcaYear),
                  onChanged: (value) => ref
                      .read(ApplicationViewmodel.currAcaYear.notifier)
                      .state = value,
                ),
                SizedBox(height: 15),
                Text('➡ Section Group'),
                DropdownButtonFormField<String>(
                  decoration: vm.decoration('Choose..'),
                  items: []
                      .map((item) => DropdownMenuItem<String>(
                          value: item, child: Text(item)))
                      .toList(),
                  borderRadius: BorderRadius.circular(10),
                  value: ref.watch(ApplicationViewmodel.secGrp),
                  onChanged: (value) => ref
                      .read(ApplicationViewmodel.secGrp.notifier)
                      .state = value,
                ),
                SizedBox(height: 15),
                Text('➡ Status'),
                DropdownButtonFormField<String>(
                  decoration: vm.decoration('Choose..'),
                  items: []
                      .map((item) => DropdownMenuItem<String>(
                          value: item, child: Text(item)))
                      .toList(),
                  borderRadius: BorderRadius.circular(10),
                  value: ref.watch(ApplicationViewmodel.status),
                  onChanged: (value) => ref
                      .read(ApplicationViewmodel.status.notifier)
                      .state = value,
                ),
                SizedBox(height: 15),
                Text('➡ Who is working'),
                DropdownButtonFormField<int>(
                  decoration: vm.decoration('Choose..'),
                  items: work
                      .map((item) => DropdownMenuItem<int>(
                          value: work.indexOf(item) + 1, child: Text(item)))
                      .toList(),
                  borderRadius: BorderRadius.circular(10),
                  value: ref.watch(ApplicationViewmodel.whoWork),
                  onChanged: (value) => ref
                      .read(ApplicationViewmodel.whoWork.notifier)
                      .state = value,
                ),
                SizedBox(height: 15),
                CheckboxListTile(
                    title: Text('Birth Certificate'),
                    value: ref.watch(ApplicationViewmodel.birthCert),
                    onChanged: (val) => val != null
                        ? ref
                            .read(ApplicationViewmodel.birthCert.notifier)
                            .state = val
                        : null),
                SizedBox(height: 15),
                CheckboxListTile(
                    title: Text('Transfer Certificate'),
                    value: ref.watch(ApplicationViewmodel.transCert),
                    onChanged: (val) => val != null
                        ? ref
                            .read(ApplicationViewmodel.transCert.notifier)
                            .state = val
                        : null),
              ],
            ),
          ),
      ],
    );
  }
}
