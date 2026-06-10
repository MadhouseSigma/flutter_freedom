import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_freedom/generated/app_localizations.dart';
import '../providers/app_provider.dart';
import 'sections/download_links_section.dart';
import 'sections/mirror_setup_section.dart';
import 'sections/helpful_links_section.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:window_manager/window_manager.dart';
import '../constants/constants.dart';

const _kDeepBlue    = Color(0xFF0F2A9E);
const _kNavyPanel   = Color(0xFF0C2080);
const _kAccentBlue  = Color(0xFF0F2A9E);
const _kAccentLight = Color(0xFF5B7FFF);
const _kSurface     = Color(0xFFF4F6FF);
const _kBorder      = Color(0xFFCDD5FF);
const _kWhite       = Colors.white;

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n     = AppLocalizations.of(context)!;
    final provider = context.watch<AppProvider>();
    final isRtl    = provider.locale.languageCode == 'fa';
    final platform = Platform.operatingSystem;

    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: _kDeepBlue,
        body: Stack(
          children: [
            const _ImageBackground(),
            Column(
              children: [
                _WindowsTitleBar(
                  title: l10n.appTitle,
                  platform: platform,
                  l10n: l10n,
                  provider: provider,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(28, 20, 28, 28),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 880),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _FluentPanel(
                              title: l10n.sectionDownloadLinks,
                              icon: FontAwesomeIcons.download,
                              child: const DownloadLinksSection(),
                            ),
                            const SizedBox(height: 16),
                            _FluentPanel(
                              title: l10n.sectionMirrorSetup,
                              icon: FontAwesomeIcons.gear,
                              child: const MirrorSetupSection(),
                            ),
                            const SizedBox(height: 16),
                            _FluentPanel(
                              title: l10n.sectionHelpfulLinks,
                              icon: FontAwesomeIcons.link,
                              child: const HelpfulLinksSection(),
                            ),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ImageBackground extends StatelessWidget {
  const _ImageBackground();

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/background.png',
            fit: BoxFit.cover,
          ),
          Container(
            color: const Color(0xFF0F2A9E).withOpacity(0.72),
          ),
          const _GeometricOverlay(),
        ],
      ),
    );
  }
}

class _GeometricOverlay extends StatelessWidget {
  const _GeometricOverlay();

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: CustomPaint(painter: _GeometricPainter()),
    );
  }
}

class _GeometricPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final circlePaint = Paint()..style = PaintingStyle.stroke..strokeWidth = 0.6;
    final circles = [
      Offset(size.width * 0.85, size.height * 0.12),
      Offset(size.width * 0.05, size.height * 0.75),
      Offset(size.width * 0.5,  size.height * 0.95),
      Offset(size.width * 0.92, size.height * 0.6),
      Offset(size.width * 0.15, size.height * 0.2),
    ];
    final radii = [180.0, 140.0, 220.0, 90.0, 160.0];

    for (int i = 0; i < circles.length; i++) {
      for (int j = 1; j <= 3; j++) {
        circlePaint.color = _kWhite.withOpacity(0.03 + j * 0.015);
        canvas.drawCircle(circles[i], radii[i] * j * 0.5, circlePaint);
      }
    }

    final linePaint = Paint()
      ..style       = PaintingStyle.stroke
      ..strokeWidth = 0.4
      ..color       = _kWhite.withOpacity(0.05);

    for (int i = 0; i < 6; i++) {
      final x = size.width * (i / 5.0);
      canvas.drawLine(
        Offset(x, 0),
        Offset(x - size.height * 0.15, size.height),
        linePaint,
      );
    }

    final dotPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = _kWhite.withOpacity(0.08);

    final rand = math.Random(42);
    for (int i = 0; i < 30; i++) {
      canvas.drawCircle(
        Offset(rand.nextDouble() * size.width, rand.nextDouble() * size.height),
        rand.nextDouble() * 2 + 1,
        dotPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _WindowsTitleBar extends StatelessWidget {
  final String title;
  final String platform;
  final AppLocalizations l10n;
  final AppProvider provider;

  const _WindowsTitleBar({
    required this.title,
    required this.platform,
    required this.l10n,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: _kNavyPanel.withOpacity(0.88),
        border: const Border(
          bottom: BorderSide(color: Color(0xFF1A3AB0), width: 1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: DragToMoveArea(
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  const FaIcon(FontAwesomeIcons.flutter, color: _kAccentLight, size: 18),
                  const SizedBox(width: 10),
                  Text(
                    title,
                    style: const TextStyle(
                      color: _kWhite,
                      fontSize: 14,
                      fontFamily: 'IranSans',
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Container(
                    height: 22,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFF3050C0)),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      platform.toUpperCase(),
                      style: const TextStyle(
                        color: Color(0xFFB0BFFF),
                        fontSize: 10,
                        fontFamily: 'IranSans',
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
          _TitleBarButton(
            onPressed: () => provider.toggleLocale(),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.languageToggle,
                  style: const TextStyle(
                    color: Color(0xFFD0D8FF),
                    fontSize: 12,
                    fontFamily: 'IranSans',
                  ),
                ),
                const SizedBox(width: 6),
                const FaIcon(FontAwesomeIcons.language, color: Color(0xFFD0D8FF), size: 14),
              ],
            ),
          ),
          const SizedBox(width: 4),
          _TitleBarButton(
            onPressed: () => showAbout(context),
            child: const FaIcon(FontAwesomeIcons.circleInfo, color: Color(0xFFD0D8FF), size: 15),
          ),
          const SizedBox(width: 8),
          const _WindowControls(),
        ],
      ),
    );
  }
}

class _TitleBarButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget child;

  const _TitleBarButton({required this.onPressed, required this.child});

  @override
  State<_TitleBarButton> createState() => _TitleBarButtonState();
}

class _TitleBarButtonState extends State<_TitleBarButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: _hovered ? _kWhite.withOpacity(0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(3),
          ),
          child: widget.child,
        ),
      ),
    );
  }
}

class _WindowControls extends StatelessWidget {
  const _WindowControls();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _WinControlButton(
          icon: Icons.remove_rounded,
          onPressed: () => windowManager.minimize(),
          hoverColor: _kWhite.withOpacity(0.1),
        ),
        _WinControlButton(
          icon: Icons.crop_square_rounded,
          onPressed: () async {
            if (await windowManager.isMaximized()) {
              windowManager.unmaximize();
            } else {
              windowManager.maximize();
            }
          },
          hoverColor: _kWhite.withOpacity(0.1),
        ),
        _WinControlButton(
          icon: Icons.close_rounded,
          onPressed: () => windowManager.close(),
          hoverColor: const Color(0xFFC42B1C),
          hoverIconColor: _kWhite,
        ),
      ],
    );
  }
}

class _WinControlButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color hoverColor;
  final Color iconColor;
  final Color hoverIconColor;

  const _WinControlButton({
    required this.icon,
    required this.onPressed,
    required this.hoverColor,
    this.iconColor = const Color(0xFFD0D8FF),
    this.hoverIconColor = const Color(0xFFD0D8FF),
  });

  @override
  State<_WinControlButton> createState() => _WinControlButtonState();
}

class _WinControlButtonState extends State<_WinControlButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          width: 46,
          height: 52,
          color: _hovered ? widget.hoverColor : Colors.transparent,
          child: Icon(
            widget.icon,
            size: 16,
            color: _hovered ? widget.hoverIconColor : widget.iconColor,
          ),
        ),
      ),
    );
  }
}

class _FluentPanel extends StatelessWidget {
  final String title;
  final FaIconData icon;
  final Widget child;

  const _FluentPanel({
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _kWhite.withOpacity(0.96),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: _kBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
            decoration: const BoxDecoration(
              color: _kSurface,
              borderRadius: BorderRadius.vertical(top: Radius.circular(5)),
              border: Border(bottom: BorderSide(color: _kBorder, width: 1)),
            ),
            child: Row(
              children: [
                FaIcon(icon, color: _kAccentBlue, size: 15),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(
                    color: _kDeepBlue,
                    fontSize: 13,
                    fontFamily: 'IranSans',
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.1,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: child,
          ),
        ],
      ),
    );
  }
}

void showAbout(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  showDialog(
    context: context,
    builder: (ctx) => Dialog(
      backgroundColor: _kWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
        side: const BorderSide(color: _kBorder),
      ),
      child: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: const BoxDecoration(
                color: _kNavyPanel,
                borderRadius: BorderRadius.vertical(top: Radius.circular(5)),
              ),
              child: Row(
                children: [
                  const FaIcon(FontAwesomeIcons.circleInfo, color: _kAccentLight, size: 16),
                  const SizedBox(width: 10),
                  Text(
                    l10n.appTitle,
                    style: const TextStyle(
                      color: _kWhite,
                      fontSize: 14,
                      fontFamily: 'IranSans',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    AppVars.appVersion,
                    style: const TextStyle(
                      color: Color(0xFFB0BFFF),
                      fontSize: 12,
                      fontFamily: 'IranSans',
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.aboutDescription,
                    style: const TextStyle(
                      color: Color(0xFF1A2A6E),
                      fontSize: 13,
                      fontFamily: 'IranSans',
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Divider(color: _kBorder, height: 1),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _AboutLinkButton(
                        label: l10n.githubRepo,
                        icon: FontAwesomeIcons.github,
                        color: const Color(0xFF1A2A6E),
                        onPressed: () => launchUrl(
                          Uri.parse("https://github.com/MadhouseSigma/flutter-freedom-iran"),
                        ),
                      ),
                      const SizedBox(width: 10),
                      _AboutLinkButton(
                        label: l10n.telegramChannel,
                        icon: FontAwesomeIcons.telegram,
                        color: _kAccentBlue,
                        onPressed: () => launchUrl(Uri.parse("https://t.me/flutterfreedom")),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: const BoxDecoration(
                color: _kSurface,
                border: Border(top: BorderSide(color: _kBorder, width: 1)),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(5)),
              ),
              alignment: Alignment.centerRight,
              child: _FluentButton(
                label: 'OK',
                onPressed: () => Navigator.of(ctx).pop(),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _AboutLinkButton extends StatefulWidget {
  final String label;
  final FaIconData icon;
  final Color color;
  final VoidCallback onPressed;

  const _AboutLinkButton({
    required this.label,
    required this.icon,
    this.color = const Color(0xFF1A2A6E),
    required this.onPressed,
  });

  @override
  State<_AboutLinkButton> createState() => _AboutLinkButtonState();
}

class _AboutLinkButtonState extends State<_AboutLinkButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: _hovered ? _kSurface : Colors.transparent,
            border: Border.all(color: _hovered ? _kAccentBlue : _kBorder),
            borderRadius: BorderRadius.circular(3),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FaIcon(widget.icon, size: 15, color: widget.color),
              const SizedBox(width: 7),
              Text(
                widget.label,
                style: TextStyle(
                  color: widget.color,
                  fontSize: 12,
                  fontFamily: 'IranSans',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FluentButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;

  const _FluentButton({required this.label, required this.onPressed});

  @override
  State<_FluentButton> createState() => _FluentButtonState();
}

class _FluentButtonState extends State<_FluentButton> {
  bool _hovered = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTapDown:   (_) => setState(() => _pressed = true),
        onTapUp:     (_) => setState(() => _pressed = false),
        onTapCancel: ()  => setState(() => _pressed = false),
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 80),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 7),
          decoration: BoxDecoration(
            color: _pressed
                ? const Color(0xFF0A1E7A)
                : _hovered
                ? const Color(0xFF1235B8)
                : _kAccentBlue,
            borderRadius: BorderRadius.circular(3),
            border: Border.all(
              color: _pressed ? const Color(0xFF081560) : const Color(0xFF0A1E7A),
            ),
          ),
          child: Text(
            widget.label,
            style: const TextStyle(
              color: _kWhite,
              fontSize: 13,
              fontFamily: 'IranSans',
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}