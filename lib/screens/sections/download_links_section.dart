import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_freedom/generated/app_localizations.dart';
import '../../constants/links.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

const _kDeepBlue    = Color(0xFF0F2A9E);
const _kAccentBlue  = Color(0xFF0F2A9E);
const _kBorder      = Color(0xFFCDD5FF);
const _kSurface     = Color(0xFFF4F6FF);

class DownloadLinksSection extends StatelessWidget {
  const DownloadLinksSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Wrap(
      spacing: 12,
      runSpacing: 10,
      children: [
        _FluentDownloadButton(
          label: l10n.downloadFlutterSdk,
          icon: FontAwesomeIcons.flutter,
          url: flutterSdkUrl,
          accentColor: const Color(0xFF1E88E5),
        ),
        _FluentDownloadButton(
          label: l10n.downloadAndroidSdk,
          icon: FontAwesomeIcons.android,
          url: androidSdkUrl,
          accentColor: const Color(0xFF43A047),
        ),
      ],
    );
  }
}

class _FluentDownloadButton extends StatefulWidget {
  final String label;
  final FaIconData icon;
  final String url;
  final Color accentColor;

  const _FluentDownloadButton({
    required this.label,
    required this.icon,
    required this.url,
    required this.accentColor,
  });

  @override
  State<_FluentDownloadButton> createState() => _FluentDownloadButtonState();
}

class _FluentDownloadButtonState extends State<_FluentDownloadButton> {
  bool _hovered = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        onTap: () => launchUrl(Uri.parse(widget.url)),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          decoration: BoxDecoration(
            color: _pressed
                ? _kSurface
                : _hovered
                ? Colors.white
                : _kSurface,
            border: Border.all(
              color: _pressed
                  ? widget.accentColor
                  : _hovered
                  ? widget.accentColor.withOpacity(0.7)
                  : _kBorder,
              width: _pressed ? 1.5 : 1,
            ),
            borderRadius: BorderRadius.circular(3),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FaIcon(widget.icon, size: 16, color: widget.accentColor),
              const SizedBox(width: 10),
              Text(
                widget.label,
                style: TextStyle(
                  color: _hovered ? widget.accentColor : _kDeepBlue,
                  fontSize: 13,
                  fontFamily: 'IranSans',
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 10),
              Icon(
                Icons.open_in_new_rounded,
                size: 13,
                color: _hovered ? widget.accentColor.withOpacity(0.7) : const Color(0xFF90A8C0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}