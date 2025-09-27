import 'package:attendance/main.dart';
import 'package:attendance/model/profile_model.dart';
import 'package:attendance/view_model/profile_service.dart';
import 'package:attendance/view_model/user_sevice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final profile = ref.watch(ProfileService.profile(user?.staffCode));
    final c = Colors.red[800]!;
    final size = MediaQuery.of(context).size;

    Widget info(IconData icon, String title, String val) => ListTile(
          leading: Icon(icon),
          title: Text(
            title,
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey),
          ),
          subtitle: Text(val, style: TextStyle(fontSize: 16)),
        );

    Widget details(ProfileData? p) {
      return Column(
        children: [
          info(Icons.confirmation_number, 'Staff Code', p?.staffCode ?? '-'),
          info(Icons.category, 'Category', p?.category ?? '-'),
          info(Icons.apartment, 'Department', p?.department ?? '-'),
          info(Icons.school, 'Qualification', p?.qualification ?? '-'),
          info(Icons.work, 'Designation', p?.designation ?? '-'),
          info(Icons.cake, 'Date of Birth',
              p?.dob?.toIso8601String().split('T')[0] ?? '-'),
          info(Icons.badge, 'Date of Joining',
              p?.doj?.toIso8601String().split(' ')[0] ?? '-'),
          info(Icons.location_city, 'Permanent Address',
              p?.permenantAddress ?? '-'),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(15),
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 30),
                GestureDetector(
                  onTap: () {},
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage('assets/person.png'),
                      ),
                      Positioned(
                        bottom: 4,
                        right: 0,
                        child: CircleAvatar(
                          backgroundColor: baseColor,
                          radius: 14,
                          child: Icon(Icons.photo_camera,
                              color: Colors.white, size: 16),
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
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                profile.when(
                  data: (snap) {
                    return details(snap);
                  },
                  error: (error, _) {
                    return SizedBox(
                      height: size.height * 0.55,
                      child: Center(
                        child: Container(
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: c.withAlpha(80)),
                            color: c.withAlpha(10),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.error, color: c, size: 40),
                              SizedBox(height: 10),
                              Text(
                                'Unable to load profile, try again later!',
                                style: TextStyle(color: c),
                              ),
                            ],
                          ),
                        ),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
