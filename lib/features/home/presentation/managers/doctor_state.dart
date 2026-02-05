import 'package:doctor/features/home/data/models/panorama_teeth_response.dart';

class PanoramaTeethState {
  final bool isLoading;
  final PanoramaTeethResponse? data;
  final String? error;

  PanoramaTeethState({required this.isLoading, this.data, this.error});

  factory PanoramaTeethState.initial() {
    return PanoramaTeethState(isLoading: false);
  }

  PanoramaTeethState copyWith({
    bool? isLoading,
    PanoramaTeethResponse? data,
    String? error,
  }) {
    return PanoramaTeethState(
      isLoading: isLoading ?? this.isLoading,
      data: data ?? this.data,
      error: error,
    );
  }
}
