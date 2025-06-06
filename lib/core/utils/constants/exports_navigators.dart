import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spa_mobile/core/common/inherited/appointment_data.dart';
import 'package:spa_mobile/core/common/inherited/mix_data.dart';
import 'package:spa_mobile/core/common/inherited/purchasing_data.dart';
import 'package:spa_mobile/core/common/inherited/routine_data.dart';
import 'package:spa_mobile/core/common/model/branch_model.dart';
import 'package:spa_mobile/core/common/screens/payment_web_view.dart';
import 'package:spa_mobile/core/common/screens/redirect_screen.dart';
import 'package:spa_mobile/core/common/screens/success_screen.dart';
import 'package:spa_mobile/core/logger/logger.dart';
import 'package:spa_mobile/features/analysis_skin/data/model/routine_model.dart';
import 'package:spa_mobile/features/analysis_skin/data/model/skin_health_model.dart';
import 'package:spa_mobile/features/analysis_skin/presentation/blocs/list_order_routine/list_order_routine_bloc.dart';
import 'package:spa_mobile/features/analysis_skin/presentation/blocs/list_product_branch/list_product_branch_bloc.dart';
import 'package:spa_mobile/features/analysis_skin/presentation/blocs/list_routine/list_routine_bloc.dart';
import 'package:spa_mobile/features/analysis_skin/presentation/screens/add_to_routine_screen.dart';
import 'package:spa_mobile/features/analysis_skin/presentation/screens/analysing_image_screen.dart';
import 'package:spa_mobile/features/analysis_skin/presentation/screens/analysis_result_screen.dart';
import 'package:spa_mobile/features/analysis_skin/presentation/screens/basic_screen_image.dart';
import 'package:spa_mobile/features/analysis_skin/presentation/screens/book_routine_screen.dart';
import 'package:spa_mobile/features/analysis_skin/presentation/screens/checkout_routine_screen.dart';
import 'package:spa_mobile/features/analysis_skin/presentation/screens/confirm_customize_screen.dart';
import 'package:spa_mobile/features/analysis_skin/presentation/screens/customize_routine_screen.dart';
import 'package:spa_mobile/features/analysis_skin/presentation/screens/form_collect_data_screen.dart';
import 'package:spa_mobile/features/analysis_skin/presentation/screens/order_product_service_detail_screen.dart';
import 'package:spa_mobile/features/analysis_skin/presentation/screens/order_routine_detail.dart';
import 'package:spa_mobile/features/analysis_skin/presentation/screens/product_detail_with_branch.dart';
import 'package:spa_mobile/features/analysis_skin/presentation/screens/routine_detail_screen.dart';
import 'package:spa_mobile/features/analysis_skin/presentation/screens/routine_history_screen.dart';
import 'package:spa_mobile/features/analysis_skin/presentation/screens/routines_screen.dart';
import 'package:spa_mobile/features/analysis_skin/presentation/screens/select_time_screen.dart';
import 'package:spa_mobile/features/analysis_skin/presentation/screens/service_detail_with_branch.dart';
import 'package:spa_mobile/features/analysis_skin/presentation/screens/tracking_routine_screen.dart';
import 'package:spa_mobile/features/analysis_skin/presentation/screens/update_appointments_screen.dart';
import 'package:spa_mobile/features/analysis_skin/presentation/screens/update_appointments_time_screen.dart';
import 'package:spa_mobile/features/auth/presentation/cubit/password_confirm_cubit.dart';
import 'package:spa_mobile/features/auth/presentation/cubit/password_cubit.dart';
import 'package:spa_mobile/features/auth/presentation/cubit/password_match_cubit.dart';
import 'package:spa_mobile/features/auth/presentation/cubit/policy_term_cubit.dart';
import 'package:spa_mobile/features/auth/presentation/cubit/remember_me_cubit.dart';
import 'package:spa_mobile/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:spa_mobile/features/auth/presentation/screens/login_screen.dart';
import 'package:spa_mobile/features/auth/presentation/screens/on_boarding_screen.dart';
import 'package:spa_mobile/features/auth/presentation/screens/set_password_screen.dart';
import 'package:spa_mobile/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:spa_mobile/features/auth/presentation/screens/verify_screen.dart';
import 'package:spa_mobile/features/home/presentation/blocs/mix/mix_bloc.dart';
import 'package:spa_mobile/features/home/presentation/blocs/navigation_bloc.dart';
import 'package:spa_mobile/features/home/presentation/blocs/notification/notification_bloc.dart';
import 'package:spa_mobile/features/home/presentation/screens/chat_ai_screen.dart';
import 'package:spa_mobile/features/home/presentation/screens/chat_list_screen.dart';
import 'package:spa_mobile/features/home/presentation/screens/chat_screen.dart';
import 'package:spa_mobile/features/home/presentation/screens/notification_screen.dart';
import 'package:spa_mobile/features/home/presentation/screens/search_screen.dart';
import 'package:spa_mobile/features/home/presentation/widgets/navigator_menu.dart';
import 'package:spa_mobile/features/product/domain/usecases/create_order.dart';
import 'package:spa_mobile/features/product/presentation/screens/checkout_screen.dart';
import 'package:spa_mobile/features/product/presentation/screens/history_screen.dart';
import 'package:spa_mobile/features/product/presentation/screens/order_detail_screen.dart';
import 'package:spa_mobile/features/product/presentation/screens/product_detail_screen.dart';
import 'package:spa_mobile/features/product/presentation/screens/product_feedback_screen.dart';
import 'package:spa_mobile/features/product/presentation/screens/shipment_information_screen.dart';
import 'package:spa_mobile/features/service/data/model/service_model.dart';
import 'package:spa_mobile/features/service/presentation/bloc/category/list_category_bloc.dart';
import 'package:spa_mobile/features/service/presentation/bloc/list_appointment/list_appointment_bloc.dart';
import 'package:spa_mobile/features/service/presentation/bloc/staff_slot_working/staff_slot_working_bloc.dart';
import 'package:spa_mobile/features/service/presentation/screens/appointment_detail_screen.dart';
import 'package:spa_mobile/features/service/presentation/screens/checkout_service_screen.dart';
import 'package:spa_mobile/features/service/presentation/screens/confirm_payment_screen.dart';
import 'package:spa_mobile/features/service/presentation/screens/feedback_screen.dart';
import 'package:spa_mobile/features/service/presentation/screens/payment_screen.dart';
import 'package:spa_mobile/features/service/presentation/screens/review_update_screen.dart';
import 'package:spa_mobile/features/service/presentation/screens/select_service_screen.dart';
import 'package:spa_mobile/features/service/presentation/screens/select_specialist_screen.dart';
import 'package:spa_mobile/features/service/presentation/screens/select_time_screen.dart';
import 'package:spa_mobile/features/service/presentation/screens/service_detail_screen.dart';
import 'package:spa_mobile/features/service/presentation/screens/service_history_screen.dart';
import 'package:spa_mobile/features/service/presentation/screens/status_service_screen.dart';
import 'package:spa_mobile/features/product/presentation/screens/cart_screen.dart';
import 'package:spa_mobile/features/service/presentation/screens/table_appointments_screen.dart';
import 'package:spa_mobile/features/service/presentation/screens/update_specialist_screen.dart';
import 'package:spa_mobile/features/service/presentation/screens/update_time_screen.dart';
import 'package:spa_mobile/features/user/presentation/bloc/list_skinhealth/list_skinhealth_bloc.dart';
import 'package:spa_mobile/features/user/presentation/bloc/list_skinhealth/list_skinhealth_bloc.dart';
import 'package:spa_mobile/features/user/presentation/screens/profile_screen.dart';
import 'package:spa_mobile/features/user/presentation/screens/setting_screen.dart';
import 'package:spa_mobile/features/user/presentation/screens/statistic_screen.dart';
import 'package:spa_mobile/init_dependencies.dart';

part 'navigators.dart';
