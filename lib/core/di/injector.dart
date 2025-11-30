import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:live_shop/data/datasources/local/cart_local_datasource.dart';
import 'package:live_shop/data/datasources/remote/auth_remote_datasource.dart';
import 'package:live_shop/data/datasources/remote/cart_remote_datasource.dart';
import 'package:live_shop/data/datasources/remote/chat_remote_datasource.dart';
import 'package:live_shop/data/datasources/remote/orders_remote_datasource.dart';
import 'package:live_shop/data/datasources/remote/session_remote_datasource.dart';
import 'package:live_shop/data/repositories/auth_repository_impl.dart';
import 'package:live_shop/data/repositories/cart_repository_impl.dart';
import 'package:live_shop/data/repositories/chat_repository_impl.dart';
import 'package:live_shop/data/repositories/orders_repository_impl.dart';
import 'package:live_shop/data/repositories/session_repository_impl.dart';
import 'package:live_shop/domain/repositories/auth_repository.dart';
import 'package:live_shop/domain/repositories/cart_repository.dart';
import 'package:live_shop/domain/repositories/chat_repository.dart';
import 'package:live_shop/domain/repositories/orders_repository.dart';
import 'package:live_shop/domain/repositories/session_repository.dart';
import 'package:live_shop/presentation/blocs/auth/auth_bloc.dart';
import 'package:live_shop/presentation/blocs/cart/cart_cubit.dart';
import 'package:live_shop/presentation/blocs/chat/chat_cubit.dart';
import 'package:live_shop/presentation/blocs/orders/orders_cubit.dart';
import 'package:live_shop/presentation/blocs/session/session_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupInjector() async {
  final sharedPreferences = await SharedPreferences.getInstance();

  getIt
    ..registerLazySingleton<SharedPreferences>(() => sharedPreferences)
    ..registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance)
    ..registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance)
    ..registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(getIt<FirebaseAuth>()),
    )
    ..registerLazySingleton<SessionRemoteDataSource>(
      () => SessionRemoteDataSourceImpl(getIt<FirebaseFirestore>()),
    )
    ..registerLazySingleton<ChatRemoteDataSource>(
      () => ChatRemoteDataSourceImpl(getIt<FirebaseFirestore>()),
    )
    ..registerLazySingleton<CartRemoteDataSource>(
      () => CartRemoteDataSourceImpl(getIt<FirebaseFirestore>()),
    )
    ..registerLazySingleton<OrdersRemoteDataSource>(
      () => OrdersRemoteDataSourceImpl(getIt<FirebaseFirestore>()),
    )
    ..registerLazySingleton<CartLocalDataSource>(
      () => CartLocalDataSourceImpl(getIt<SharedPreferences>()),
    )
    ..registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(getIt()),
    )
    ..registerLazySingleton<SessionRepository>(
      () => SessionRepositoryImpl(getIt()),
    )
    ..registerLazySingleton<ChatRepository>(
      () => ChatRepositoryImpl(getIt()),
    )
    ..registerLazySingleton<CartRepository>(
      () => CartRepositoryImpl(
        remoteDataSource: getIt(),
        localDataSource: getIt(),
      ),
    )
    ..registerLazySingleton<OrdersRepository>(
      () => OrdersRepositoryImpl(getIt()),
    )
    ..registerFactory(
      () => AuthBloc(repo: getIt<AuthRepository>()),
    )
    ..registerFactory(
      () => SessionBloc(repo: getIt<SessionRepository>()),
    )
    ..registerFactory(
      () => ChatCubit(repo: getIt<ChatRepository>()),
    )
    ..registerFactory(
      () => CartCubit(repo: getIt<CartRepository>()),
    )
    ..registerFactory(
      () => OrdersCubit(repo: getIt<OrdersRepository>()),
    );
}
