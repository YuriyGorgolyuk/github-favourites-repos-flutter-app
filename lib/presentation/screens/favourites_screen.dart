import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:github_favourites/config/constants.dart';
import 'package:github_favourites/presentation/bloc/favourites_list_cubit/favourites_list_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_favourites/presentation/widgets/list_item_card.dart';
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
        elevation: 1,
        // can be updated to match with the design file. Looks nicer with tint as for me
        // surfaceTintColor: Theme.of(context).colorScheme.background,
        shadowColor: Theme.of(context).colorScheme.secondary,
        toolbarHeight: 64.0,
        leadingWidth: 60.0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0, bottom: 10, top: 10),
          child: SizedBox(
            width: 44,
            height: 44,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Constants.horizontalPadding,
          vertical: Constants.verticalPadding,
        ),
        child: Column(
          children: [
            BlocBuilder<FavouritesListCubit, FavouritesListState>(
              builder: (context, state) {
                if (state.status == FavouritesListStatus.loading) {
                  return const Center(
                    child: CupertinoActivityIndicator(),
                  );
                } else if (state.status == FavouritesListStatus.loaded) {
                  return Expanded(
                    child: Scrollbar(
                      trackVisibility: true,
                      thickness: 4,
                      radius: const Radius.circular(2),
                      child: ListView.builder(
                        itemCount: state.favouriteRepos.length,
                        itemBuilder: (context, index) {
                          final repo = state.favouriteRepos[index];
                          return ListItemCard(repo: repo);
                        },
                      ),
                    ),
                  );
                } else if (state.status == FavouritesListStatus.error) {
                  return ScreenMessage(message: state.message);
                } else {
                  return const SizedBox();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
