import 'package:attendance/model/credentials_model.dart';
import 'package:attendance/view_model/application_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StudentIdentities extends ConsumerWidget {
  const StudentIdentities({
    super.key,
    required this.isApp,
    required this.pcd,
    required this.bldGrp,
  });
  final bool isApp;
  final List<CredentialInfo> pcd;
  final List<CredentialInfo> bldGrp;

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
            DropdownButtonFormField<String>(
              decoration: vm.decoration('Blood Group'),
              validator: vm.validate,
              items: bldGrp.isEmpty
                  ? []
                  : bldGrp
                      .map((item) => DropdownMenuItem<String>(
                            value: item.oid,
                            child: Text(item.description),
                          ))
                      .toList(),
              borderRadius: BorderRadius.circular(10),
              value: ref.watch(ApplicationViewmodel.bgrp),
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
          DropdownButtonFormField<String>(
            decoration: vm.decoration('Disability'),
            validator: vm.validate,
            items: pcd.isEmpty
                ? []
                : pcd
                    .map((item) => DropdownMenuItem<String>(
                          value: item.oid,
                          child: Text(item.description),
                        ))
                    .toList(),
            borderRadius: BorderRadius.circular(10),
            value: ref.watch(ApplicationViewmodel.pds),
            onChanged: (value) =>
                ref.read(ApplicationViewmodel.pds.notifier).state = value,
          ),
        ],
      ),
    );
  }
}
