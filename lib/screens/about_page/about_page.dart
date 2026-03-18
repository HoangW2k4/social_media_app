import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/language_provider.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final langProvider = Provider.of<LanguageProvider>(context);
    final isEn = !langProvider.isVietnamese;

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // App Logo & Name
          Center(
            child: Column(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.blue, Colors.blueAccent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withValues(alpha: 0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      'S',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  t.translate('app_name'),
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  t.translate('app_tagline'),
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Language Switch Section
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.language, color: Colors.blue),
                      const SizedBox(width: 8),
                      Text(
                        t.translate('about_language'),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () =>
                              langProvider.setLocale(const Locale('vi')),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 16,
                            ),
                            decoration: BoxDecoration(
                              color: langProvider.isVietnamese
                                  ? Colors.blue
                                  : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: langProvider.isVietnamese
                                    ? Colors.blue
                                    : Colors.grey.shade300,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('🇻🇳', style: TextStyle(fontSize: 20)),
                                const SizedBox(width: 8),
                                Text(
                                  'Tiếng Việt',
                                  style: TextStyle(
                                    color: langProvider.isVietnamese
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: () =>
                              langProvider.setLocale(const Locale('en')),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 16,
                            ),
                            decoration: BoxDecoration(
                              color: !langProvider.isVietnamese
                                  ? Colors.blue
                                  : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: !langProvider.isVietnamese
                                    ? Colors.blue
                                    : Colors.grey.shade300,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('🇺🇸', style: TextStyle(fontSize: 20)),
                                const SizedBox(width: 8),
                                Text(
                                  'English',
                                  style: TextStyle(
                                    color: !langProvider.isVietnamese
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // App Info
          _buildSection(
            icon: Icons.info_outline,
            title: t.translate('about_app_info'),
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t.translate('about_app_description'),
                      style: TextStyle(color: Colors.grey.shade700, height: 1.5),
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow(t.translate('about_version'), '1.0.0'),
                    _buildInfoRow(
                        t.translate('about_platform'), 'Android / iOS / Web'),
                    _buildInfoRow(
                        t.translate('about_framework'), 'Flutter / Dart'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ✅ Creator Info — 2 developers, bilingual
          _buildSection(
            icon: Icons.people_outline,
            title: t.translate('about_creator_info'),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Developer 1 ──────────────────────────────────────
                    _buildDeveloperCard(
                      isEn: isEn,
                      index: 1,
                      name: 'Trần Duy Việt Hoằng',
                      email: '22010142@st.phenikaa-uni.edu.vn',
                      scope: isEn
                          ? 'Home Page, Friends Page'
                          : 'Trang Home, Trang Bạn Bè',
                      github: 'https://github.com/HoangW2k4/2026_3_LTTBDD_N03_Nhom_13-dev1',
                    ),
                    const SizedBox(height: 12),
                    _buildDeveloperCard(
                      isEn: isEn,
                      index: 2,
                      name: 'Nguyễn Tá Đặng Minh',
                      email: 'nguyentadangminh04@gmail.com',
                      scope: isEn
                          ? 'Messages Page, About Page'
                          : 'Trang Message, Trang Giới Thiệu',
                      github: 'https://github.com/HoangW2k4/2026_3_LTTBDD_N03_Nhom_13-dev3',
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Features
          _buildSection(
            icon: Icons.star_outline,
            title: t.translate('about_features'),
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildFeatureItem(t.translate('about_feature_1'), Icons.feed),
                    _buildFeatureItem(t.translate('about_feature_2'), Icons.people),
                    _buildFeatureItem(t.translate('about_feature_3'), Icons.chat),
                    _buildFeatureItem(t.translate('about_feature_4'), Icons.language),
                    _buildFeatureItem(t.translate('about_feature_5'), Icons.palette),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Footer
          Center(
            child: Text(
              '© 2026 FaceBrick. All rights reserved.',
              style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // ── Developer card ──────────────────────────────────────────────────────────
  Widget _buildDeveloperCard({
    required bool isEn,
    required int index,
    required String name,
    required String email,
    required String scope,
    required String github,
  }) {
    final devLabel  = isEn ? 'Developer $index' : 'Nhà Phát triển $index';
    final nameLabel = isEn ? 'Developer'       : 'Developer';
    final emailLabel= isEn ? 'Email'           : 'Email';
    final scopeLabel= isEn ? 'Scope'           : 'Mục Phát Triển';
    final ghLabel   = isEn ? 'GitHub'          : 'GitHub';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: "Nhà Phát triển 1" / "Developer 1"
          Row(children: [
            const Icon(Icons.person, size: 18, color: Colors.blue),
            const SizedBox(width: 6),
            Text(devLabel,
                style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: Colors.blue)),
          ]),
          const SizedBox(height: 10),
          _buildInfoRow(nameLabel, name),
          _buildInfoRow(emailLabel, email),
          _buildInfoRow(scopeLabel, scope),
          _buildInfoRow(ghLabel, github),
        ],
      ),
    );
  }

  Widget _buildSection({
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(icon, color: Colors.blue),
                const SizedBox(width: 8),
                Text(title,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const Divider(height: 1),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(label,
                style: const TextStyle(
                    fontWeight: FontWeight.w600, color: Colors.black87)),
          ),
          Expanded(
            child: Text(value,
                style: TextStyle(color: Colors.grey.shade700, fontSize: 13)),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(String text, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.blue),
          const SizedBox(width: 12),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}