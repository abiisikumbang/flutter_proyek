import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_cbt_tpa_app/controller/authentication_controller.dart';
import 'package:flutter_cbt_tpa_app/material.dart';
import 'package:flutter_cbt_tpa_app/widgets/main_menu.dart';
import 'package:flutter_cbt_tpa_app/widgets/sample_slider.dart';
import 'package:flutter_cbt_tpa_app/pages/daftar_sampah_page.dart';
import 'package:get/get.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  final AuthenticationController authenticationController = Get.find<AuthenticationController>();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.offset > 0 && _scrollController.offset < 50 && _scrollController.position.userScrollDirection == ScrollDirection.forward) {
      setState(() {});
      _scrollController.jumpTo(0);
      _refresh();
    }
  }

  Future<void> _refresh() async {
    await authenticationController.getUser();
  }

  @override
  Widget build(BuildContext context) {
    authenticationController.getUser();
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: RefreshIndicator(
          onRefresh: _refresh,
          child: ListView(
            physics: const BouncingScrollPhysics(),
            controller: _scrollController,
            children: [
              // Logo dan salam
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset('lib/images/logo_bangJAKI.png', width: 80),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Obx(
                        () => Text(
                          "Hi, ${authenticationController.name.value}!",
                          style: AppTextStyle.greeting,
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Kartu point
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Point Anda", style: TextStyle(fontSize: 18)),
                    Row(
                      children: [
                        Obx(
                          () => Text(
                            "${authenticationController.totalPoints.value} Point",
                            style: AppTextStyle.balance,
                          ),
                        ),
                        // IconButton(
                        //   icon: const Icon(Icons.refresh, size: 20),
                        //   tooltip: 'Refresh Point',
                        //   onPressed: () async {
                        //     await authenticationController.getUser();
                        //   },
                        // ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),
              const MainMenu(),

              const SizedBox(height: 20),

              // Judul dan lihat semua
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Daftar Sampah",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DaftarSampahPage(),
                        ),
                      );
                    },
                    child: const Text(
                      "Lihat Semua",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              const SampleSlider(),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

