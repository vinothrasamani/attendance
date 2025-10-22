import 'dart:io';

import 'package:attendance/view_model/application_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:attendance/widget/date_field.dart';

class PersonalDetails extends ConsumerWidget {
  const PersonalDetails({super.key});

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
          vm.title('Personal Details', Icons.person),
          SizedBox(height: 15),
          Text('➡ Student Name'),
          TextFormField(
            initialValue: ref.watch(ApplicationViewmodel.name),
            decoration: vm.decoration('Student Name'),
            validator: vm.validate,
            onChanged: (value) =>
                ref.read(ApplicationViewmodel.name.notifier).state = value,
          ),
          SizedBox(height: 15),
          Text('➡ Date of Birth'),
          DateField(
            value: ref
                .watch(ApplicationViewmodel.dob)
                .toIso8601String()
                .split('T')
                .first,
            onTap: () async {
              final date = await vm.pickADate(
                  context, ref.watch(ApplicationViewmodel.dob));
              if (date != null) {
                ref.read(ApplicationViewmodel.dob.notifier).state = date;
              }
            },
          ),
          SizedBox(height: 15),
          Text('➡ Gender'),
          DropdownButtonFormField<String>(
            decoration: vm.decoration('Gender'),
            validator: vm.validate,
            items: ['Male', 'Female', 'Others']
                .map((item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(item),
                    ))
                .toList(),
            borderRadius: BorderRadius.circular(10),
            value: ref.watch(ApplicationViewmodel.gender),
            onChanged: (value) =>
                ref.read(ApplicationViewmodel.gender.notifier).state = value,
          ),
          SizedBox(height: 15),
          Text('➡ Addhar No'),
          TextFormField(
            initialValue: ref.watch(ApplicationViewmodel.addhar),
            decoration: vm.decoration('Addhar'),
            validator: vm.validate,
            keyboardType: TextInputType.number,
            onChanged: (value) =>
                ref.read(ApplicationViewmodel.addhar.notifier).state = value,
          ),
          SizedBox(height: 15),
          Text('➡ Student Photo'),
          Builder(builder: (context) {
            final img = ref.watch(ApplicationViewmodel.imagePath);
            return GestureDetector(
              onTap: () async {
                await vm.pickImage(ref);
              },
              child: Container(
                padding: EdgeInsets.all(img == null ? 20 : 0),
                constraints: BoxConstraints(minHeight: 160, maxHeight: 250),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey),
                ),
                clipBehavior: Clip.hardEdge,
                alignment: Alignment.center,
                child: img == null
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.upload_file, size: 30),
                          SizedBox(height: 15),
                          Text('Upload Profile Image!')
                        ],
                      )
                    : Stack(
                        children: [
                          Image.file(
                            File(img),
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: CircleAvatar(
                              backgroundColor: Colors.black54,
                              child: Icon(
                                Icons.upload,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
