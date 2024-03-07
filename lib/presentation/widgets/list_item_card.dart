import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:github_favourites/config/constants.dart';
import 'package:github_favourites/config/git_favouries_theme.dart';
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
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Handle long repository name as it's in the design
            Flexible(
              child: Text(
                widget.repo.name!,
                overflow: TextOverflow.clip,
                maxLines: 1,
                softWrap: false,
              ),
            ),
            BlocBuilder<GithubReposBloc, GithubReposState>(
              builder: (context, state) {
                return IconButton(
                  style: GitFavouritesTheme.buttonWithTransparentBG,
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
                    // In production I will use the cubit to handle the star status toggling properly
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
          ],
        ),
      ),
    );
  }
}
