import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homeessentials/cubit/user_settings_cubit.dart';
import 'package:homeessentials/screens/choose_role_screen.dart';
import 'package:homeessentials/screens/user/change_password_screen.dart';
import 'package:homeessentials/screens/user/delivery_address_screen.dart';
import 'package:homeessentials/screens/user/edit_profile_screen.dart';
import 'package:homeessentials/screens/user/help_support_screen.dart';
import 'package:homeessentials/screens/user/notifications_screen.dart';
import 'package:homeessentials/views/user/user_orders_screen.dart';

class UserSettingsScreen extends StatelessWidget {
  const UserSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UserSettingsCubit(),
      child: BlocConsumer<UserSettingsCubit, UserSettingsState>(
        listener: (context, state) {
          if (state is UserSettingsLoggedOut) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const ChooseRoleScreen()),
            );
          } else if (state is UserSettingsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          final cubit = context.read<UserSettingsCubit>();
          final user = cubit.currentUser;

          return Scaffold(
            backgroundColor: const Color(0xFFF5F6FA),
            appBar: AppBar(
              backgroundColor: const Color(0xFF2563EB),
              title: const Text(
                "Settings",
                style: TextStyle(color: Colors.white),
              ),
              centerTitle: true,
              elevation: 0,
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 32,
                          backgroundColor: Colors.blue.shade100,
                          child: const Icon(
                            Icons.person,
                            size: 36,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user?.displayName ?? "User",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                user?.email ?? "No email",
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Profile & Orders
                  _settingsCard(children: [
                    _settingsTile(
                      icon: Icons.person_outline,
                      title: "Edit Profile",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const EditProfileScreen()),
                        );
                      },
                    ),
                    _settingsTile(
                      icon: Icons.location_on_outlined,
                      title: "Delivery Address",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const DeliveryAddressScreen()),
                        );
                      },
                    ),
                    _settingsTile(
                      icon: Icons.shopping_bag_outlined,
                      title: "My Orders",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const UserOrdersScreen()),
                        );
                      },
                    ),
                  ]),

                  const SizedBox(height: 16),

                  // Security & Help
                  _settingsCard(children: [
                    _settingsTile(
                      icon: Icons.lock_outline,
                      title: "Change Password",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const ChangePasswordScreen()),
                        );
                      },
                    ),
                    _settingsTile(
                      icon: Icons.notifications_none,
                      title: "Notifications",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const NotificationsScreen()),
                        );
                      },
                    ),
                    _settingsTile(
                      icon: Icons.help_outline,
                      title: "Help & Support",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const HelpSupportScreen()),
                        );
                      },
                    ),
                  ]),

                  const SizedBox(height: 16),

                  // Logout
                  _settingsCard(children: [
                    ListTile(
                      leading: const Icon(Icons.logout, color: Colors.red),
                      title: const Text(
                        "Logout",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () {
                        cubit.logout();
                      },
                    ),
                  ]),

                  const SizedBox(height: 20),
                  const Text(
                    "HomeEssentials v1.0.0",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _settingsCard({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _settingsTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
