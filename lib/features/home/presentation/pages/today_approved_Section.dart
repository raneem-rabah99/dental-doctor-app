import 'package:doctor/core/localization/app_strings.dart';
import 'package:doctor/core/theme/app_color.dart';
import 'package:doctor/features/home/data/sources/today_approved_service.dart';
import 'package:doctor/features/home/presentation/managers/today_approved_cubit.dart';
import 'package:doctor/features/home/presentation/managers/today_approved_state.dart';
import 'package:doctor/features/home/presentation/pages/see_all_today_approved_item.dart';
import 'package:doctor/features/home/presentation/pages/today_approved_item.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TodayApprovedSection extends StatefulWidget {
  const TodayApprovedSection({super.key});

  @override
  State<TodayApprovedSection> createState() => _TodayApprovedSectionState();
}

class _TodayApprovedSectionState extends State<TodayApprovedSection> {
  late final TodayApprovedCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = TodayApprovedCubit(TodayApprovedService());
    _cubit.loadtodayapproved(); // ✅ CALL API ONCE
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final theme = Theme.of(context);

    return BlocProvider.value(
      value: _cubit,
      child: BlocBuilder<TodayApprovedCubit, TodayApprovedState>(
        builder: (context, state) {
          if (state.isLoading) {
            return Center(
              child: CircularProgressIndicator(color: AppColor.darkblue),
            );
          }

          if (state.cases.isEmpty) {
            return Center(
              child: Text(
                strings.noAppointmentsToday,
                style: theme.textTheme.bodyMedium,
              ),
            );
          }

          return SingleChildScrollView(
            child: Container(
              color: theme.scaffoldBackgroundColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ---------- HEADER ----------
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          strings.appointments,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => BlocProvider.value(
                                      value: _cubit, // ✅ SAME CUBIT
                                      child: const SeeAllTodayApprovedItem(),
                                    ),
                              ),
                            );
                          },
                          child: Text(
                            strings.seeAll,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ---------- LIST ----------
                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: state.cases.length,
                      itemBuilder:
                          (_, i) => TodayApprovedItem(caseItem: state.cases[i]),
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
}
