import 'package:attendance/main.dart';
import 'package:attendance/view_model/application_viewmodel.dart';
import 'package:attendance/widget/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StudentApplicationScreen extends ConsumerStatefulWidget {
  const StudentApplicationScreen({super.key});

  @override
  ConsumerState<StudentApplicationScreen> createState() =>
      _StudentApplicationScreenState();
}

class _StudentApplicationScreenState
    extends ConsumerState<StudentApplicationScreen> {
  final _key = GlobalKey<FormState>();

  Widget title(String txt) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: baseColor.withAlpha(150),
          ),
          child: Icon(Icons.person, size: 20),
        ),
        SizedBox(width: 8),
        Text(
          txt,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  InputDecoration decoration(String label) {
    return InputDecoration(
      hintText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Student Application'),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(40),
            child: TabBar(
              tabs: [
                Tab(text: 'Personal'),
                Tab(text: 'Accademic'),
                Tab(text: 'Identities'),
              ],
            ),
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              child: Text('Save Application'),
            ),
          ),
        ),
        body: SafeArea(
          child: Form(
            key: _key,
            child: TabBarView(
              children: [
                Center(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(12),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.grey.withAlpha(40),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          title('Personal Details'),
                          SizedBox(height: 15),
                          Text('➡ Student Name'),
                          TextFormField(
                            initialValue: ref.watch(ApplicationViewmodel.name),
                            decoration: decoration('Student Name'),
                            validator: (value) => value!.isEmpty
                                ? 'This field is required!'
                                : null,
                            onChanged: (value) => ref
                                .read(ApplicationViewmodel.name.notifier)
                                .state = value,
                          ),
                          SizedBox(height: 15),
                          Text('➡ Date of Birth'),
                          DateField(
                            value: 'value',
                            onTap: () {},
                          ),
                          SizedBox(height: 15),
                          Text('➡ Gender'),
                          DropdownButtonFormField<String>(
                            decoration: decoration('Gender'),
                            items: ['Male', 'Female', 'Others']
                                .map((item) => DropdownMenuItem<String>(
                                      value: item,
                                      child: Text(item),
                                    ))
                                .toList(),
                            borderRadius: BorderRadius.circular(10),
                            onChanged: (value) => ref
                                .read(ApplicationViewmodel.emis.notifier)
                                .state = value,
                          ),
                          // SizedBox(height: 15),
                          // Text('➡ EMIS No'),
                          // TextFormField(
                          //   initialValue: ref.watch(ApplicationViewmodel.emis),
                          //   validator: (value) => value!.isEmpty
                          //       ? 'This field is required!'
                          //       : null,
                          //   decoration: decoration('EMIS'),
                          //   onChanged: (value) => ref
                          //       .read(ApplicationViewmodel.emis.notifier)
                          //       .state = value,
                          // ),
                          // SizedBox(height: 15),
                          // Text('➡ New EMIS No'),
                          // TextFormField(
                          //   initialValue:
                          //       ref.watch(ApplicationViewmodel.newEmis),
                          //   decoration: decoration('New EMIS'),
                          //   validator: (value) => value!.isEmpty
                          //       ? 'This field is required!'
                          //       : null,
                          //   onChanged: (value) => ref
                          //       .read(ApplicationViewmodel.newEmis.notifier)
                          //       .state = value,
                          // ),
                          // SizedBox(height: 15),
                          // Text('➡ staff Name'),
                          // TextFormField(
                          //   initialValue:
                          //       ref.watch(ApplicationViewmodel.staffName),
                          //   decoration: decoration('Statff Name'),
                          //   validator: (value) => value!.isEmpty
                          //       ? 'This field is required!'
                          //       : null,
                          //   onChanged: (value) => ref
                          //       .read(ApplicationViewmodel.staffName.notifier)
                          //       .state = value,
                          // ),
                          SizedBox(height: 15),
                          Text('➡ Addhar No'),
                          TextFormField(
                            initialValue:
                                ref.watch(ApplicationViewmodel.addhar),
                            decoration: decoration('Addhar'),
                            validator: (value) => value!.isEmpty
                                ? 'This field is required!'
                                : null,
                            onChanged: (value) => ref
                                .read(ApplicationViewmodel.addhar.notifier)
                                .state = value,
                          ),
                          SizedBox(height: 15),
                          Container(
                            padding: EdgeInsets.all(20),
                            height: 160,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey),
                            ),
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.upload_file, size: 30),
                                SizedBox(height: 15),
                                Text('Upload Profile Image!')
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    title('Accademic Details'),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    title('Student Identities'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
