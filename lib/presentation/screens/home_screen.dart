import 'package:flutter/material.dart';
import 'package:github_favourites/presentation/bloc/github_repos_bloc.dart/github_repos_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Github repos list"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              flex: 1,
              fit: FlexFit.loose,
              child: BlocBuilder<GithubReposBloc, GithubReposState>(
                builder: (context, state) {
                  if (state is GithubReposError) {
                    return Text(
                      state.message,
                      softWrap: true,
                      maxLines: 2,
                    );
                  }
                  return Text("Your favourites Git repos");
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
