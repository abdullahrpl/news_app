import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_app/controller/detail_controller.dart';
import 'package:url_launcher/url_launcher.dart'; // Tambahkan ini untuk membuka URL

class DetailScreen extends StatelessWidget {
  final Map<String, dynamic> newsDetail;
  const DetailScreen({super.key, required this.newsDetail});

  @override
  Widget build(BuildContext context) {
    // Menggunakan Get.put dengan argumen untuk newsDetail
    final DetailController controller = Get.put(DetailController(newsDetail: newsDetail));

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 320,
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.transparent,
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: 'news-image-${controller.newsDetail['title']}',
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(32),
                        bottomRight: Radius.circular(32),
                      ),
                      child: Image.network(
                        controller.newsDetail['image']['large'],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            decoration: const BoxDecoration(
                              color: Color(0xFFE2E8F0),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(32),
                                bottomRight: Radius.circular(32),
                              ),
                            ),
                            child: const Icon(
                              Icons.image_not_supported_outlined,
                              color: Color(0xFF64748B),
                              size: 64,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(32),
                        bottomRight: Radius.circular(32),
                      ),
                      color: Color(0x40000000), // Overlay gelap untuk teks lebih jelas
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: AnimatedBuilder(
              animation: Listenable.merge([
                controller.fadeAnimationController,
                controller.slideAnimationController,
                controller.scaleAnimationController,
              ]),
              builder: (context, child) {
                return FadeTransition(
                  opacity: controller.fadeAnimation,
                  child: SlideTransition(
                    position: controller.slideAnimation,
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ScaleTransition(
                            scale: controller.scaleAnimation,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF3B82F6), // Warna biru untuk tanggal
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.schedule_rounded,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    controller.formatDate(controller.newsDetail['isoDate']),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            controller.newsDetail['title'],
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 32,
                              color: Color(0xFF0F172A),
                              height: 1.2,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 24),
                          ScaleTransition(
                            scale: controller.scaleAnimation,
                            child: Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF64748B).withOpacity(0.08),
                                    spreadRadius: 0,
                                    blurRadius: 24,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Text(
                                controller.newsDetail['contentSnippet'],
                                style: const TextStyle(
                                  color: Color(0xFF475569),
                                  fontSize: 17,
                                  height: 1.7,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                          // Tombol "Read Full Article"
                          TweenAnimationBuilder<double>(
                            duration: const Duration(milliseconds: 200),
                            tween: Tween(begin: 1.0, end: 1.0), // Animasi ini mungkin tidak terlalu terlihat jika begin dan end sama
                            builder: (context, scale, child) {
                              return Transform.scale(
                                scale: scale,
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1E293B),
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF1E293B).withOpacity(0.24),
                                        spreadRadius: 0,
                                        blurRadius: 16,
                                        offset: const Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(16),
                                      onTap: () async {
                                        final url = controller.newsDetail['link'];
                                        if (url != null && await canLaunchUrl(Uri.parse(url))) {
                                          await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                                        } else {
                                          Get.snackbar(
                                            'Error',
                                            'Could not open the link',
                                            snackPosition: SnackPosition.BOTTOM,
                                            backgroundColor: Colors.redAccent,
                                            colorText: Colors.white,
                                          );
                                        }
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 24,
                                          vertical: 18,
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.open_in_new_rounded,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                            SizedBox(width: 12),
                                            Text(
                                              'Read Full Article',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 20),
                          // Tampilan link sumber berita
                          FadeTransition(
                            opacity: controller.fadeAnimation,
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: const Color(0xFFE2E8F0),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.link_rounded,
                                    color: Color(0xFF64748B),
                                    size: 20,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      controller.newsDetail['link'],
                                      style: const TextStyle(
                                        color: Color(0xFF64748B),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}