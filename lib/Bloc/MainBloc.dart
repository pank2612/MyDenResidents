
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:residents/Bloc/ConnectivityBloc.dart';

import 'AuthBloc.dart';

class MainBloc{
  static List<BlocProvider> allBlocs(){
    return [
      BlocProvider<ConnectivityBloc>(
        create:(_) => ConnectivityBloc(),
      ),
      BlocProvider<AuthBloc>(
        create:(_) => AuthBloc(),
      ),
    ];
  }
}