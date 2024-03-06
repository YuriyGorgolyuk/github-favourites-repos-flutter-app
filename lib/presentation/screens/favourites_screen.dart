import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:github_favourites/presentation/bloc/favourites_list_cubit/favourites_list_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_favourites/presentation/widgets/screen_message.dart';

class FavouritesScreen extends StatefulWidget {
  const FavouritesScreen({super.key});

  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favourites repos list"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: BlocBuilder<FavouritesListCubit, FavouritesListState>(
        builder: (context, state) {
          if (state.status == FavouritesListStatus.loading) {
            return const Center(
              child: CupertinoActivityIndicator(),
            );
          } else if (state.status == FavouritesListStatus.loaded) {
            return ListView.builder(
              itemCount: state.favouriteRepos.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(state.favouriteRepos[index].name!),
                );
              },
            );
          } else {
            return ScreenMessage(message: state.message);
          }
        },
      ),
    );
  }
}
