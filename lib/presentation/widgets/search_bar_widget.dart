import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:github_favourites/config/constants.dart';
import 'package:github_favourites/presentation/bloc/github_repos_bloc.dart/github_repos_bloc.dart';

extension Debounce on Timer? {
  void restart(Duration duration, VoidCallback action) {
    if (this?.isActive ?? false) this?.cancel();
    Timer(duration, action);
  }
}

class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget({super.key});

  @override
  State<SearchBarWidget> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBarWidget> {
  Timer? debounce;
  final TextEditingController controller = TextEditingController();
  final FocusNode focusNode = FocusNode();
  static const String hintText = 'Search';
  String helpText = '';

  GithubReposBloc get bloc => BlocProvider.of<GithubReposBloc>(context);

  void onSearch() {
    if (debounce?.isActive ?? false) debounce?.cancel();
    final query = controller.text;
    if (query.isNotEmpty && query.length > 2) {
      bloc.add(SearchGithubReposByName(query));
    } else if (controller.text.isEmpty) {
      setState(() {
        helpText = '';
      });
    } else {
      setState(() {
        helpText = 'Please enter at least 3 characters';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    controller.text = bloc.state.query;
  }

  InputDecoration _inputDecoration(ThemeData theme) {
    return InputDecoration(
      hintText: hintText,
      errorText: helpText == '' ? null : helpText,
      prefixIcon: Padding(
        padding: const EdgeInsets.only(right: 10, left: 16),
        child: SvgPicture.asset(SvgIcon.search, width: 24.0, height: 24.0),
      ),
      fillColor: focusNode.hasFocus
          ? theme.colorScheme.secondaryContainer
          : theme.colorScheme.background,
      suffixIcon: controller.text.isNotEmpty ? clearButton(theme) : null,
    );
  }

  Widget clearButton(ThemeData theme) {
    return IconButton(
      splashRadius: 40.0,
      splashColor: theme.colorScheme.secondary,
      icon: SvgPicture.asset(SvgIcon.close),
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.all(
          theme.colorScheme.secondary,
        ),
      ),
      onPressed: () {
        if (debounce?.isActive ?? false) debounce?.cancel();
        setState(() => helpText = '');
        controller.clear();
        bloc.add(const ClearSearchField());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      // need 80.0 to show error message
      height: 80.0,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        textAlignVertical: TextAlignVertical.center,
        decoration: _inputDecoration(theme),
        onTap: () => focusNode.requestFocus(),
        onChanged: (value) {
          setState(() => controller.text = value);
          if (debounce?.isActive ?? false) debounce?.cancel();
          debounce = Timer(const Duration(milliseconds: 3000), onSearch);
        },
        onSubmitted: (value) => onSearch(),
        textInputAction: TextInputAction.search,
      ),
    );
  }
}
