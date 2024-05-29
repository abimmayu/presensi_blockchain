import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presensi_blockchain/feature/dashboard/data/repository/home_repository_impl.dart';
import 'package:presensi_blockchain/feature/dashboard/domain/repository/home_repository.dart';

part "home_event.dart";
part "home_state.dart";

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository homeRepository = HomeRepositoryImpl();

  HomeBloc()
      : super(
          HomeLoading(),
        ) {
    on<GetPresentInMonth>(
      (event, emit) async {
        await getPresentInMonth(
          event.id,
          event.month,
          event.year,
          emit,
        );
      },
    );
  }

  Future<void> getPresentInMonth(
    int id,
    int month,
    int year,
    Emitter<HomeState> emit,
  ) async {
    final result = await homeRepository.getPresentInMonth(id, month, year);
    result.fold(
      (l) => emit(HomeError(l.message!)),
      (r) {
        log(r.runtimeType.toString());
        emit(
          HomeLoaded(
            presentInMonth: r[0],
          ),
        );
      },
    );
  }

  Future<void> getPresentOutMonth(
    int id,
    int month,
    int year,
    Emitter<HomeState> emit,
  ) async {
    final result = await homeRepository.getPresentOutMonth(id, month, year);
    result.fold(
      (l) => emit(HomeError(l.message!)),
      (r) => emit(
        HomeLoaded(
          presentOutMonth: r[0],
        ),
      ),
    );
  }

  Future<void> getPresentInYear(
    int id,
    int year,
    Emitter<HomeState> emit,
  ) async {
    final result = await homeRepository.getPresentInYear(id, year);
    result.fold(
      (l) => emit(HomeError(l.message!)),
      (r) => emit(
        HomeLoaded(
          presentInYear: r[0],
        ),
      ),
    );
  }

  Future<void> getPresentOutYear(
    int id,
    int year,
    Emitter<HomeState> emit,
  ) async {
    final result = await homeRepository.getPresentOutYear(id, year);
    result.fold(
      (l) => emit(HomeError(l.message!)),
      (r) => emit(
        HomeLoaded(
          presentOutYear: r[0],
        ),
      ),
    );
  }
}
