import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:github_favourites/config/constants.dart';
import 'package:github_favourites/domain/entities/repository_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_favourites/presentation/bloc/github_repos_bloc.dart/github_repos_bloc.dart';

class ListItemCard extends StatefulWidget {
  const ListItemCard({
    super.key,
    required this.repo,
  });

  final RepositoryEntity repo;

  @override
  State<ListItemCard> createState() => _ListItemCardState();
}

class _ListItemCardState extends State<ListItemCard> {
  bool isStarred = false;

  @override
  void initState() {
    super.initState();
    isStarred = widget.repo.isStarred!;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: ListTile(
        title: Text(widget.repo.name!),
        trailing: BlocBuilder<GithubReposBloc, GithubReposState>(
          builder: (context, state) {
            return IconButton(
              icon: widget.repo.isStarred!
                  ? SvgPicture.asset(
                      SvgIcon.favouriteActive,
                      colorFilter: ColorFilter.mode(
                        Theme.of(context).colorScheme.primary,
                        BlendMode.srcIn,
                      ),
                    )
                  : SvgPicture.asset(
                      SvgIcon.favouriteDefault,
                      colorFilter: ColorFilter.mode(
                        Theme.of(context).colorScheme.tertiary,
                        BlendMode.srcIn,
                      ),
                    ),
              onPressed: () {
                // realized that didn't count this requirements initially, and I ran out of time to implement it properly.
                ModalRoute.of(context)!.settings.name == '/favourites-repos'
                    ? Navigator.pop(context)
                    : null;

                BlocProvider.of<GithubReposBloc>(context).add(
                  StarStatusToggled(widget.repo),
                );
                setState(() {
                  isStarred = !isStarred;
                });
              },
            );
          },
        ),
        // contentPadding: const EdgeInsets.fromLTRB(12.0, 0, 0, 0),
      ),
    );
  }
}
