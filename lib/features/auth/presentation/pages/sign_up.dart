import 'dart:convert';
import 'package:doctor/core/classes/icon_classes.dart';
import 'package:doctor/features/auth/data/models/register_model.dart';
import 'package:doctor/features/auth/data/sources/register_service.dart';
import 'package:doctor/features/auth/presentation/managers/register_cubit.dart';
import 'package:doctor/features/auth/presentation/managers/register_state.dart';
import 'package:doctor/features/auth/presentation/pages/personal_info.dart';
import 'package:doctor/features/auth/presentation/widgets/password.dart';
import 'package:doctor/features/auth/presentation/widgets/phone_number_widget.dart';
import 'package:doctor/features/auth/presentation/widgets/select_one_from_options_widget.dart';
import 'package:doctor/features/auth/presentation/widgets/signupWidgit.dart';
import 'package:doctor/features/auth/presentation/widgets/validator.dart';

import 'package:doctor/core/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  final firstnameController = TextEditingController();
  final fathernameController = TextEditingController();
  final lastnameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();

  String? selectedGender;
  double? latitude;
  double? longitude;
  String? fullAddressFromMap;

  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  // Default map center (Damascus)
  LatLng mapCenter = LatLng(33.5138, 36.2765);

  // ───────────────────────────────────────────
  // 🔵 REVERSE GEOCODING — AUTO GET FULL ADDRESS
  // ───────────────────────────────────────────
  Future<String> getFullAddress(double lat, double lng) async {
    final url = Uri.parse(
      "https://nominatim.openstreetmap.org/reverse?format=json&lat=$lat&lon=$lng",
    );

    final response = await http.get(url, headers: {"User-Agent": "FlutterApp"});

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final address = data["address"] ?? {};

      final road = address["road"] ?? "";
      final neighbourhood = address["neighbourhood"] ?? "";
      final city =
          address["city"] ?? address["town"] ?? address["village"] ?? "";
      final state = address["state"] ?? "";
      final country = address["country"] ?? "";

      return "$road, $neighbourhood, $city, $state, $country";
    }

    return "Unknown location";
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RegisterCubit(RegisterService()),
      child: Scaffold(
        body: BlocConsumer<RegisterCubit, RegisterState>(
          listener: (context, state) async {
            if (state.isLoading) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Registering...')));
            } else if (state.successMessage != null) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.successMessage!)));

              final cubit = context.read<RegisterCubit>();
              final user = cubit.lastUserData;
              if (user != null) {
                await secureStorage.write(
                  key: 'token',
                  value: user['token'] ?? '',
                );
                await secureStorage.write(
                  key: 'email',
                  value: emailController.text,
                );
              }

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const DoctorProfilePage()),
              );
            } else if (state.errorMessage != null) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
            }
          },
          builder: (context, state) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColor.darkblue, AppColor.lightblue],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: SafeArea(
                child: Stack(
                  children: [
                    Positioned(
                      top: 10,
                      left: 10,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                    Center(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: _buildFormContainer(context, state.isLoading),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ───────────────────────────────────────────
  // 🔵 MAIN FORM UI
  // ───────────────────────────────────────────
  Widget _buildFormContainer(BuildContext context, bool isLoading) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildHeaderTop("Create new account"),
            const SizedBox(height: 8),
            buildHeader("Enter the following info to create new account."),
            const SizedBox(height: 20),

            _buildInputs(),

            const SizedBox(height: 20),
            buildButton100(
              isLoading ? "Signing up..." : "Sign Up",
              isLoading ? null : () => _signUp(context),
            ),
            const SizedBox(height: 10),
            buildLoginLink(context),
          ],
        ),
      ),
    );
  }

  // ───────────────────────────────────────────
  // 🔵 ALL INPUT FIELDS
  // ───────────────────────────────────────────
  Widget _buildInputs() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _inputTitle("First Name"),
        buildTextField(
          firstnameController,
          "John",
          IconePerson.person,
          validator: Validators.validateName,
        ),

        _inputTitle("Father Name"),
        buildTextField(
          fathernameController,
          "Doe",
          IconePerson.person,
          validator: Validators.validateName,
        ),

        _inputTitle("Last Name"),
        buildTextField(
          lastnameController,
          "Smith",
          IconePerson.person,
          validator: Validators.validateName,
        ),

        _inputTitle("Gender"),
        SelectOneFromOptionsWidget(items: ["Male", "Female"]),

        _inputTitle("Email"),
        buildTextField(
          emailController,
          "example@email.com",
          IconMail.iconmail,
          validator: Validators.validateEmail,
        ),

        _inputTitle("Phone Number"),
        PhoneNumberInput(
          onChanged: (phone) => phoneController.text = phone,
          initialCountryCode: '+963',
          showPhoneIcon: false,
          initialPhoneNumber: phoneController.text,
          hintText: '|  _ _ _ _ _ _ _ _ _ _',
          showFlag: false,
        ),

        _inputTitle("Password"),
        PasswordInput(
          hintText: '*************',
          controller: passwordController,
          validator: Validators.validatePassword,
        ),

        _inputTitle("Confirm Password"),
        PasswordInput(
          hintText: '*************',
          controller: passwordConfirmController,
          validator: Validators.validatePassword,
        ),

        const SizedBox(height: 20),
        const Text(
          "Select Your Location",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),

        _buildMap(),

        const SizedBox(height: 10),
        if (fullAddressFromMap != null)
          Text(fullAddressFromMap!, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }

  Widget _buildMap() {
    return SizedBox(
      height: 200,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: FlutterMap(
          options: MapOptions(
            initialCenter: mapCenter,
            initialZoom: 12,
            onTap: (tapPosition, point) async {
              setState(() {
                latitude = point.latitude;
                longitude = point.longitude;
              });

              // 🔥 AUTO FULL ADDRESS
              final address = await getFullAddress(
                point.latitude,
                point.longitude,
              );

              setState(() {
                fullAddressFromMap = address;
              });
            },
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
              subdomains: const ['a', 'b', 'c'],
            ),
            if (latitude != null && longitude != null)
              MarkerLayer(
                markers: [
                  Marker(
                    point: LatLng(latitude!, longitude!),
                    width: 40,
                    height: 40,
                    child: const Icon(
                      Icons.location_pin,
                      color: Colors.red,
                      size: 40,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _inputTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 5),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  // ───────────────────────────────────────────
  // 🔵 SIGN UP FUNCTION
  // ───────────────────────────────────────────
  void _signUp(BuildContext context) {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    if (fullAddressFromMap == null || latitude == null || longitude == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please tap on the map to select location'),
        ),
      );
      return;
    }

    final addressCombined = "${latitude},${longitude} | $fullAddressFromMap";
    // 🔥 Coordinates + full address

    final model = RegisterModel(
      firstName: firstnameController.text,
      fatherName: fathernameController.text,
      lastName: lastnameController.text,
      phone: phoneController.text,
      email: emailController.text,
      password: passwordController.text,
      address: addressCombined, // 🔥 SEND BOTH
      gender: selectedGender?.toLowerCase() ?? 'male',
    );

    context.read<RegisterCubit>().registerUser(model);
  }
}
