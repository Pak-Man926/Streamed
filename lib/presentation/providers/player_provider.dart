import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/match.dart';

final selectedPlayerMatchProvider = StateProvider<Match?>((ref) => null);

final isPlayerPlayingProvider = StateProvider<bool>((ref) => true);

final isPlayerFullscreenProvider = StateProvider<bool>((ref) => false);
