import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:retro/appearance/inner_shadow.dart';
import 'package:retro/appearance/skins.dart';
import 'package:retro/blocs/player/player_bloc.dart';
import 'package:retro/blocs/player/player_event.dart';
import 'package:retro/blocs/player/player_state.dart';
import 'package:retro/blocs/theme/theme_bloc.dart';
import 'package:retro/blocs/theme/theme_state.dart';
import 'package:retro/core.dart';
import 'package:retro/ipod_menu_widget/ipod_menu_widget.dart';
import 'package:retro/main.dart';
import 'package:retro/helpers/size_helpers.dart';
import 'package:retro/music_models/playback_state/playback_state_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:holding_gesture/holding_gesture.dart';

final IPodMenuWidgetState musicControls = new IPodMenuWidgetState();
final IPodState home = new IPodState();



Widget fastForward(context) {
  return Container(
    child: IconButton(
        icon: Icon(
          SFSymbols.forward_end_alt_fill,
          color: controlsColor,
        ),
        iconSize: 25,
        onPressed: () async {
          HapticFeedback.mediumImpact();
          musicControls.playNextSong(context);

        }),
    alignment: Alignment.centerRight,
    //margin: EdgeInsets.only(right: 30),
  );
}

Widget fastRewind(context) {
  return Container(
    child: IconButton(
        icon: Icon(
          SFSymbols.backward_end_alt_fill,
          color: controlsColor,
        ),
        iconSize: 25,
        onPressed: () async {
          HapticFeedback.mediumImpact();
          musicControls.playPrevSong(context);
        }),
    alignment: Alignment.centerLeft,
    //margin: EdgeInsets.only(left: 30),
  );
}

Widget playButton(context) {
  return BlocBuilder<PlayerBloc, PlayerState>(
      builder: (BuildContext ctx, PlayerState state) {
        final bool isPlaying = state is NowPlayingState &&
          state.playbackState == PlaybackStateModel.playing;
            return Container(
              child: 
                IconButton(
                  icon: Icon(
                    SFSymbols.playpause_fill,
                    size: 25,
                    color: controlsColor,
                  ),
                    onPressed: () async {
                      HapticFeedback.mediumImpact();
                      BlocProvider.of<PlayerBloc>(context)
                            .add(isPlaying ? PauseCalled() : PlayCalled());
                    },
                ),
              alignment: Alignment.bottomCenter,
              margin: EdgeInsets.only(bottom: 5),
            );
          });
}


Widget selectButton() {
  return BlocBuilder<ThemeBloc, ThemeState>(
    buildWhen: (ThemeState prev, ThemeState cur) =>
        prev.skinTheme != cur.skinTheme,
    builder: (BuildContext context, ThemeState state) {
      return InnerShadow(
        blur: 2,
        color: const Color(0xff707070),
        offset: const Offset(0, 0),
        child: Container(
          constraints: BoxConstraints(maxWidth: 120, maxHeight: 120),
          width: displayWidth(context) * 0.25,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(getSkin(state)),
              fit: BoxFit.none,
            ),
            shape: BoxShape.circle, 
          ),
      ));
    },
  );
}