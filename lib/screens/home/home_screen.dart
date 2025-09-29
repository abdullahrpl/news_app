import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_app/controller/home_controller.dart';
import 'package:news_app/screens/detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.put(HomeController());

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        toolbarHeight: 120,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'What\'s New',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 36,
                color: Color(0xFF0F172A),
                letterSpacing: -1,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Stay updated with latest news',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF64748B),
                fontWeight: FontWeight.w500,
                letterSpacing: 0,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          AnimatedBuilder(
            animation: controller.searchAnimationController,
            builder: (context, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, -1),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: controller.searchAnimationController,
                  curve: Curves.easeOutCubic,
                )),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF64748B).withOpacity(0.08),
                          spreadRadius: 0,
                          blurRadius: 16,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: controller.searchController,
                      decoration: InputDecoration(
                        hintText: 'Search news...',
                        hintStyle: const TextStyle(
                          color: Color(0xFF94A3B8),
                          fontWeight: FontWeight.w500,
                        ),
                        prefixIcon: const Icon(
                          Icons.search_rounded,
                          color: Color(0xFF64748B),
                          size: 20,
                        ),
                        // ✅ sekarang pakai searchText (obs)
                        suffixIcon: Obx(
                          () => controller.searchText.value.isNotEmpty
                              ? IconButton(
                                  onPressed: () {
                                    controller.searchController.clear();
                                    controller.applySearch('');
                                  },
                                  icon: const Icon(
                                    Icons.clear_rounded,
                                    color: Color(0xFF64748B),
                                    size: 20,
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          Container(
            height: 80,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  spreadRadius: 0,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _categoryButton(controller, 'Semua', ''),
                  _categoryButton(controller, 'Indonesia', 'nasional'),
                  _categoryButton(controller, 'Global', 'internasional'),
                  _categoryButton(controller, 'Ekonomi', 'ekonomi'),
                  _categoryButton(controller, 'Olahraga', 'olahraga'),
                  _categoryButton(controller, 'Teknologi', 'teknologi'),
                  _categoryButton(controller, 'Hiburan', 'hiburan'),
                  _categoryButton(controller, 'Gaya Hidup', 'gaya-hidup'),
                ],
              ),
            ),
          ),
          Expanded(
            child: Obx(
              () => controller.isLoading.value
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF1E293B),
                      ),
                    )
                  : controller.filteredNews.isEmpty
                      ? const Center(
                          child: Text(
                            'No news found',
                            style: TextStyle(
                              color: Color(0xFF64748B),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
                      : AnimatedBuilder(
                          animation: controller.listAnimationController,
                          builder: (context, child) {
                            return ListView.builder(
                              padding: const EdgeInsets.all(20),
                              itemCount: controller.filteredNews.length,
                              itemBuilder: (context, index) {
                                final item = controller.filteredNews[index];
                                final categoryStyle =
                                    controller.getCategoryStyle(
                                  controller.selectedCategory.value.isEmpty
                                      ? 'default'
                                      : controller.selectedCategory.value,
                                );

                                final animationDelay = index * 0.1;
                                final slideAnimation = Tween<Offset>(
                                  begin: const Offset(1, 0),
                                  end: Offset.zero,
                                ).animate(CurvedAnimation(
                                  parent: controller.listAnimationController,
                                  curve: Interval(
                                    animationDelay,
                                    (animationDelay + 0.3).clamp(0.0, 1.0),
                                    curve: Curves.easeOutCubic,
                                  ),
                                ));

                                final fadeAnimation = Tween<double>(
                                  begin: 0.0,
                                  end: 1.0,
                                ).animate(CurvedAnimation(
                                  parent: controller.listAnimationController,
                                  curve: Interval(
                                    animationDelay,
                                    (animationDelay + 0.3).clamp(0.0, 1.0),
                                    curve: Curves.easeIn,
                                  ),
                                ));

                                return SlideTransition(
                                  position: slideAnimation,
                                  child: FadeTransition(
                                    opacity: fadeAnimation,
                                    child: Container(
                                      margin: const EdgeInsets.only(bottom: 20),
                                      child: Material(
                                        elevation: 4,
                                        borderRadius: BorderRadius.circular(16),
                                        shadowColor:
                                            Colors.black.withOpacity(0.06),
                                        child: InkWell(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          onTap: () {
                                            Get.to(
                                              () => DetailScreen(
                                                  newsDetail: item),
                                              transition: Transition
                                                  .rightToLeftWithFade,
                                              duration: const Duration(
                                                  milliseconds: 500),
                                            );
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(20),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  flex: 2,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                          horizontal: 12,
                                                          vertical: 6,
                                                        ),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: categoryStyle[
                                                              'color'],
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      16),
                                                        ),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Icon(
                                                              categoryStyle[
                                                                  'icon'],
                                                              size: 14,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            const SizedBox(
                                                                width: 6),
                                                            Text(
                                                              categoryStyle[
                                                                  'label'],
                                                              style:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                          height: 12),
                                                      Text(
                                                        item['title'],
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w800,
                                                          fontSize: 18,
                                                          color:
                                                              Color(0xFF0F172A),
                                                          height: 1.3,
                                                          letterSpacing: -0.2,
                                                        ),
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                      const SizedBox(
                                                          height: 8),
                                                      Text(
                                                        item['contentSnippet'],
                                                        style: const TextStyle(
                                                          color:
                                                              Color(0xFF64748B),
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 14,
                                                          height: 1.5,
                                                        ),
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                      const SizedBox(
                                                          height: 12),
                                                      Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                          horizontal: 10,
                                                          vertical: 6,
                                                        ),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: const Color(
                                                              0xFFF1F5F9),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      16),
                                                        ),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            const Icon(
                                                              Icons
                                                                  .schedule_rounded,
                                                              size: 12,
                                                              color: Color(
                                                                  0xFF64748B),
                                                            ),
                                                            const SizedBox(
                                                                width: 4),
                                                            Text(
                                                              controller
                                                                  .formatDate(
                                                                      item[
                                                                          'isoDate']),
                                                              style:
                                                                  const TextStyle(
                                                                color: Color(
                                                                    0xFF64748B),
                                                                fontSize: 11,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(width: 16),
                                                Hero(
                                                  tag:
                                                      'news-image-${item['title']}',
                                                  child: Container(
                                                    width: 100,
                                                    height: 170,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.black
                                                              .withOpacity(0.1),
                                                          spreadRadius: 0,
                                                          blurRadius: 8,
                                                          offset: const Offset(
                                                              0, 2),
                                                        ),
                                                      ],
                                                    ),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16),
                                                      child: Image.network(
                                                        item['image']['large'],
                                                        fit: BoxFit.cover,
                                                        errorBuilder: (context,
                                                            error, stackTrace) {
                                                          return Container(
                                                            decoration:
                                                                const BoxDecoration(
                                                              color: Color(
                                                                  0xFFE2E8F0),
                                                            ),
                                                            child:
                                                                const Icon(
                                                              Icons
                                                                  .image_not_supported_outlined,
                                                              color: Color(
                                                                  0xFF64748B),
                                                              size: 32,
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _categoryButton(HomeController controller, String label, String type) {
    return Obx(() {
      final isSelected = controller.selectedCategory.value == type;
      return Container(
        margin: const EdgeInsets.only(right: 12),
        child: Material(
          elevation: isSelected ? 8 : 2,
          borderRadius: BorderRadius.circular(16),
          shadowColor: isSelected
              ? const Color(0xFF1E293B).withOpacity(0.2)
              : Colors.black.withOpacity(0.05),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: isSelected ? const Color(0xFF1E293B) : Colors.white,
              border: Border.all(
                color:
                    isSelected ? Colors.transparent : const Color(0xFFE2E8F0),
                width: 1,
              ),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                controller.selectCategory(type);
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Text(
                  label,
                  style: TextStyle(
                    color: isSelected ? Colors.white : const Color(0xFF475569),
                    fontWeight:
                        isSelected ? FontWeight.w700 : FontWeight.w600,
                    fontSize: 14,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
