import 'dart:convert';

import 'package:attendance/main.dart';
import 'package:attendance/model/profile_model.dart';
import 'package:attendance/view_model/profile_service.dart';
import 'package:attendance/view_model/user_sevice.dart';
import 'package:attendance/widget/error_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final profile = ref.watch(ProfileService.profile(user?.staffCode));
    final size = MediaQuery.of(context).size;

    Widget info(IconData icon, String title, String val) => ListTile(
          leading: Icon(icon),
          dense: true,
          contentPadding: EdgeInsets.all(0),
          title: Text(
            title,
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey),
          ),
          subtitle: Text(val, style: TextStyle(fontSize: 16)),
        );

    Widget details(ProfileData? p) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Account Details',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          info(Icons.phone, 'Mobile Number', p?.mobilePhone ?? '-'),
          info(Icons.category, 'Category', p?.category ?? '-'),
          info(Icons.apartment, 'Department', p?.department ?? '-'),
          info(Icons.school, 'Qualification', p?.qualification ?? '-'),
          info(Icons.work, 'Designation', p?.designation ?? '-'),
          info(Icons.cake, 'Date of Birth',
              p?.dob?.toIso8601String().split('T')[0] ?? '-'),
          info(Icons.badge, 'Date of Joining',
              p?.doj?.toIso8601String().split('T')[0] ?? '-'),
          info(Icons.location_city, 'Permanent Address',
              p?.permenantAddress ?? '-'),
        ],
      );
    }

    Future<Uint8List> getImage() async {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      final img = preferences.getString('profile_image');
      Uint8List? source;
      if (img != null) {
        source = base64Decode(img);
      }
      return source ?? Uint8List(0);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(0.5),
          child: Container(height: 0.5, color: Colors.grey),
        ),
      ),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  color: Colors.grey.withAlpha(30),
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      GestureDetector(
                        onTap: () =>
                            ProfileService.uploadProfile(ref, getImage()),
                        child: Stack(
                          children: [
                            FutureBuilder(
                              future: getImage(),
                              builder: (context, snap) {
                                if (snap.hasData) {
                                  return CircleAvatar(
                                    radius: 50,
                                    backgroundImage:
                                        AssetImage('assets/person.png'),
                                    foregroundImage: MemoryImage(snap.data!),
                                  );
                                }
                                return CircleAvatar(
                                  radius: 50,
                                  backgroundImage:
                                      AssetImage('assets/person.png'),
                                );
                              },
                            ),
                            Positioned(
                              bottom: 3,
                              right: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor),
                                ),
                                child: CircleAvatar(
                                  backgroundColor: baseColor,
                                  radius: 14,
                                  child: Icon(Icons.photo_camera,
                                      color: Colors.white, size: 16),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        user != null
                            ? ('${user.firstName} ${user.middleName ?? ''} ${user.lastName ?? ''}')
                                .trim()
                            : 'Username',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text('code : ${user?.staffCode}'),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  color: Colors.grey.withAlpha(30),
                  child: profile.when(
                    data: (snap) {
                      return details(snap);
                    },
                    error: (error, _) {
                      return SizedBox(
                        height: size.height * 0.55,
                        child: ErrorCard(
                          icon: Icons.error,
                          err: 'Unable to load profile, try again later!',
                        ),
                      );
                    },
                    loading: () {
                      return SizedBox(
                        height: size.height * 0.55,
                        child: Center(child: CircularProgressIndicator()),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
