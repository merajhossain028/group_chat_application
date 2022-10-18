import 'package:flutter/material.dart';
import 'package:tt_group_chat/screens/home_page.dart';
import 'package:tt_group_chat/service/auth_service.dart';

import '../helper/helper_function.dart';
import '../widgets/widgets.dart';
import 'auth/login_page.dart';

class ProfilePage extends StatefulWidget {
  String userName;
  String email;
  ProfilePage({Key? key, required this.userName, required this.email})
      : super(key: key);
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Profile'),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 50),
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Icon(
                Icons.account_circle,
                size: 100,
                color: Colors.grey,
              ),
            ),
            Text(
              widget.userName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            const Divider(
              height: 2,
            ),
            ListTile(
              onTap: () {
                nextScreenReplace(context, const HomePage());
              },
              leading: const Icon(Icons.group),
              title: const Text('Groups'),
            ),
            ListTile(
              onTap: () {},
              selectedColor: Theme.of(context).primaryColor,
              selected: true,
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
            ),
            ListTile(
              onTap: () async {
                await authService.signOut();
                HelperFunction.saveUserLoggedInStatus(false);
                // ignore: use_build_context_synchronously
                nextScreen(context, const LoginPage());
              },
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Logout'),
            ),
          ],
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 170),
        child: Column(
          children: [
            const Icon(Icons.account_circle, size: 100, color: Colors.grey),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Full Name',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.userName,
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            const Divider(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Email',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.email,
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
