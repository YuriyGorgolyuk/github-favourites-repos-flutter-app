import 'package:flutter/material.dart';
import 'package:github_favourites/presentation/bloc/favourites_list_cubit/favourites_list_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavouritesScreen extends StatelessWidget {
  const FavouritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavouritesListCubit, FavouritesListState>(
      builder: (context, state) {
        return Placeholder();
      },
    );
  }
}
