import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_freedom/generated/app_localizations.dart';
import '../../constants/links.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

const _kDeepBlue    = Color(0xFF0F2A9E);
const _kAccentBlue  = Color(0xFF0F2A9E);
const _kBorder      = Color(0xFFCDD5FF);
const _kSurface     = Color(0xFFF4F6FF);

class HelpfulLinksSection extends StatelessWidget {
  const HelpfulLinksSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: helpfulLinks.map((link) {
        return _FluentLinkChip(
          label: _resolveLabel(link.labelKey, l10n),
          url: link.url,
        );
      }).toList(),
    );
  }

  String _resolveLabel(String key, AppLocalizations l10n) {
    switch (key) {
      case 'helpfulLinkPubMyket':
        return l10n.helpfulLinkPubMyket;
      case 'helpfulLinkPubTaraz':
        return l10n.helpfulLinkPubTaraz;
      case 'helpfulLinkMavenMyket':
        return l10n.helpfulLinkMavenMyket;
      case 'helpfulLinkRunflareDocs':
        return l10n.helpfulLinkRunflareDocs;
      case 'helpfulLinkFlutterGems':
        return l10n.helpfulLinkFlutterGems;
      case 'helpfulLinkUndraw':
        return l10n.helpfulLinkUndraw;
      case 'helpfulLinkSvgRepo':
        return l10n.helpfulLinkSvgRepo;
      case 'helpfulLinkAwesomeFlutter':
        return l10n.helpfulLinkAwesomeFlutter;
      case 'helpfulLinkFlutterAwesome':
        return l10n.helpfulLinkFlutterAwesome;
      default:
        return key;
    }
  }
}

class _FluentLinkChip extends StatefulWidget {
  final String label;
  final String url;

  const _FluentLinkChip({required this.label, required this.url});

  @override
  State<_FluentLinkChip> createState() => _FluentLinkChipState();
}

class _FluentLinkChipState extends State<_FluentLinkChip> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => launchUrl(Uri.parse(widget.url)),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: _hovered ? Colors.white : _kSurface,
            border: Border.all(
              color: _hovered ? _kAccentBlue.withOpacity(0.6) : _kBorder,
            ),
            borderRadius: BorderRadius.circular(3),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FaIcon(
                FontAwesomeIcons.arrowUpRightFromSquare,
                size: 11,
                color: _hovered ? _kAccentBlue : const Color(0xFF7090B0),
              ),
              const SizedBox(width: 7),
              Text(
                widget.label,
                style: TextStyle(
                  color: _hovered ? _kAccentBlue : const Color(0xFF3A5070),
                  fontSize: 12,
                  fontFamily: 'IranSans',
                  fontWeight: _hovered ? FontWeight.w500 : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}