import 'package:digit_components/digit_components.dart';
import 'package:digit_components/models/digit_row_card/digit_row_card_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:works_shg_app/blocs/auth/auth.dart';
import 'package:works_shg_app/router/app_router.dart';
import 'package:works_shg_app/utils/Constants/i18_key_constants.dart' as i18;
import 'package:works_shg_app/utils/global_variables.dart';

import '../blocs/app_initilization/app_initilization.dart';
import '../blocs/localization/app_localization.dart';
import '../blocs/localization/localization.dart';
import '../blocs/user/user_search.dart';

class SideBar extends StatefulWidget {
  final String module;
  const SideBar({super.key, this.module = 'rainmaker-common'});
  @override
  State<StatefulWidget> createState() {
    return _SideBar();
  }
}

class _SideBar extends State<SideBar> {
  List<DigitRowCardModel>? digitRowCardItems;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => afterViewBuild());
    super.initState();
  }

  afterViewBuild() async {
    digitRowCardItems = await GlobalVariables.getLanguages();
  }

  @override
  Widget build(BuildContext buildContext) {
    final theme = Theme.of(buildContext);

    return ScrollableContent(
      footer: const PoweredByDigit(),
      children: [
        BlocBuilder<UserSearchBloc, UserSearchState>(
            builder: (context, userState) {
          return !userState.loading && userState.userSearchModel != null
              ? SizedBox(
                  height: MediaQuery.of(buildContext).size.height / 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        userState.userSearchModel!.user!.first.name.toString(),
                        style: theme.textTheme.displayMedium,
                      ),
                      Text(
                        userState.userSearchModel!.user!.first.mobileNumber
                            .toString(),
                        style: theme.textTheme.labelSmall,
                      ),
                    ],
                  ),
                )
              : Loaders.circularLoader(context);
        }),
        DigitIconTile(
          title: AppLocalizations.of(context).translate(i18.common.home),
          icon: Icons.home,
          onPressed: () => context.router.replace(const HomeRoute()),
        ),
        DigitIconTile(
          title: AppLocalizations.of(context).translate(i18.common.language),
          icon: Icons.translate,
          content: Padding(
            padding: const EdgeInsets.all(16),
            child: BlocBuilder<AppInitializationBloc, AppInitializationState>(
              builder: (context, state) {
                return state.digitRowCardItems != null &&
                        state.isInitializationCompleted
                    ? DigitRowCard(
                        onChanged: (data) async {
                          context.read<AppInitializationBloc>().add(
                              AppInitializationSetupEvent(
                                  selectedLangIndex:
                                      data.value != 'en_IN' ? 1 : 0));

                          await AppLocalizations(
                            Locale(data.value.split('_').first,
                                data.value.split('_').last),
                          ).load();
                          context.read<LocalizationBloc>().add(
                              OnLoadLocalizationEvent(
                                  module: widget.module,
                                  tenantId: GlobalVariables.globalConfigObject!
                                      .globalConfigs!.stateTenantId
                                      .toString(),
                                  locale: data.value));
                          context.read<AppInitializationBloc>().add(
                              AppInitializationSetupEvent(
                                  selectedLangIndex:
                                      data.value != 'en_IN' ? 1 : 0));
                          await AppLocalizations(
                            Locale(data.value.split('_').first,
                                data.value.split('_').last),
                          ).load();
                        },
                        rowItems: state.digitRowCardItems
                            ?.map((e) => DigitRowCardModel.fromJson(e.toJson()))
                            .toList() as List<DigitRowCardModel>,
                        width: 85)
                    : const Text('');
              },
            ),
          ),
          onPressed: () {},
        ),
        DigitIconTile(
            title: AppLocalizations.of(context).translate(i18.common.logOut),
            icon: Icons.logout,
            onPressed: () {
              context.read<AuthBloc>().add(AuthLogoutEvent());
            }),
      ],
    );
  }
}
