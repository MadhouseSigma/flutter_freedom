import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter_freedom/generated/app_localizations.dart';
import '../../providers/app_provider.dart';
import '../../constants/mirrors.dart';

const _kDeepBlue = Color(0xFF0D1B2A);
const _kNavyPanel = Color(0xFF102035);
const _kAccentBlue = Color(0xFF1E88E5);
const _kBorder = Color(0xFFD0DCF0);
const _kSurface = Color(0xFFF0F4FA);
const _kWhite = Colors.white;

class MirrorSetupSection extends StatelessWidget {
  const MirrorSetupSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final provider = context.watch<AppProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.mirrorSetupDesc,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF5A7090),
            fontFamily: 'IranSans',
            height: 1.5,
          ),
        ),
        const SizedBox(height: 16),
        _FluentStepCard(
          stepNumber: '1',
          title: l10n.stepEnvVars,
          description: l10n.stepEnvVarsDesc,
          child: _EnvVarStep(l10n: l10n, provider: provider),
        ),
        const SizedBox(height: 12),
        _FluentStepCard(
          stepNumber: '2',
          title: l10n.stepGradleInit,
          description: l10n.stepGradleInitDesc,
          child: _GradleInitStep(l10n: l10n, provider: provider),
        ),
        const SizedBox(height: 12),
        _FluentStepCard(
          stepNumber: '3',
          title: l10n.stepGradleWrapper,
          description: l10n.stepGradleWrapperDesc,
          child: _GradleWrapperStep(l10n: l10n, provider: provider),
        ),
      ],
    );
  }
}

class _FluentStepCard extends StatelessWidget {
  final String stepNumber;
  final String title;
  final String description;
  final Widget child;

  const _FluentStepCard({
    required this.stepNumber,
    required this.title,
    required this.description,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _kWhite,
        border: Border.all(color: _kBorder),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
            decoration: const BoxDecoration(
              color: _kSurface,
              border: Border(bottom: BorderSide(color: _kBorder)),
              borderRadius: BorderRadius.vertical(top: Radius.circular(3)),
            ),
            child: Row(
              children: [
                Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: _kAccentBlue,
                    borderRadius: BorderRadius.circular(2),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    stepNumber,
                    style: const TextStyle(
                      color: _kWhite,
                      fontSize: 11,
                      fontFamily: 'IranSans',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(
                    color: _kDeepBlue,
                    fontSize: 13,
                    fontFamily: 'IranSans',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF5A7090),
                    fontFamily: 'IranSans',
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 14),
                child,
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EnvVarStep extends StatelessWidget {
  final AppLocalizations l10n;
  final AppProvider provider;

  const _EnvVarStep({required this.l10n, required this.provider});

  @override
  Widget build(BuildContext context) {
    final isLoading = provider.envStatus == OpStatus.loading;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: envMirrors.map((m) {
            final selected = provider.selectedEnvMirror == m.mirror;
            return _FluentChoiceChip(
              label: _mirrorName(m.name, l10n),
              selected: selected,
              onSelected: () => provider.setEnvMirror(m.mirror),
            );
          }).toList(),
        ),
        const SizedBox(height: 14),
        _ActionRow(
          isLoading: isLoading,
          onApply: () async {
            await provider.applyEnvMirror();
            _showToast(context, provider.envStatus, provider.envMessage, l10n);
          },
          onRevert: () async {
            final confirmed = await _confirmRevert(context, l10n);
            if (!confirmed) return;
            await provider.revertEnvMirror();
            _showToast(context, provider.envStatus, provider.envMessage, l10n);
          },
          l10n: l10n,
        ),
        if (provider.envStatus != OpStatus.idle) ...[
          const SizedBox(height: 10),
          _StatusRow(
            status: provider.envStatus,
            messageKey: provider.envMessage,
            l10n: l10n,
          ),
        ],
      ],
    );
  }
}

class _GradleInitStep extends StatelessWidget {
  final AppLocalizations l10n;
  final AppProvider provider;

  const _GradleInitStep({required this.l10n, required this.provider});

  @override
  Widget build(BuildContext context) {
    final isLoading = provider.gradleInitStatus == OpStatus.loading;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: gradleInitMirrors.map((m) {
            final selected = provider.selectedGradleInitMirror == m.mirror;
            return _FluentChoiceChip(
              label: _mirrorName(m.name, l10n),
              selected: selected,
              onSelected: () => provider.setGradleInitMirror(m.mirror),
            );
          }).toList(),
        ),
        const SizedBox(height: 14),
        _ActionRow(
          isLoading: isLoading,
          onApply: () async {
            await provider.applyGradleInitMirror();
            _showToast(context, provider.gradleInitStatus, provider.gradleInitMessage, l10n);
          },
          onRevert: () async {
            final confirmed = await _confirmRevert(context, l10n);
            if (!confirmed) return;
            await provider.revertGradleInitMirror();
            _showToast(context, provider.gradleInitStatus, provider.gradleInitMessage, l10n);
          },
          l10n: l10n,
        ),
        if (provider.gradleInitStatus != OpStatus.idle) ...[
          const SizedBox(height: 10),
          _StatusRow(
            status: provider.gradleInitStatus,
            messageKey: provider.gradleInitMessage,
            l10n: l10n,
          ),
        ],
      ],
    );
  }
}

class _GradleWrapperStep extends StatelessWidget {
  final AppLocalizations l10n;
  final AppProvider provider;

  const _GradleWrapperStep({required this.l10n, required this.provider});

  @override
  Widget build(BuildContext context) {
    final isLoading = provider.wrapperStatus == OpStatus.loading;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: gradleWrapperMirrors.map((m) {
            final selected = provider.selectedWrapperMirror == m.mirror;
            return _FluentChoiceChip(
              label: _mirrorName(m.name, l10n),
              selected: selected,
              onSelected: () => provider.setWrapperMirror(m.mirror),
            );
          }).toList(),
        ),
        const SizedBox(height: 14),
        _FolderPicker(l10n: l10n, provider: provider),
        const SizedBox(height: 14),
        _ActionRow(
          isLoading: isLoading,
          onApply: () async {
            await provider.applyWrapperMirror();
            _showToast(context, provider.wrapperStatus, provider.wrapperMessage, l10n);
          },
          onRevert: () async {
            final confirmed = await _confirmRevert(context, l10n);
            if (!confirmed) return;
            await provider.revertWrapperMirror();
            _showToast(context, provider.wrapperStatus, provider.wrapperMessage, l10n);
          },
          l10n: l10n,
        ),
        if (provider.wrapperStatus != OpStatus.idle) ...[
          const SizedBox(height: 10),
          _StatusRow(
            status: provider.wrapperStatus,
            messageKey: provider.wrapperMessage,
            l10n: l10n,
          ),
        ],
      ],
    );
  }
}

class _FolderPicker extends StatefulWidget {
  final AppLocalizations l10n;
  final AppProvider provider;

  const _FolderPicker({required this.l10n, required this.provider});

  @override
  State<_FolderPicker> createState() => _FolderPickerState();
}

class _FolderPickerState extends State<_FolderPicker> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MouseRegion(
          onEnter: (_) => setState(() => _hovered = true),
          onExit: (_) => setState(() => _hovered = false),
          child: GestureDetector(
            onTap: () async {
              final result = await FilePicker.platform.getDirectoryPath();
              if (result != null) widget.provider.setProjectPath(result);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 100),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
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
                  Icon(
                    Icons.folder_open_rounded,
                    size: 15,
                    color: _hovered ? _kAccentBlue : const Color(0xFF4A6A8A),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    widget.l10n.selectProjectFolder,
                    style: TextStyle(
                      color: _hovered ? _kAccentBlue : _kDeepBlue,
                      fontSize: 12,
                      fontFamily: 'IranSans',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            decoration: BoxDecoration(
              color: _kSurface,
              border: Border.all(color: _kBorder),
              borderRadius: BorderRadius.circular(3),
            ),
            child: Text(
              widget.provider.selectedProjectPath != null
                  ? widget.l10n.folderSelected(widget.provider.selectedProjectPath!)
                  : widget.l10n.noFolderSelected,
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF5A7090),
                fontFamily: 'IranSans',
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }
}

class _FluentChoiceChip extends StatefulWidget {
  final String label;
  final bool selected;
  final VoidCallback onSelected;

  const _FluentChoiceChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  @override
  State<_FluentChoiceChip> createState() => _FluentChoiceChipState();
}

class _FluentChoiceChipState extends State<_FluentChoiceChip> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onSelected,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            color: widget.selected
                ? _kAccentBlue
                : _hovered
                ? Colors.white
                : _kSurface,
            border: Border.all(
              color: widget.selected
                  ? _kAccentBlue
                  : _hovered
                  ? _kAccentBlue.withOpacity(0.5)
                  : _kBorder,
            ),
            borderRadius: BorderRadius.circular(3),
          ),
          child: Text(
            widget.label,
            style: TextStyle(
              color: widget.selected ? _kWhite : _kDeepBlue,
              fontSize: 12,
              fontFamily: 'IranSans',
              fontWeight: widget.selected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onApply;
  final VoidCallback onRevert;
  final AppLocalizations l10n;

  const _ActionRow({
    required this.isLoading,
    required this.onApply,
    required this.onRevert,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        isLoading
            ? const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: _kAccentBlue,
          ),
        )
            : _FluentActionButton(
          label: l10n.applyMirror,
          onPressed: onApply,
          primary: true,
        ),
        const SizedBox(width: 10),
        _FluentActionButton(
          label: l10n.revertMirror,
          onPressed: isLoading ? null : onRevert,
          primary: false,
          danger: true,
        ),
      ],
    );
  }
}

class _FluentActionButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool primary;
  final bool danger;

  const _FluentActionButton({
    required this.label,
    required this.onPressed,
    this.primary = false,
    this.danger = false,
  });

  @override
  State<_FluentActionButton> createState() => _FluentActionButtonState();
}

class _FluentActionButtonState extends State<_FluentActionButton> {
  bool _hovered = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final disabled = widget.onPressed == null;
    final Color bg;
    final Color borderColor;
    final Color textColor;

    if (disabled) {
      bg = _kSurface;
      borderColor = _kBorder;
      textColor = const Color(0xFFAEC0D0);
    } else if (widget.primary) {
      bg = _pressed
          ? const Color(0xFF1565C0)
          : _hovered
          ? const Color(0xFF1976D2)
          : _kAccentBlue;
      borderColor = const Color(0xFF1565C0);
      textColor = _kWhite;
    } else if (widget.danger) {
      bg = _pressed
          ? const Color(0xFFFFF0F0)
          : _hovered
          ? const Color(0xFFFFF5F5)
          : _kSurface;
      borderColor = _hovered ? const Color(0xFFE53935) : const Color(0xFFEF9A9A);
      textColor = const Color(0xFFD32F2F);
    } else {
      bg = _hovered ? _kWhite : _kSurface;
      borderColor = _hovered ? _kAccentBlue.withOpacity(0.5) : _kBorder;
      textColor = _kDeepBlue;
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 90),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
          decoration: BoxDecoration(
            color: bg,
            border: Border.all(color: borderColor),
            borderRadius: BorderRadius.circular(3),
          ),
          child: Text(
            widget.label,
            style: TextStyle(
              color: textColor,
              fontSize: 12,
              fontFamily: 'IranSans',
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusRow extends StatelessWidget {
  final OpStatus status;
  final String messageKey;
  final AppLocalizations l10n;

  const _StatusRow({
    required this.status,
    required this.messageKey,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final isSuccess = status == OpStatus.success;
    final color = isSuccess ? const Color(0xFF2E7D32) : const Color(0xFFC62828);
    final icon = isSuccess ? Icons.check_circle_outline_rounded : Icons.error_outline_rounded;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: isSuccess ? const Color(0xFFF1F8F1) : const Color(0xFFFFF3F3),
        border: Border.all(
          color: isSuccess ? const Color(0xFFA5D6A7) : const Color(0xFFEF9A9A),
        ),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              _resolveMessage(messageKey, l10n),
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontFamily: 'IranSans',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String _mirrorName(String key, AppLocalizations l10n) {
  switch (key) {
    case 'mirrorMyket':
      return l10n.mirrorMyket;
    case 'mirrorRunflare':
      return l10n.mirrorRunflare;
    case 'mirrorChinese':
      return l10n.mirrorChinese;
    case 'mirrorTaraz':
      return l10n.mirrorTaraz;
    case 'mirrorDevNeeds':
      return l10n.mirrorDevNeeds;
    default:
      return key;
  }
}

String _resolveMessage(String key, AppLocalizations l10n) {
  switch (key) {
    case 'successEnvSet':
      return l10n.successEnvSet;
    case 'successEnvReverted':
      return l10n.successEnvReverted;
    case 'successFileCreated':
      return l10n.successFileCreated;
    case 'successFileChanged':
      return l10n.successFileChanged;
    case 'successFileRemoved':
      return l10n.successFileRemoved;
    case 'successWrapperUpdated':
      return l10n.successWrapperUpdated;
    case 'successWrapperReverted':
      return l10n.successWrapperReverted;
    case 'errorFileAlreadyCorrect':
      return l10n.errorFileAlreadyCorrect;
    case 'errorFileNotExist':
      return l10n.errorFileNotExist;
    case 'errorWrapperNotFound':
      return l10n.errorWrapperNotFound;
    case 'errorWrapperReadFailed':
      return l10n.errorWrapperReadFailed;
    case 'errorUserFolderNotFound':
      return l10n.errorUserFolderNotFound;
    case 'errorNoFolderSelected':
      return l10n.errorNoFolderSelected;
    case 'autoSetupSuccess':
      return l10n.autoSetupSuccess;
    default:
      return l10n.errorGeneric(key);
  }
}

void _showToast(
    BuildContext context,
    OpStatus status,
    String messageKey,
    AppLocalizations l10n,
    ) {
  final isSuccess = status == OpStatus.success;
  BotToast.showSimpleNotification(
    title: _resolveMessage(messageKey, l10n),
    backgroundColor: isSuccess ? const Color(0xFF1B5E20) : const Color(0xFFB71C1C),
    titleStyle: const TextStyle(
      color: _kWhite,
      fontSize: 12,
      fontFamily: 'IranSans',
    ),
    duration: const Duration(seconds: 3),
    align: Alignment.bottomCenter,
  );
}

Future<bool> _confirmRevert(BuildContext context, AppLocalizations l10n) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (ctx) => Dialog(
      backgroundColor: _kWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
        side: const BorderSide(color: _kBorder),
      ),
      child: SizedBox(
        width: 360,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
              decoration: const BoxDecoration(
                color: _kNavyPanel,
                borderRadius: BorderRadius.vertical(top: Radius.circular(5)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber_rounded, color: Color(0xFFFFA726), size: 16),
                  const SizedBox(width: 10),
                  Text(
                    l10n.confirmRevert,
                    style: const TextStyle(
                      color: _kWhite,
                      fontSize: 13,
                      fontFamily: 'IranSans',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                l10n.confirmRevert,
                style: const TextStyle(
                  color: Color(0xFF2A3A50),
                  fontSize: 13,
                  fontFamily: 'IranSans',
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                color: _kSurface,
                border: Border(top: BorderSide(color: _kBorder)),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(5)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _FluentActionButton(
                    label: l10n.cancel,
                    onPressed: () => Navigator.pop(ctx, false),
                  ),
                  const SizedBox(width: 8),
                  _FluentActionButton(
                    label: l10n.yes,
                    onPressed: () => Navigator.pop(ctx, true),
                    danger: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
  return result ?? false;
}