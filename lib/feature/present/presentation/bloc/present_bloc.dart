import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:presensi_blockchain/feature/present/domain/usecase/check_location_usecase.dart';
import 'package:presensi_blockchain/feature/present/domain/usecase/handle_location_permission_usecase.dart';
import 'package:presensi_blockchain/feature/present/domain/usecase/input_present_usecase.dart';

part 'present_event.dart';
part 'present_state.dart';

class PresentBloc extends Bloc<PresentEvent, PresentState> {
  final CheckCorrectLocationUsecase checkCorrectLocationUsecase;
  final InputPresentUsecase inputPresentUsecase;
  final HandleLocationPermissionUsecase handleLocationPermissionUsecase =
      HandleLocationPermissionUsecase();

  PresentBloc(
    this.checkCorrectLocationUsecase,
    this.inputPresentUsecase,
  ) : super(
          PresentLoading(),
        ) {
    on<CheckLocation>(
      (event, emit) async {
        return await checkLocation(
          event.latLng,
          emit,
        );
      },
    );
    on<GetCurrentLocation>(
      (event, emit) async {
        return await getLocation(emit);
      },
    );
    on<InputPresent>(
      (event, emit) async {
        return await inputPresent(
          event.idPresent,
          event.idEmployees,
          emit,
        );
      },
    );
  }

  Future<void> checkLocation(
    LatLng latLng,
    Emitter<PresentState> emit,
  ) async {
    emit(
      PresentLoading(),
    );
    final locationStatus =
        await checkCorrectLocationUsecase.checkLocationStatus(
      latLng,
    );
    if (locationStatus) {
      return emit(
        LocationMatch(),
      );
    }
    return emit(
      LocationNotMatch(),
    );
  }

  Future<void> getLocation(
    Emitter<PresentState> emit,
  ) async {
    emit(
      PresentLoading(),
    );
    final location = await handleLocationPermissionUsecase.getCurrentLocation();
    if (location != null) {
      return emit(
        PresentLocationGet(location),
      );
    }
    return emit(
      PresentError("Location is null!"),
    );
  }

  Future<void> inputPresent(
    BigInt idPresent,
    BigInt idEmployee,
    Emitter<PresentState> emit,
  ) async {
    emit(
      StartPresent(),
    );
    log("idEmploye: $idEmployee");
    final result = await inputPresentUsecase.execute(
      idPresent: idPresent,
      idEmployee: idEmployee,
    );

    result.fold(
      (l) => emit(
        PresentFailed(l.message!),
      ),
      (r) => emit(
        PresentSuccess(r),
      ),
    );
  }
}
