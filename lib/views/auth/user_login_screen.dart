import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:animate_do/animate_do.dart';
import 'package:homeessentials/cubit/user_login_cubit.dart';
import 'package:homeessentials/cubit/user_login_state.dart';
import 'package:homeessentials/views/auth/user_register_screen.dart';
import 'package:homeessentials/screens/user/user_root_screen.dart';

class UserLoginScreen extends StatefulWidget {
  const UserLoginScreen({super.key});

  @override
  State<UserLoginScreen> createState() => _UserLoginScreenState();
}

class _UserLoginScreenState extends State<UserLoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UserLoginCubit(),
      child: BlocListener<UserLoginCubit, UserLoginState>(
        listener: (context, state) {
          if (state is UserLoginSuccess) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const UserRootScreen(),
              ),
            );
          }

          if (state is UserLoginError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: Scaffold(
          body: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF2563EB), Color(0xFF1E40AF)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 26),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      FadeInDown(
                        duration: const Duration(milliseconds: 700),
                        child: const Icon(
                          Icons.person_rounded,
                          size: 80,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "User Login",
                        style: TextStyle(
                          fontSize: 26,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        "Access your shopping account",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 40),

                      FadeInUp(
                        duration: const Duration(milliseconds: 700),
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: [
                              TextField(
                                controller: emailController,
                                keyboardType:
                                    TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  labelText: "Email",
                                  prefixIcon:
                                      const Icon(Icons.email_outlined),
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),

                              TextField(
                                controller: passwordController,
                                obscureText: obscurePassword,
                                decoration: InputDecoration(
                                  labelText: "Password",
                                  prefixIcon:
                                      const Icon(Icons.lock_outline),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      obscurePassword
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        obscurePassword =
                                            !obscurePassword;
                                      });
                                    },
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),

                              BlocBuilder<UserLoginCubit,
                                  UserLoginState>(
                                builder: (context, state) {
                                  return SizedBox(
                                    width: double.infinity,
                                    height: 48,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:  Color(0xFF2563EB),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadiusGeometry.circular(25)
                                        )
                                      ),
                                      onPressed:
                                          state is UserLoginLoading
                                              ? null
                                              : () {
                                                  context
                                                      .read<
                                                          UserLoginCubit>()
                                                      .login(
                                                        email:
                                                            emailController
                                                                .text,
                                                        password:
                                                            passwordController
                                                                .text,
                                                      );
                                                },
                                      child:
                                          state is UserLoginLoading
                                              ? const CircularProgressIndicator(
                                                  color: Colors.white,
                                                )
                                              : const Text(
                                                  "Login",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold,
                                                  ),
                                                ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          "← Back",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),

                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const UserRegisterScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          "Don't have an account? Register",
                          style:
                              TextStyle(color: Colors.white70),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
