import 'package:doctor/core/theme/app_color.dart';
import 'package:doctor/features/home/presentation/managers/today_approved_cubit.dart';
import 'package:doctor/features/home/presentation/managers/today_approved_state.dart';
import 'package:doctor/features/home/presentation/pages/today_approved_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SeeAllTodayApprovedItem extends StatelessWidget {
  const SeeAllTodayApprovedItem({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodayApprovedCubit, TodayApprovedState>(
      builder: (context, state) {
        if (state.isLoading) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: AppColor.darkblue),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(title: const Text("Today Approved")),
          body: SingleChildScrollView(
            child: ListView.builder(
              itemCount: state.cases.length,
              itemBuilder:
                  (_, i) => TodayApprovedItem(caseItem: state.cases[i]),
            ),
          ),
        );
      },
    );
  }
}
