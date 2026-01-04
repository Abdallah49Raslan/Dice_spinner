// ignore_for_file: depend_on_referenced_packages
import 'package:dice/app/my_dice_app.dart';
import 'package:dice/features/normal_dice/cubit/dice_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


void main() {
  runApp(
    BlocProvider(
      create: (_) => DiceCubit(),
      child: const MyDiceApp(),
    ),
  );
}
