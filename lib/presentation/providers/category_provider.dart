import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedCategoryProvider = StateProvider<String>((ref) => 'all');

final selectedScheduleDayProvider = StateProvider<int>((ref) => 0);

final liveCarouselIndexProvider = StateProvider<int>((ref) => 0);
