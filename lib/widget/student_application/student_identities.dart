import 'package:attendance/view_model/application_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StudentIdentities extends ConsumerWidget {
  const StudentIdentities({super.key, required this.isApp});
  final bool isApp;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ApplicationViewmodel();
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.grey.withAlpha(40),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          vm.title(isApp ? 'Physically Challenged' : 'Student Identities',
              Icons.badge),
          if (!isApp) ...[
            SizedBox(height: 15),
            Text('➡ Blood Group'),
            TextFormField(
              initialValue: ref.watch(ApplicationViewmodel.bgrp),
              decoration: vm.decoration('Blood Group'),
              validator: vm.validate,
              onChanged: (value) =>
                  ref.read(ApplicationViewmodel.bgrp.notifier).state = value,
            ),
            SizedBox(height: 15),
            Text('➡ Identification Mark 1'),
            TextFormField(
              initialValue: ref.watch(ApplicationViewmodel.idm1),
              decoration: vm.decoration('mark'),
              validator: vm.validate,
              onChanged: (value) =>
                  ref.read(ApplicationViewmodel.idm1.notifier).state = value,
            ),
            SizedBox(height: 15),
            Text('➡ Identification Mark 2'),
            TextFormField(
              initialValue: ref.watch(ApplicationViewmodel.idm2),
              decoration: vm.decoration('mark'),
              onChanged: (value) =>
                  ref.read(ApplicationViewmodel.idm2.notifier).state = value,
            ),
          ],
          SizedBox(height: 15),
          Text('➡ Pysical Disability'),
          TextFormField(
            initialValue: ref.watch(ApplicationViewmodel.pds),
            decoration: vm.decoration('Disability'),
            validator: vm.validate,
            onChanged: (value) =>
                ref.read(ApplicationViewmodel.pds.notifier).state = value,
          ),
        ],
      ),
    );
  }
}
