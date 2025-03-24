import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:spa_mobile/core/local_storage/local_storage.dart';
import 'package:spa_mobile/core/logger/logger.dart';
import 'package:spa_mobile/features/home/data/models/branch_distance_model.dart';
import 'package:spa_mobile/features/home/domain/usecases/get_distance.dart';

part 'nearest_branch_event.dart';
part 'nearest_branch_state.dart';

class NearestBranchBloc extends Bloc<NearestBranchEvent, NearestBranchState> {
  final GetDistance _getDistance;

  NearestBranchBloc({required GetDistance getDistance})
      : _getDistance = getDistance,
        super(NearestBranchInitial()) {
    on<GetNearestBranchEvent>(_onGetNearestBranch);
  }

  Future<void> _onGetNearestBranch(GetNearestBranchEvent event, Emitter<NearestBranchState> emit) async {
    emit(NearestBranchLoading());

    final result = await _getDistance(event.params);
    await result.fold((failure) async {
      emit(NearestBranchError(failure.message));
    }, (data) async {
      final branchesWithDistance = event.params.branches.asMap().entries.map((entry) {
        final index = entry.key;
        final branch = entry.value;
        final distance = data[index];

        return BranchDistanceModel(
          branchModel: branch,
          distance: distance,
        );
      }).toList();

      final nearestBranch = branchesWithDistance.reduce((a, b) {
        return a.distance.value < b.distance.value ? a : b;
      });
      emit(NearestBranchLoaded(branches: branchesWithDistance, nearestBranch: nearestBranch));

      if (event.isFirst) {
        await LocalStorage.saveData(LocalStorageKey.defaultBranch, nearestBranch.branchModel.branchId.toString());
        await LocalStorage.saveData(LocalStorageKey.branchInfo, jsonEncode(nearestBranch.branchModel));
      }
    });
  }
}
