import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:spa_mobile/core/network/connection_checker.dart';
import 'package:spa_mobile/core/network/network.dart';
import 'package:spa_mobile/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:spa_mobile/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:spa_mobile/features/auth/domain/repository/auth_repository.dart';
import 'package:spa_mobile/features/auth/domain/usecases/login.dart';
import 'package:spa_mobile/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:spa_mobile/features/auth/presentation/cubit/password_confirm_cubit.dart';
import 'package:spa_mobile/features/auth/presentation/cubit/password_cubit.dart';
import 'package:spa_mobile/features/auth/presentation/cubit/policy_term_cubit.dart';
import 'package:spa_mobile/features/auth/presentation/cubit/remember_me_cubit.dart';

part "init_dependencies.main.dart";