import 'package:attendance/model/credentials_model.dart';
import 'package:attendance/view_model/application_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StudentIdentities extends ConsumerStatefulWidget {
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
  ConsumerState<StudentIdentities> createState() => _StudentIdentitiesState();
}

class _StudentIdentitiesState extends ConsumerState<StudentIdentities> {
  late TextEditingController idm1Controller;
  late TextEditingController idm2Controller;

  @override
  void initState() {
    super.initState();
    idm1Controller = TextEditingController();
    idm2Controller = TextEditingController();
  }

  @override
  void dispose() {
    idm1Controller.dispose();
    idm2Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = ApplicationViewmodel();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      idm1Controller.text = ref.watch(ApplicationViewmodel.idm1) ?? '';
      idm2Controller.text = ref.watch(ApplicationViewmodel.idm2) ?? '';
    });
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.grey.withAlpha(40),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          vm.title(
              widget.isApp ? 'Physically Challenged' : 'Student Identities',
              Icons.badge),
          if (!widget.isApp) ...[
            SizedBox(height: 15),
            Text('➡ Blood Group'),
            DropdownButtonFormField<String>(
              decoration: vm.decoration('Blood Group'),
              validator: vm.validate,
              items: widget.bldGrp.isEmpty
                  ? []
                  : widget.bldGrp
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
              controller: idm1Controller,
              decoration: vm.decoration('mark'),
              validator: vm.validate,
              onChanged: (value) =>
                  ref.read(ApplicationViewmodel.idm1.notifier).state = value,
            ),
            SizedBox(height: 15),
            Text('➡ Identification Mark 2'),
            TextFormField(
              controller: idm2Controller,
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
            items: widget.pcd.isEmpty
                ? []
                : widget.pcd
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
