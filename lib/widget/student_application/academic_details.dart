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
              SizedBox(height: 15),
              Text('➡ Application No'),
              TextFormField(
                initialValue: ref.watch(ApplicationViewmodel.appNo),
                validator: vm.validate,
                keyboardType: TextInputType.number,
                decoration: vm.decoration('Application No'),
                onChanged: (value) =>
                    ref.read(ApplicationViewmodel.appNo.notifier).state = value,
              ),
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
                              value: item.oid,
                              child: Text(item.description),
                            ))
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
                                value: item.oid,
                                child: Text(item.description),
                              ))
                          .toList(),
                  borderRadius: BorderRadius.circular(10),
                  value: ref.watch(ApplicationViewmodel.prefGrp),
                  onChanged: (value) => ref
                      .read(ApplicationViewmodel.prefGrp.notifier)
                      .state = value,
                ),
                SizedBox(height: 15),
                Text('➡ Previous school studied'),
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
                TextFormField(
                  initialValue: ref.watch(ApplicationViewmodel.sectionIs),
                  validator: vm.validate,
                  decoration: vm.decoration('Section'),
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
                Text('➡ EMIS No'),
                TextFormField(
                  initialValue: ref.watch(ApplicationViewmodel.emis),
                  validator: vm.validate,
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
      ],
    );
  }
}
