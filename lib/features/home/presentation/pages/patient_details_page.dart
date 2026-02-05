import 'package:doctor/features/home/data/models/panorama_teeth_response.dart';
import 'package:doctor/features/home/data/models/tooth_model.dart';
import 'package:doctor/features/home/data/sources/doctor_service.dart';
import 'package:doctor/features/home/presentation/managers/doctor_cubit.dart';
import 'package:doctor/features/home/presentation/managers/doctor_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doctor/core/theme/app_color.dart';
import 'package:doctor/core/localization/app_strings.dart';

class patientDetailsPage extends StatelessWidget {
  final int customerId;

  const patientDetailsPage({super.key, required this.customerId});

  /// 🔧 FIX BROKEN IMAGE URLS
  String fixImageUrl(String url) {
    if (url.isEmpty) return "";
    if (url.startsWith("http")) return url;
    final index = url.indexOf("http");
    return index != -1 ? url.substring(index) : "";
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final theme = Theme.of(context);
    final token = "USER_TOKEN"; // 🔴 get from secure storage

    return Directionality(
      textDirection: strings.isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: BlocProvider(
        create:
            (_) =>
                PanoramaTeethCubit(PanoramaTeethService())
                  ..loadData(token: token, customerId: customerId),
        child: BlocBuilder<PanoramaTeethCubit, PanoramaTeethState>(
          builder: (context, state) {
            if (state.isLoading) {
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(color: AppColor.darkblue),
                ),
              );
            }

            if (state.error != null) {
              return Scaffold(body: Center(child: Text(state.error!)));
            }

            final PanoramaTeethResponse response = state.data!;
            final customer = response.customer;
            final panorama = response.panoramaPhoto;
            final teeth = response.teeth;

            return Scaffold(
              backgroundColor: theme.scaffoldBackgroundColor,
              appBar: AppBar(
                backgroundColor: theme.appBarTheme.backgroundColor,
                elevation: 0,
                title: Text(
                  customer!.fullName,
                  style: theme.appBarTheme.titleTextStyle,
                ),
                centerTitle: true,
              ),
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// ================= CUSTOMER CARD =================
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          if (theme.brightness == Brightness.light)
                            BoxShadow(
                              blurRadius: 10,
                              color: Colors.grey.withOpacity(0.15),
                            ),
                        ],
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: AppColor.lightblue,
                            backgroundImage: const AssetImage(
                              "assets/images/default_profile.png",
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  customer!.fullName,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  customer.address,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  "${strings.phoneLabel}: ${customer.phone}",
                                ),
                                Text(
                                  "${strings.emailLabel}: ${customer.email}",
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    /// ================= PANORAMA =================
                    Text(
                      strings.panoramaTitle,
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        fixImageUrl(panorama!.photo),
                        width: double.infinity,
                        height: 220,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return SizedBox(
                            height: 220,
                            child: Center(
                              child: CircularProgressIndicator(
                                color: AppColor.darkblue,
                              ),
                            ),
                          );
                        },
                        errorBuilder: (_, __, ___) {
                          return Container(
                            height: 220,
                            color: Colors.grey.shade300,
                            child: const Center(
                              child: Icon(Icons.broken_image, size: 40),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 24),

                    /// ================= TEETH =================
                    Text(
                      strings.teethTitle,
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),

                    ...teeth.map(
                      (ToothModel tooth) => Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: theme.cardColor,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            if (theme.brightness == Brightness.light)
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.12),
                                blurRadius: 6,
                              ),
                          ],
                        ),
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              fixImageUrl(tooth.icon),
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (_, __, ___) =>
                                      const Icon(Icons.image_not_supported),
                            ),
                          ),
                          title: Text(
                            "${strings.toothLabel} ${tooth.number} - ${tooth.name}",
                          ),
                          subtitle: Text(tooth.description),
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
}
