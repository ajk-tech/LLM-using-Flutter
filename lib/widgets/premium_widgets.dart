import 'package:flutter/material.dart';

import '../theme.dart';

AppThemeTokens appTokens(BuildContext context) {
  return Theme.of(context).extension<AppThemeTokens>()!;
}

class PremiumCard extends StatefulWidget {
  const PremiumCard({
    required this.child,
    this.padding = const EdgeInsets.all(24),
    this.radius = 22,
    this.hoverable = true,
    this.gradient,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final bool hoverable;
  final Gradient? gradient;

  @override
  State<PremiumCard> createState() => _PremiumCardState();
}

class _PremiumCardState extends State<PremiumCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final AppThemeTokens tokens = appTokens(context);
    final Widget card = AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      transform: Matrix4.translationValues(0, _hovered && widget.hoverable ? -2 : 0, 0),
      padding: widget.padding,
      decoration: BoxDecoration(
        color: widget.gradient == null ? tokens.surface.withValues(alpha: .92) : null,
        gradient: widget.gradient,
        borderRadius: BorderRadius.circular(widget.radius),
        border: Border.all(color: tokens.border.withValues(alpha: .88)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: tokens.shadow.withValues(alpha: _hovered && widget.hoverable ? .95 : .64),
            blurRadius: _hovered && widget.hoverable ? 26 : 18,
            offset: Offset(0, _hovered && widget.hoverable ? 14 : 10),
          ),
        ],
      ),
      child: widget.child,
    );
    if (!widget.hoverable) {
      return card;
    }
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: card,
    );
  }
}

class GradientButton extends StatefulWidget {
  const GradientButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    this.compact = false,
    super.key,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onPressed;
  final bool compact;

  @override
  State<GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final bool disabled = widget.onPressed == null;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 150),
        scale: _hovered && !disabled ? 1.015 : 1,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: disabled
                ? null
                : const LinearGradient(
                    colors: <Color>[AppColors.primary, AppColors.secondary, AppColors.accent],
                  ),
            color: disabled ? Theme.of(context).disabledColor.withValues(alpha: .16) : null,
            borderRadius: BorderRadius.circular(16),
            boxShadow: disabled
                ? const <BoxShadow>[]
                : <BoxShadow>[
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: .28),
                      blurRadius: 22,
                      offset: const Offset(0, 12),
                    ),
                  ],
          ),
          child: FilledButton.icon(
            onPressed: widget.onPressed,
            icon: Icon(widget.icon, size: 18),
            label: Text(widget.label, maxLines: 2, overflow: TextOverflow.ellipsis),
            style: FilledButton.styleFrom(
              backgroundColor: Colors.transparent,
              disabledBackgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              padding: EdgeInsets.symmetric(
                horizontal: widget.compact ? 14 : 18,
                vertical: widget.compact ? 12 : 15,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class StatusBadge extends StatelessWidget {
  const StatusBadge({
    required this.label,
    required this.color,
    this.icon,
    super.key,
  });

  final String label;
  final Color color;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: .24)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (icon != null) ...<Widget>[
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w800),
            ),
          ],
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    required this.title,
    required this.subtitle,
    this.action,
    super.key,
  });

  final String title;
  final String subtitle;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final AppThemeTokens tokens = appTokens(context);
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final Widget copy = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(title, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 6),
            Text(subtitle, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: tokens.textSecondary)),
          ],
        );
        if (action == null) {
          return copy;
        }
        if (constraints.maxWidth < 680) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              copy,
              const SizedBox(height: 14),
              action!,
            ],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(child: copy),
            const SizedBox(width: 16),
            action!,
          ],
        );
      },
    );
  }
}

class MetricCard extends StatelessWidget {
  const MetricCard({
    required this.label,
    required this.value,
    required this.trend,
    required this.icon,
    required this.color,
    super.key,
  });

  final String label;
  final String value;
  final String trend;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final AppThemeTokens tokens = appTokens(context);
    return PremiumCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              DecoratedBox(
                decoration: BoxDecoration(
                  color: color.withValues(alpha: .12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Icon(icon, color: color, size: 20),
                ),
              ),
              const Spacer(),
              StatusBadge(label: trend, color: AppColors.success, icon: Icons.trending_up),
            ],
          ),
          const SizedBox(height: 18),
          Text(value, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 4),
          Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: tokens.textSecondary)),
        ],
      ),
    );
  }
}

class SkeletonLines extends StatefulWidget {
  const SkeletonLines({super.key});

  @override
  State<SkeletonLines> createState() => _SkeletonLinesState();
}

class _SkeletonLinesState extends State<SkeletonLines> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppThemeTokens tokens = appTokens(context);
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget? child) {
        final double slide = _controller.value;
        final double start = (slide - .28).clamp(0.0, 1.0).toDouble();
        final double middle = slide.clamp(0.0, 1.0).toDouble();
        final double end = (slide + .28).clamp(0.0, 1.0).toDouble();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            for (final double width in const <double>[.92, .76, .84])
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: FractionallySizedBox(
                  widthFactor: width,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: <Color>[
                          tokens.border.withValues(alpha: .32),
                          AppColors.secondary.withValues(alpha: .16),
                          tokens.border.withValues(alpha: .32),
                        ],
                        stops: <double>[start, middle, end],
                      ),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const SizedBox(height: 12),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class ChartPlaceholder extends StatelessWidget {
  const ChartPlaceholder({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    final AppThemeTokens tokens = appTokens(context);
    return PremiumCard(
      padding: const EdgeInsets.all(18),
      hoverable: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 18),
          SizedBox(
            height: 96,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                for (int i = 0; i < 9; i += 1)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: <Color>[AppColors.primary, AppColors.accent],
                          ),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: SizedBox(height: 28 + (i % 5) * 14),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Divider(color: tokens.border),
          Text('On-prem throughput trend', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: tokens.textSecondary)),
        ],
      ),
    );
  }
}
