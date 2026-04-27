import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

void main() {
  runApp(const XyrooSensixApp());
}

class XyrooSensixApp extends StatelessWidget {
  const XyrooSensixApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'XyrooSensix',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0A0A0F),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00F5FF),
          secondary: Color(0xFFFF006E),
          surface: Color(0xFF111118),
        ),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

// ─── SPLASH SCREEN ────────────────────────────────────────────────────────────
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1800));
    _fade = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _ctrl, curve: const Interval(0, 0.6, curve: Curves.easeOut)));
    _scale = Tween<double>(begin: 0.7, end: 1).animate(
        CurvedAnimation(parent: _ctrl, curve: const Interval(0, 0.6, curve: Curves.elasticOut)));
    _ctrl.forward();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ShizukuSetupScreen()));
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0F),
      body: Center(
        child: AnimatedBuilder(
          animation: _ctrl,
          builder: (_, __) => Opacity(
            opacity: _fade.value,
            child: Transform.scale(
              scale: _scale.value,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo
                  Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const SweepGradient(colors: [
                        Color(0xFF00F5FF),
                        Color(0xFFFF006E),
                        Color(0xFF7B2FFF),
                        Color(0xFF00F5FF),
                      ]),
                      boxShadow: [
                        BoxShadow(color: const Color(0xFF00F5FF).withOpacity(0.4), blurRadius: 30, spreadRadius: 5),
                      ],
                    ),
                    child: const Center(
                      child: Icon(Icons.settings_input_component_rounded, size: 52, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text('XyrooSensix', style: TextStyle(
                    fontSize: 32, fontWeight: FontWeight.w900, letterSpacing: 2,
                    foreground: Paint()..shader = const LinearGradient(
                      colors: [Color(0xFF00F5FF), Color(0xFFFF006E)],
                    ).createShader(Rect.fromLTWH(0, 0, 220, 40)),
                  )),
                  const SizedBox(height: 8),
                  const Text('DPI & Sensitivity Controller', style: TextStyle(
                    color: Color(0xFF888899), fontSize: 13, letterSpacing: 1.5,
                  )),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: 160,
                    child: LinearProgressIndicator(
                      backgroundColor: const Color(0xFF1E1E2E),
                      valueColor: const AlwaysStoppedAnimation(Color(0xFF00F5FF)),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── SHIZUKU SETUP SCREEN ─────────────────────────────────────────────────────
class ShizukuSetupScreen extends StatefulWidget {
  const ShizukuSetupScreen({super.key});
  @override
  State<ShizukuSetupScreen> createState() => _ShizukuSetupScreenState();
}

class _ShizukuSetupScreenState extends State<ShizukuSetupScreen> {
  bool _shizukuConnected = false;

  void _connect() {
    setState(() => _shizukuConnected = true);
    Future.delayed(const Duration(milliseconds: 800), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0F),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text('Setup', style: TextStyle(
                fontSize: 36, fontWeight: FontWeight.w900,
                color: Color(0xFF00F5FF), letterSpacing: 1,
              )),
              const Text('Privilege Required', style: TextStyle(
                fontSize: 15, color: Color(0xFF555566), letterSpacing: 1,
              )),
              const SizedBox(height: 48),
              _SetupCard(
                icon: Icons.security_rounded,
                title: 'Shizuku',
                subtitle: 'Required untuk menjalankan perintah sistem\n(wm density, wm size)',
                status: _shizukuConnected ? 'Connected' : 'Not Connected',
                statusColor: _shizukuConnected ? const Color(0xFF00FF88) : const Color(0xFFFF006E),
              ),
              const SizedBox(height: 20),
              _SetupCard(
                icon: Icons.layers_rounded,
                title: 'Overlay Permission',
                subtitle: 'Diperlukan untuk menampilkan floating window di atas aplikasi lain',
                status: 'Required',
                statusColor: const Color(0xFFFFAA00),
              ),
              const Spacer(),
              // Info box
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF00F5FF).withOpacity(0.3)),
                  borderRadius: BorderRadius.circular(12),
                  color: const Color(0xFF00F5FF).withOpacity(0.05),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline_rounded, color: Color(0xFF00F5FF), size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Shizuku memungkinkan XyrooSensix mengubah DPI & resolusi layar tanpa root.',
                        style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12, height: 1.5),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _shizukuConnected ? null : _connect,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00F5FF),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Text(
                    _shizukuConnected ? 'Menghubungkan...' : 'Hubungkan Shizuku',
                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, letterSpacing: 1),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  onPressed: () => Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (_) => const MainScreen())),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF333344)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text('Lanjutkan Tanpa Shizuku',
                      style: TextStyle(color: Color(0xFF888899), fontSize: 13)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SetupCard extends StatelessWidget {
  final IconData icon;
  final String title, subtitle, status;
  final Color statusColor;
  const _SetupCard({required this.icon, required this.title, required this.subtitle, required this.status, required this.statusColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF111118),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1E1E2E)),
      ),
      child: Row(
        children: [
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A2E),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFF00F5FF), size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(color: Color(0xFF666677), fontSize: 12, height: 1.4)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: statusColor.withOpacity(0.4)),
            ),
            child: Text(status, style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}

// ─── MAIN SCREEN ─────────────────────────────────────────────────────────────
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    DpiControllerPage(),
    SensitivityPage(),
    ScreenSizePage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0A0F),
        elevation: 0,
        title: Row(
          children: [
            Container(
              width: 32, height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFF00F5FF), Color(0xFFFF006E)],
                ),
              ),
              child: const Icon(Icons.settings_input_component_rounded, size: 16, color: Colors.white),
            ),
            const SizedBox(width: 10),
            const Text('XyrooSensix', style: TextStyle(
              fontWeight: FontWeight.w900, fontSize: 18, letterSpacing: 1,
              color: Color(0xFF00F5FF),
            )),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF00FF88).withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF00FF88).withOpacity(0.4)),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.circle, color: Color(0xFF00FF88), size: 8),
                SizedBox(width: 6),
                Text('Shizuku', style: TextStyle(color: Color(0xFF00FF88), fontSize: 11, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
        ],
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Color(0xFF1E1E2E))),
          color: Color(0xFF0D0D14),
        ),
        child: NavigationBar(
          backgroundColor: Colors.transparent,
          indicatorColor: const Color(0xFF00F5FF).withOpacity(0.15),
          selectedIndex: _currentIndex,
          onDestinationSelected: (i) => setState(() => _currentIndex = i),
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.tune_rounded),
              selectedIcon: Icon(Icons.tune_rounded, color: Color(0xFF00F5FF)),
              label: 'DPI',
            ),
            NavigationDestination(
              icon: Icon(Icons.ads_click_rounded),
              selectedIcon: Icon(Icons.ads_click_rounded, color: Color(0xFF00F5FF)),
              label: 'Sens',
            ),
            NavigationDestination(
              icon: Icon(Icons.aspect_ratio_rounded),
              selectedIcon: Icon(Icons.aspect_ratio_rounded, color: Color(0xFF00F5FF)),
              label: 'Screen',
            ),
            NavigationDestination(
              icon: Icon(Icons.settings_rounded),
              selectedIcon: Icon(Icons.settings_rounded, color: Color(0xFF00F5FF)),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}

// ─── DPI CONTROLLER PAGE ──────────────────────────────────────────────────────
class DpiControllerPage extends StatefulWidget {
  const DpiControllerPage({super.key});
  @override
  State<DpiControllerPage> createState() => _DpiControllerPageState();
}

class _DpiControllerPageState extends State<DpiControllerPage> {
  double _dpi = 400;
  String _currentDpi = '400';
  String _log = '';
  bool _isExecuting = false;
  final TextEditingController _customDpiCtrl = TextEditingController();

  final List<Map<String, dynamic>> _presets = [
    {'label': 'Low', 'dpi': 200, 'desc': 'Tampilan besar'},
    {'label': 'Normal', 'dpi': 320, 'desc': 'Default'},
    {'label': 'HD', 'dpi': 400, 'desc': 'Seimbang'},
    {'label': 'FHD', 'dpi': 480, 'desc': 'Tajam'},
    {'label': 'QHD', 'dpi': 560, 'desc': 'Ultra tajam'},
    {'label': 'UHD', 'dpi': 640, 'desc': 'Max density'},
  ];

  void _applyDpi(int dpi) {
    setState(() {
      _isExecuting = true;
      _log = 'Executing: wm density $dpi\n';
    });
    Future.delayed(const Duration(milliseconds: 800), () {
      setState(() {
        _currentDpi = '$dpi';
        _log += 'Done: wm density $dpi\n[i] DPI applied successfully.';
        _isExecuting = false;
      });
    });
  }

  void _resetDpi() {
    setState(() {
      _isExecuting = true;
      _log = 'Executing: wm density reset\n';
    });
    Future.delayed(const Duration(milliseconds: 800), () {
      setState(() {
        _currentDpi = 'Default';
        _log += 'Done: wm density reset\n[i] DPI reset to default.';
        _isExecuting = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Current DPI Card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [const Color(0xFF00F5FF).withOpacity(0.1), const Color(0xFF7B2FFF).withOpacity(0.05)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFF00F5FF).withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Current DPI', style: TextStyle(color: Color(0xFF888899), fontSize: 12, letterSpacing: 1)),
                    const SizedBox(height: 4),
                    Text(_currentDpi, style: const TextStyle(
                      fontSize: 48, fontWeight: FontWeight.w900, color: Color(0xFF00F5FF),
                    )),
                    const Text('wm density', style: TextStyle(color: Color(0xFF555566), fontSize: 12, fontFamily: 'monospace')),
                  ],
                ),
              ),
              Column(
                children: [
                  _isExecuting
                      ? const SizedBox(width: 28, height: 28, child: CircularProgressIndicator(
                          strokeWidth: 2.5, color: Color(0xFF00F5FF)))
                      : const Icon(Icons.check_circle_rounded, color: Color(0xFF00FF88), size: 28),
                  const SizedBox(height: 8),
                  Text(_isExecuting ? 'Applying...' : 'Ready',
                      style: TextStyle(color: _isExecuting ? const Color(0xFF00F5FF) : const Color(0xFF00FF88), fontSize: 11)),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Slider
        const _SectionLabel('Adjust DPI'),
        const SizedBox(height: 8),
        Row(
          children: [
            const Text('200', style: TextStyle(color: Color(0xFF555566), fontSize: 11)),
            Expanded(
              child: SliderTheme(
                data: SliderThemeData(
                  trackHeight: 4,
                  thumbColor: const Color(0xFF00F5FF),
                  activeTrackColor: const Color(0xFF00F5FF),
                  inactiveTrackColor: const Color(0xFF1E1E2E),
                  overlayColor: const Color(0xFF00F5FF).withOpacity(0.15),
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
                ),
                child: Slider(
                  value: _dpi,
                  min: 200,
                  max: 700,
                  divisions: 50,
                  onChanged: (v) => setState(() => _dpi = v),
                ),
              ),
            ),
            const Text('700', style: TextStyle(color: Color(0xFF555566), fontSize: 11)),
          ],
        ),
        Center(
          child: Text('${_dpi.toInt()} DPI', style: const TextStyle(
            color: Color(0xFF00F5FF), fontWeight: FontWeight.w700, fontSize: 16,
          )),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: () => _applyDpi(_dpi.toInt()),
                  icon: const Icon(Icons.play_arrow_rounded, size: 18),
                  label: const Text('Apply', style: TextStyle(fontWeight: FontWeight.w700)),
                  style: Ele
