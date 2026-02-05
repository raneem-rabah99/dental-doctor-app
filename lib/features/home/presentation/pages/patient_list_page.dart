import 'package:doctor/core/localization/app_strings.dart';
import 'package:doctor/core/theme/app_color.dart';
import 'package:doctor/features/home/data/models/customer_model.dart';
import 'package:doctor/features/home/data/sources/doctor_service.dart';
import 'package:doctor/features/home/presentation/managers/doctor_cubit.dart';
import 'package:doctor/features/home/presentation/managers/doctor_state.dart';
import 'package:doctor/features/home/presentation/pages/patient_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doctor/features/home/data/models/panorama_teeth_response.dart';

class CustomersListPage extends StatefulWidget {
  const CustomersListPage({super.key});

  @override
  State<CustomersListPage> createState() => _CustomersListPageState();
}

class _CustomersListPageState extends State<CustomersListPage> {
  final searchController = TextEditingController();

  CustomerModel? _customer;
  CustomerModel? _filteredCustomer;

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: Text(
          strings.patient,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Color(0xFF234E9D),
          ),
        ),
      ),

      body: Column(
        children: [
          /// ===================== HEADER =====================
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  colors: [Color(0xFF4C89FF), Color(0xFF6AA7FF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.person_search,
                    color: Colors.white,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      strings.patientHint,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        height: 1.3,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// ===================== SEARCH =====================
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                if (_customer == null) return;

                final q = value.toLowerCase();

                if (q.isEmpty) {
                  setState(() {
                    _filteredCustomer = _customer;
                  });
                  return;
                }

                final match =
                    _customer!.fullName.toLowerCase().contains(q) ||
                    _customer!.phone.toLowerCase().contains(q) ||
                    _customer!.email.toLowerCase().contains(q) ||
                    _customer!.address.toLowerCase().contains(q);

                setState(() {
                  _filteredCustomer = match ? _customer : null;
                });
              },
              decoration: InputDecoration(
                hintText: strings.search,
                hintStyle: const TextStyle(fontSize: 15),
                prefixIcon: const Icon(Icons.search, color: Colors.blue),
                filled: true,
                fillColor: Theme.of(context).cardColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          /// ===================== LIST =====================
          Expanded(
            child: BlocProvider(
              create:
                  (_) => PanoramaTeethCubit(PanoramaTeethService())..loadData(
                    token: "USER_TOKEN", // 🔴 get from secure storage
                    customerId: 304,
                  ),
              child: BlocBuilder<PanoramaTeethCubit, PanoramaTeethState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: AppColor.darkblue,
                      ),
                    );
                  }

                  if (state.error != null) {
                    return Center(child: Text(state.error!));
                  }

                  if (state.data == null) {
                    return Center(child: Text(strings.noDoctorsFound));
                  }

                  final PanoramaTeethResponse response = state.data!;

                  _customer ??= response.customer;
                  _filteredCustomer ??= response.customer;

                  if (_filteredCustomer == null) {
                    return Center(child: Text(strings.noDoctorsFound));
                  }

                  final customer = _filteredCustomer!;

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: 1,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => patientDetailsPage(
                                    customerId: customer.id,
                                  ),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.14),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 32,
                                backgroundColor: AppColor.lightblue,
                                backgroundImage: AssetImage(
                                  "assets/images/default_profile.png",
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      customer.fullName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      customer.address,
                                      style: const TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(customer.phone),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
