import 'dart:io';

import 'package:attendance/model/credentials_model.dart';
import 'package:attendance/view_model/application_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:attendance/widget/date_field.dart';

class PersonalDetails extends ConsumerStatefulWidget {
  const PersonalDetails(
      {super.key, required this.isApp, required this.genders});
  final bool isApp;
  final List<CredentialInfo> genders;

  @override
  ConsumerState<PersonalDetails> createState() => _PersonalDetailsState();
}

class _PersonalDetailsState extends ConsumerState<PersonalDetails> {
  late TextEditingController nameController;
  late TextEditingController aadharController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    aadharController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    aadharController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = ApplicationViewmodel();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      nameController.text = ref.watch(ApplicationViewmodel.name) ?? '';
      aadharController.text = ref.watch(ApplicationViewmodel.aadhar) ?? '';
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
          vm.title('Personal Details', Icons.person),
          if (widget.isApp) ...[
            SizedBox(height: 15),
            Text('➡ Student Name'),
            TextFormField(
              controller: nameController,
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
              items: widget.genders.isEmpty
                  ? []
                  : widget.genders
                      .map((item) => DropdownMenuItem<String>(
                            value: item.oid,
                            child: Text(item.description),
                          ))
                      .toList(),
              borderRadius: BorderRadius.circular(10),
              value: ref.watch(ApplicationViewmodel.gender),
              onChanged: (value) =>
                  ref.read(ApplicationViewmodel.gender.notifier).state = value,
            ),
          ],
          if (!widget.isApp) ...[
            SizedBox(height: 15),
            Text('➡ Addhar No'),
            TextFormField(
              controller: aadharController,
              decoration: vm.decoration('Addhar'),
              validator: vm.validate,
              keyboardType: TextInputType.number,
              onChanged: (value) =>
                  ref.read(ApplicationViewmodel.aadhar.notifier).state = value,
            ),
          ],
          SizedBox(height: 15),
          Text('➡ Student Photo'),
          Builder(builder: (context) {
            final img = ref.watch(ApplicationViewmodel.imagePath);
            final edit = ref.watch(ApplicationViewmodel.oIdForEdit);
            if (edit != null && edit.isEmpty) {
              return LinearProgressIndicator();
            }
            return GestureDetector(
              onTap: () async {
                await vm.pickImage(ref);
              },
              child: imageView(img),
            );
          }),
        ],
      ),
    );
  }

  Widget imageView(String? img) {
    return Container(
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
                Image.file(File(img),
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity),
                Align(
                  alignment: Alignment.center,
                  child: CircleAvatar(
                    backgroundColor: Colors.black54,
                    child: Icon(Icons.upload, color: Colors.white, size: 30),
                  ),
                ),
              ],
            ),
    );
  }
}
