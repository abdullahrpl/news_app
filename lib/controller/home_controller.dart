import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:news_app/lib.dart'; // Sesuaikan dengan path ke Api kamu

class HomeController extends GetxController with GetTickerProviderStateMixin {
  // SEARCH FUNCTION
  final TextEditingController searchController = TextEditingController();
  final RxString searchText = ''.obs;

  final RxList<Map<String, dynamic>> _allNews = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> filteredNews = <Map<String, dynamic>>[].obs;
  final RxBool isLoading = false.obs;

  late AnimationController listAnimationController;
  late AnimationController searchAnimationController;

  // CATEGORY
  final RxString selectedCategory = ''.obs;

  @override
  void onInit() {
    super.onInit();
    listAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    searchAnimationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    fetchNews(selectedCategory.value);

    // Sinkronkan TextEditingController ke RxString
    searchController.addListener(() {
      searchText.value = searchController.text;
      applySearch(searchController.text);
    });

    Future.delayed(const Duration(milliseconds: 300), () {
      searchAnimationController.forward();
    });
  }

  @override
  void onClose() {
    listAnimationController.dispose();
    searchAnimationController.dispose();
    searchController.dispose();
    super.onClose();
  }

  Future<void> fetchNews(String type) async {
    isLoading.value = true;
    final data = await Api().getApi(type: type);
    _allNews.value = data;
    filteredNews.value = data;
    isLoading.value = false;

    listAnimationController.reset();
    listAnimationController.forward();
  }

  void applySearch(String query) {
    if (query.isEmpty) {
      filteredNews.value = _allNews;
    } else {
      filteredNews.value = _allNews.where((item) {
        final title = item['title'].toString().toLowerCase();
        final snippet = item['contentSnippet'].toString().toLowerCase();
        final search = query.toLowerCase();
        return title.contains(search) || snippet.contains(search);
      }).toList();
    }
  }

  Map<String, dynamic> getCategoryStyle(String category) {
    switch (category.toLowerCase()) {
      case 'nasional':
        return {
          'color': const Color(0xFFDC2626),
          'icon': Icons.flag_rounded,
          'label': 'Indonesia',
        };
      case 'internasional':
        return {
          'color': const Color(0xFF2563EB),
          'icon': Icons.public_rounded,
          'label': 'Global',
        };
      case 'ekonomi':
        return {
          'color': const Color(0xFF059669),
          'icon': Icons.trending_up_rounded,
          'label': 'Ekonomi',
        };
      case 'olahraga':
        return {
          'color': const Color(0xFFD97706),
          'icon': Icons.sports_soccer_rounded,
          'label': 'Olahraga',
        };
      case 'teknologi':
        return {
          'color': const Color(0xFF7C3AED),
          'icon': Icons.computer_rounded,
          'label': 'Teknologi',
        };
      case 'hiburan':
        return {
          'color': const Color(0xFFDB2777),
          'icon': Icons.movie_rounded,
          'label': 'Hiburan',
        };
      case 'gaya-hidup':
        return {
          'color': const Color(0xFF0891B2),
          'icon': Icons.shopping_bag_rounded,
          'label': 'Gaya Hidup',
        };
      default:
        return {
          'color': const Color(0xFF475569),
          'icon': Icons.article_rounded,
          'label': 'News',
        };
    }
  }

  void selectCategory(String type) {
    selectedCategory.value = type;
    fetchNews(type);
  }

  String formatDate(String date) {
    DateTime dateTime = DateTime.parse(date);
    return DateFormat('dd MMM yyyy, HH:mm').format(dateTime);
  }
}
