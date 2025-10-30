import 'package:attendance/model/credentials_model.dart';
import 'package:attendance/view_model/application_viewmodel.dart';
import 'package:attendance/view_model/home_service.dart';
import 'package:attendance/widget/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AcademicDetails extends ConsumerWidget {
  const AcademicDetails({super.key, required this.isApp, required this.cInfo});
  final bool isApp;
  final Credentials? cInfo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ApplicationViewmodel();
    final years = ref.watch(HomeService.years);
    final branches = ref.watch(HomeService.branches);
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
              if (isApp) ...[
                SizedBox(height: 15),
                Text('➡ Application No'),
                TextFormField(
                  initialValue: ref.watch(ApplicationViewmodel.appNo),
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
                items: cInfo == null || cInfo!.dataClass.isEmpty
                    ? []
                    : cInfo!.dataClass
                        .map((item) => DropdownMenuItem<String>(
                            value: item.oid, child: Text(item.description)))
                        .toList(),
                borderRadius: BorderRadius.circular(10),
                value: ref.watch(ApplicationViewmodel.classIs),
                onChanged: (value) => ref
                    .read(ApplicationViewmodel.classIs.notifier)
                    .state = value,
              ),
              if (isApp) ...[
                SizedBox(height: 15),
                Text('➡ Preffered Group'),
                DropdownButtonFormField<String>(
                  decoration: vm.decoration('Group'),
                  validator: vm.validate,
                  items: cInfo == null || cInfo!.pGroup.isEmpty
                      ? []
                      : cInfo!.pGroup
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
                  initialValue: ref.watch(ApplicationViewmodel.lastSchool),
                  decoration: vm.decoration('Preivous School'),
                  onChanged: (value) => ref
                      .read(ApplicationViewmodel.lastSchool.notifier)
                      .state = value,
                ),
              ],
              if (!isApp) ...[
                SizedBox(height: 15),
                Text('➡ Section Joined'),
                DropdownButtonFormField<String>(
                  decoration: vm.decoration('Section'),
                  validator: vm.validate,
                  items: cInfo == null || cInfo!.sections.isEmpty
                      ? []
                      : cInfo!.sections
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
        if (!isApp)
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
                  initialValue: ref.watch(ApplicationViewmodel.adminNo),
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
                  initialValue: ref.watch(ApplicationViewmodel.penNo),
                  decoration: vm.decoration('PEN No'),
                  onChanged: (value) => ref
                      .read(ApplicationViewmodel.penNo.notifier)
                      .state = value,
                ),
                SizedBox(height: 15),
                Text('➡ Apaar Id'),
                TextFormField(
                  initialValue: ref.watch(ApplicationViewmodel.apaarId),
                  decoration: vm.decoration('Apaar Id'),
                  onChanged: (value) => ref
                      .read(ApplicationViewmodel.apaarId.notifier)
                      .state = value,
                ),
                SizedBox(height: 15),
                Text('➡ EMIS No'),
                TextFormField(
                  initialValue: ref.watch(ApplicationViewmodel.emis),
                  keyboardType: TextInputType.number,
                  decoration: vm.decoration('EMIS'),
                  onChanged: (value) => ref
                      .read(ApplicationViewmodel.emis.notifier)
                      .state = value,
                ),
                SizedBox(height: 15),
                Text('➡ New EMIS No'),
                TextFormField(
                  initialValue: ref.watch(ApplicationViewmodel.newEmis),
                  decoration: vm.decoration('New EMIS'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => ref
                      .read(ApplicationViewmodel.newEmis.notifier)
                      .state = value,
                ),
                SizedBox(height: 15),
                Text('➡ TC Number'),
                TextFormField(
                  initialValue: ref.watch(ApplicationViewmodel.tcNo),
                  decoration: vm.decoration('TC No'),
                  onChanged: (value) => ref
                      .read(ApplicationViewmodel.tcNo.notifier)
                      .state = value,
                ),
                SizedBox(height: 15),
                Text('➡ staff Name'),
                TextFormField(
                  initialValue: ref.watch(ApplicationViewmodel.staffName),
                  decoration: vm.decoration('Statff Name'),
                  onChanged: (value) => ref
                      .read(ApplicationViewmodel.staffName.notifier)
                      .state = value,
                ),
              ],
            ),
          ),
        SizedBox(height: 10),
        if (!isApp)
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
                DropdownButtonFormField<String>(
                  decoration: vm.decoration('Choose..'),
                  items: ['Father', 'Mother']
                      .map((item) => DropdownMenuItem<String>(
                          value: item, child: Text(item)))
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
