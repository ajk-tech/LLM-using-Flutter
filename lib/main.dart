import 'package:flutter/material.dart';

import 'demo_data.dart';
import 'theme.dart';
import 'widgets/premium_widgets.dart';

void main() {
  runApp(const MinisterAiDemo());
}

class MinisterAiDemo extends StatefulWidget {
  const MinisterAiDemo({super.key});

  @override
  State<MinisterAiDemo> createState() => _MinisterAiDemoState();
}

class _MinisterAiDemoState extends State<MinisterAiDemo> {
  AppLanguage _language = AppLanguage.english;
  SecurityTier _tier = SecurityTier.confidential;
  ThemeMode _themeMode = ThemeMode.light;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'On-Prem AI Chief-of-Staff',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: _themeMode,
      home: DemoShell(
        language: _language,
        tier: _tier,
        themeMode: _themeMode,
        onLanguageChanged: (AppLanguage value) => setState(() => _language = value),
        onTierChanged: (SecurityTier value) => setState(() => _tier = value),
        onThemeModeChanged: (ThemeMode value) => setState(() => _themeMode = value),
      ),
    );
  }
}

class DemoShell extends StatefulWidget {
  const DemoShell({
    required this.language,
    required this.tier,
    required this.themeMode,
    required this.onLanguageChanged,
    required this.onTierChanged,
    required this.onThemeModeChanged,
    super.key,
  });

  final AppLanguage language;
  final SecurityTier tier;
  final ThemeMode themeMode;
  final ValueChanged<AppLanguage> onLanguageChanged;
  final ValueChanged<SecurityTier> onTierChanged;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  @override
  State<DemoShell> createState() => _DemoShellState();
}

class _DemoShellState extends State<DemoShell> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    final AppCopy copy = AppCopy(widget.language);
    final List<NavItem> navItems = <NavItem>[
      NavItem(copy.search, Icons.travel_explore),
      NavItem(copy.drafting, Icons.edit_document),
      NavItem(copy.calendar, Icons.calendar_month),
      NavItem(copy.approvals, Icons.verified_user),
    ];
    final List<Widget> pages = <Widget>[
      RagSearchScreen(language: widget.language),
      DraftingStudio(language: widget.language),
      ExecutiveCalendar(language: widget.language),
      ApprovalCenter(language: widget.language),
    ];

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool desktop = constraints.maxWidth >= 1040;
        return Scaffold(
          appBar: AppBar(
            toolbarHeight: desktop ? 96 : 132,
            automaticallyImplyLeading: false,
            titleSpacing: 0,
            title: ClassificationHeader(
              copy: copy,
              language: widget.language,
              tier: widget.tier,
              themeMode: widget.themeMode,
              onLanguageChanged: widget.onLanguageChanged,
              onTierChanged: widget.onTierChanged,
              onThemeModeChanged: widget.onThemeModeChanged,
            ),
          ),
          body: Row(
            children: <Widget>[
              if (desktop)
                PremiumSidebar(
                  items: navItems,
                  selectedIndex: _tab,
                  onChanged: (int index) => setState(() => _tab = index),
                ),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 260),
                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeInCubic,
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(.015, .02),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      ),
                    );
                  },
                  child: KeyedSubtree(key: ValueKey<int>(_tab), child: pages[_tab]),
                ),
              ),
            ],
          ),
          bottomNavigationBar: desktop
              ? null
              : NavigationBar(
                  selectedIndex: _tab,
                  onDestinationSelected: (int index) => setState(() => _tab = index),
                  destinations: <NavigationDestination>[
                    for (final NavItem item in navItems)
                      NavigationDestination(icon: Icon(item.icon), label: item.label),
                  ],
                ),
        );
      },
    );
  }
}

class NavItem {
  const NavItem(this.label, this.icon);

  final String label;
  final IconData icon;
}

class PremiumSidebar extends StatelessWidget {
  const PremiumSidebar({
    required this.items,
    required this.selectedIndex,
    required this.onChanged,
    super.key,
  });

  final List<NavItem> items;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final AppThemeTokens tokens = appTokens(context);
    return Container(
      width: 284,
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 20),
      decoration: BoxDecoration(
        color: tokens.surface.withValues(alpha: .82),
        border: Border(right: BorderSide(color: tokens.border)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          PremiumCard(
            hoverable: false,
            padding: const EdgeInsets.all(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                AppColors.primary.withValues(alpha: .95),
                AppColors.secondary.withValues(alpha: .88),
                AppColors.accent.withValues(alpha: .82),
              ],
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Icon(Icons.auto_awesome, color: Colors.white),
                SizedBox(height: 18),
                Text(
                  'Secure AI Workspace',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900),
                ),
                SizedBox(height: 6),
                Text(
                  'Air-gapped intelligence surface',
                  style: TextStyle(color: Colors.white70, height: 1.4),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          for (int i = 0; i < items.length; i += 1)
            SidebarButton(
              item: items[i],
              selected: i == selectedIndex,
              onPressed: () => onChanged(i),
            ),
          const Spacer(),
          ChartPlaceholder(title: 'GPU queue'),
        ],
      ),
    );
  }
}

class SidebarButton extends StatefulWidget {
  const SidebarButton({
    required this.item,
    required this.selected,
    required this.onPressed,
    super.key,
  });

  final NavItem item;
  final bool selected;
  final VoidCallback onPressed;

  @override
  State<SidebarButton> createState() => _SidebarButtonState();
}

class _SidebarButtonState extends State<SidebarButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final AppThemeTokens tokens = appTokens(context);
    final bool active = widget.selected || _hovered;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: InkWell(
          onTap: widget.onPressed,
          borderRadius: BorderRadius.circular(16),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 170),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            decoration: BoxDecoration(
              color: widget.selected
                  ? AppColors.primary.withValues(alpha: .12)
                  : active
                      ? tokens.elevated
                      : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: widget.selected ? AppColors.primary.withValues(alpha: .22) : Colors.transparent,
              ),
            ),
            child: Row(
              children: <Widget>[
                Icon(widget.item.icon, color: widget.selected ? AppColors.primary : tokens.textSecondary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.item.label,
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: widget.selected ? AppColors.primary : Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ClassificationHeader extends StatelessWidget {
  const ClassificationHeader({
    required this.copy,
    required this.language,
    required this.tier,
    required this.themeMode,
    required this.onLanguageChanged,
    required this.onTierChanged,
    required this.onThemeModeChanged,
    super.key,
  });

  final AppCopy copy;
  final AppLanguage language;
  final SecurityTier tier;
  final ThemeMode themeMode;
  final ValueChanged<AppLanguage> onLanguageChanged;
  final ValueChanged<SecurityTier> onTierChanged;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  @override
  Widget build(BuildContext context) {
    final AppThemeTokens tokens = appTokens(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
      child: PremiumCard(
        hoverable: false,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        radius: 24,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            tier.color,
            AppColors.primary,
            AppColors.secondary.withValues(alpha: .92),
          ],
        ),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final bool compact = constraints.maxWidth < 720;
            final Widget titleBlock = Row(
              children: <Widget>[
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: .16),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.white.withValues(alpha: .24)),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(11),
                    child: Icon(Icons.security, color: Colors.white),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        copy.appTitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        copy.office,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],
            );
            final Widget controls = Wrap(
              spacing: 10,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              alignment: compact ? WrapAlignment.end : WrapAlignment.start,
              children: <Widget>[
                StatusBadge(label: tier.label(language), color: Colors.white, icon: Icons.shield),
                HeaderMenu<SecurityTier>(
                  value: tier,
                  items: SecurityTier.values,
                  labelFor: (SecurityTier value) => value.label(language),
                  onChanged: onTierChanged,
                ),
                SegmentedButton<AppLanguage>(
                  segments: const <ButtonSegment<AppLanguage>>[
                    ButtonSegment<AppLanguage>(value: AppLanguage.english, label: Text('EN')),
                    ButtonSegment<AppLanguage>(value: AppLanguage.hindi, label: Text('हि')),
                  ],
                  selected: <AppLanguage>{language},
                  onSelectionChanged: (Set<AppLanguage> values) => onLanguageChanged(values.first),
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(tokens.surface.withValues(alpha: .92)),
                  ),
                ),
                IconButton.filledTonal(
                  tooltip: themeMode == ThemeMode.dark ? 'Light theme' : 'Dark theme',
                  onPressed: () {
                    onThemeModeChanged(themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark);
                  },
                  icon: Icon(themeMode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode),
                ),
              ],
            );
            if (compact) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  titleBlock,
                  const SizedBox(height: 12),
                  controls,
                ],
              );
            }
            return Row(
              children: <Widget>[
                Expanded(child: titleBlock),
                const SizedBox(width: 18),
                controls,
              ],
            );
          },
        ),
      ),
    );
  }
}

class HeaderMenu<T> extends StatelessWidget {
  const HeaderMenu({
    required this.value,
    required this.items,
    required this.labelFor,
    required this.onChanged,
    super.key,
  });

  final T value;
  final List<T> items;
  final String Function(T value) labelFor;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    final AppThemeTokens tokens = appTokens(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: tokens.surface.withValues(alpha: .92),
        borderRadius: BorderRadius.circular(14),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          borderRadius: BorderRadius.circular(16),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          items: <DropdownMenuItem<T>>[
            for (final T item in items)
              DropdownMenuItem<T>(
                value: item,
                child: Text(labelFor(item)),
              ),
          ],
          onChanged: (T? selected) {
            if (selected != null) {
              onChanged(selected);
            }
          },
        ),
      ),
    );
  }
}

class ScreenScaffold extends StatelessWidget {
  const ScreenScaffold({
    required this.header,
    required this.children,
    super.key,
  });

  final Widget header;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(24, 10, 24, 24),
          sliver: SliverToBoxAdapter(child: header),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 28),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                if (index.isOdd) {
                  return const SizedBox(height: 18);
                }
                return children[index ~/ 2];
              },
              childCount: children.isEmpty ? 0 : children.length * 2 - 1,
            ),
          ),
        ),
      ],
    );
  }
}

enum CoreMode { public, private }

extension CoreModeLabel on CoreMode {
  String label(AppLanguage language) {
    switch (this) {
      case CoreMode.public:
        return language == AppLanguage.hindi ? 'PUBLIC कोर' : 'PUBLIC Core';
      case CoreMode.private:
        return language == AppLanguage.hindi ? 'PRIVATE कोर' : 'PRIVATE Core';
    }
  }
}

class RagSearchScreen extends StatefulWidget {
  const RagSearchScreen({required this.language, super.key});

  final AppLanguage language;

  @override
  State<RagSearchScreen> createState() => _RagSearchScreenState();
}

class _RagSearchScreenState extends State<RagSearchScreen> {
  CoreMode _selectedCore = CoreMode.public;

  @override
  Widget build(BuildContext context) {
    final AppCopy copy = AppCopy(widget.language);
    final ChatReply activeReply = _selectedCore == CoreMode.public ? publicReply : privateReply;
    final String activeTitle = _selectedCore == CoreMode.public ? copy.publicCore : copy.privateCore;

    return ScreenScaffold(
      header: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SectionHeader(
            title: copy.search,
            subtitle: widget.language == AppLanguage.hindi
                ? 'स्रोत-अनुसार खोज कोर चुनें और आरएजी उत्तर देखें।'
                : 'Choose the active retrieval core and view RAG answers.',
          ),
          const SizedBox(height: 18),
          ResponsiveMetrics(
            cards: const <MetricCard>[
              MetricCard(label: 'Citations resolved', value: '128', trend: '+12%', icon: Icons.link, color: AppColors.primary),
              MetricCard(label: 'Avg latency', value: '3.2s', trend: '-8%', icon: Icons.bolt, color: AppColors.accent),
              MetricCard(label: 'GPU queue', value: '3/12', trend: '+2', icon: Icons.memory, color: AppColors.warning),
            ],
          ),
          const SizedBox(height: 18),
          PremiumCard(
            hoverable: false,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(copy.coreModeSelection, style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 6),
                      Text(copy.coreModeInstructions, style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ),
                const SizedBox(width: 14),
                SegmentedButton<CoreMode>(
                  segments: <ButtonSegment<CoreMode>>[
                    ButtonSegment<CoreMode>(value: CoreMode.public, label: Text(CoreMode.public.label(widget.language))),
                    ButtonSegment<CoreMode>(value: CoreMode.private, label: Text(CoreMode.private.label(widget.language))),
                  ],
                  selected: <CoreMode>{_selectedCore},
                  onSelectionChanged: (Set<CoreMode> values) {
                    if (values.isNotEmpty) {
                      setState(() => _selectedCore = values.first);
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          PremiumCard(
            hoverable: false,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(copy.agentToolsTitle, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 6),
                Text(copy.agentToolsSubtitle, style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: 18),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: _AgentToolsColumn(
                        title: copy.communicationAgent,
                        items: <String>[copy.emailAgent, copy.sendMail, copy.readMail, copy.summarizeMail],
                        icon: Icons.email_outlined,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _AgentToolsColumn(
                        title: copy.whatsAppAgent,
                        items: <String>[copy.sendWhatsApp, copy.scheduleWhatsApp],
                        icon: Icons.message_outlined,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _AgentToolsColumn(
                        title: copy.calendarAgent,
                        items: <String>[copy.createMeeting, copy.updateMeeting, copy.cancelMeeting],
                        icon: Icons.calendar_today_outlined,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      children: <Widget>[
        ChatPane(title: activeTitle, reply: activeReply, language: widget.language, icon: _selectedCore == CoreMode.public ? Icons.public : Icons.lock_person),
      ],
    );
  }
}

class _AgentToolsColumn extends StatelessWidget {
  const _AgentToolsColumn({
    required this.title,
    required this.items,
    required this.icon,
    super.key,
  });

  final String title;
  final List<String> items;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final AppThemeTokens tokens = appTokens(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Icon(icon, color: AppColors.primary, size: 18),
            const SizedBox(width: 8),
            Text(title, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w900)),
          ],
        ),
        const SizedBox(height: 10),
        for (final String item in items)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: <Widget>[
                const Icon(Icons.check_circle_outline, size: 18, color: AppColors.success),
                const SizedBox(width: 10),
                Expanded(child: Text(item, style: Theme.of(context).textTheme.bodyMedium)),
              ],
            ),
          ),
      ],
    );
  }
}

class ResponsiveMetrics extends StatelessWidget {
  const ResponsiveMetrics({required this.cards, super.key});

  final List<MetricCard> cards;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool compact = constraints.maxWidth < 820;
        if (compact) {
          return Column(
            children: <Widget>[
              for (int i = 0; i < cards.length; i += 1) ...<Widget>[
                cards[i],
                if (i != cards.length - 1) const SizedBox(height: 12),
              ],
            ],
          );
        }
        return Row(
          children: <Widget>[
            for (int i = 0; i < cards.length; i += 1) ...<Widget>[
              Expanded(child: cards[i]),
              if (i != cards.length - 1) const SizedBox(width: 14),
            ],
          ],
        );
      },
    );
  }
}

class ChatMessage {
  ChatMessage({
    required this.text,
    required this.fromUser,
    this.citations = const <SourceCitation>[],
  });

  String text;
  final bool fromUser;
  final List<SourceCitation> citations;
}

class ChatPane extends StatefulWidget {
  const ChatPane({
    required this.title,
    required this.reply,
    required this.language,
    required this.icon,
    super.key,
  });

  final String title;
  final ChatReply reply;
  final AppLanguage language;
  final IconData icon;

  @override
  State<ChatPane> createState() => _ChatPaneState();
}

class _ChatPaneState extends State<ChatPane> {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = <ChatMessage>[];
  bool _loading = false;
  double _load = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final String query = _controller.text.trim();
    if (query.isEmpty || _loading) {
      return;
    }
    setState(() {
      _controller.clear();
      _messages.add(ChatMessage(text: query, fromUser: true));
      _loading = true;
      _load = .1;
    });
    for (int i = 1; i <= 30; i += 1) {
      await Future<void>.delayed(const Duration(milliseconds: 100));
      if (!mounted) {
        return;
      }
      setState(() => _load = i / 30);
    }

    final ChatMessage streaming = ChatMessage(
      text: '',
      fromUser: false,
      citations: widget.reply.citations,
    );
    setState(() => _messages.add(streaming));
    final List<String> words = widget.reply.text(widget.language).split(' ');
    for (final String word in words) {
      await Future<void>.delayed(const Duration(milliseconds: 42));
      if (!mounted) {
        return;
      }
      setState(() => streaming.text = '${streaming.text}$word ');
    }
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final AppCopy copy = AppCopy(widget.language);
    final AppThemeTokens tokens = appTokens(context);
    return PremiumCard(
      hoverable: false,
      child: SizedBox(
        height: 640,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: .12),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Icon(widget.icon, color: AppColors.primary),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(widget.title, style: Theme.of(context).textTheme.titleLarge),
                      Text(
                        copy.load,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: tokens.textSecondary),
                      ),
                    ],
                  ),
                ),
                StatusBadge(label: _loading ? 'Live' : 'Ready', color: _loading ? AppColors.warning : AppColors.success),
              ],
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 240),
              curve: Curves.easeOutCubic,
              child: _loading
                  ? Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: PremiumCard(
                        hoverable: false,
                        radius: 18,
                        padding: const EdgeInsets.all(16),
                        gradient: LinearGradient(
                          colors: <Color>[
                            AppColors.primary.withValues(alpha: .12),
                            AppColors.accent.withValues(alpha: .08),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Expanded(child: Text(copy.queue, style: Theme.of(context).textTheme.labelLarge)),
                                Text('${(_load * 100).round()}%'),
                              ],
                            ),
                            const SizedBox(height: 12),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(999),
                              child: LinearProgressIndicator(value: _load, minHeight: 8),
                            ),
                            const SizedBox(height: 14),
                            const SkeletonLines(),
                          ],
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _messages.isEmpty
                  ? EmptyState(
                      title: widget.language == AppLanguage.hindi ? 'सुरक्षित प्रश्न पूछें' : 'Ask a secure question',
                      subtitle: widget.language == AppLanguage.hindi
                          ? 'स्रोत उद्धरण और मेटाडाटा प्रत्येक उत्तर में दिखाई देंगे।'
                          : 'Source citations and metadata will appear in every generated answer.',
                      icon: Icons.manage_search,
                    )
                  : ListView.separated(
                      itemCount: _messages.length,
                      separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 12),
                      itemBuilder: (BuildContext context, int index) {
                        return ResponseBubble(message: _messages[index], language: widget.language);
                      },
                    ),
            ),
            const SizedBox(height: 16),
            SearchComposer(
              controller: _controller,
              hint: copy.askPlaceholder,
              buttonLabel: copy.send,
              loading: _loading,
              onSubmit: _submit,
            ),
          ],
        ),
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({
    required this.title,
    required this.subtitle,
    required this.icon,
    super.key,
  });

  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final AppThemeTokens tokens = appTokens(context);
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: <Color>[
                    AppColors.primary.withValues(alpha: .18),
                    AppColors.accent.withValues(alpha: .14),
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Icon(icon, color: AppColors.primary, size: 34),
              ),
            ),
            const SizedBox(height: 18),
            Text(title, textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: tokens.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchComposer extends StatelessWidget {
  const SearchComposer({
    required this.controller,
    required this.hint,
    required this.buttonLabel,
    required this.loading,
    required this.onSubmit,
    super.key,
  });

  final TextEditingController controller;
  final String hint;
  final String buttonLabel;
  final bool loading;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool compact = constraints.maxWidth < 560;
        final Widget input = TextField(
          controller: controller,
          onSubmitted: (_) => onSubmit(),
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: const Icon(Icons.search),
          ),
        );
        final Widget button = GradientButton(
          label: buttonLabel,
          icon: Icons.arrow_upward,
          onPressed: loading ? null : onSubmit,
          compact: compact,
        );
        if (compact) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              input,
              const SizedBox(height: 10),
              button,
            ],
          );
        }
        return Row(
          children: <Widget>[
            Expanded(child: input),
            const SizedBox(width: 12),
            SizedBox(width: 128, child: button),
          ],
        );
      },
    );
  }
}

class ResponseBubble extends StatelessWidget {
  const ResponseBubble({required this.message, required this.language, super.key});

  final ChatMessage message;
  final AppLanguage language;

  @override
  Widget build(BuildContext context) {
    final AppCopy copy = AppCopy(language);
    final AppThemeTokens tokens = appTokens(context);
    final bool user = message.fromUser;
    return Align(
      alignment: user ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 680),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: user
                ? const LinearGradient(colors: <Color>[AppColors.primary, AppColors.secondary])
                : null,
            color: user ? null : tokens.elevated,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: user ? Colors.transparent : tokens.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                message.text,
                style: TextStyle(color: user ? Colors.white : Theme.of(context).colorScheme.onSurface, height: 1.55),
              ),
              if (message.citations.isNotEmpty) ...<Widget>[
                const SizedBox(height: 12),
                Theme(
                  data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    tilePadding: EdgeInsets.zero,
                    childrenPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.link),
                    title: Text(copy.citations, style: const TextStyle(fontWeight: FontWeight.w900)),
                    children: <Widget>[
                      for (final SourceCitation citation in message.citations)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: PremiumCard(
                            hoverable: false,
                            radius: 16,
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const Icon(Icons.description_outlined, color: AppColors.primary),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(citation.title, style: Theme.of(context).textTheme.titleMedium),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${citation.documentId}\n${copy.metadata}: ${citation.repository} | ${citation.owner} | ${citation.updated}',
                                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: tokens.textSecondary),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class DraftingStudio extends StatefulWidget {
  const DraftingStudio({required this.language, super.key});

  final AppLanguage language;

  @override
  State<DraftingStudio> createState() => _DraftingStudioState();
}

class _DraftingStudioState extends State<DraftingStudio> {
  String _template = 'Parliament Answer Draft';

  String _draft(AppLanguage language) {
    if (language == AppLanguage.hindi) {
      return 'माननीय अध्यक्ष महोदय,\n\nमंत्रालय ने उपलब्ध सार्वजनिक अभिलेखों और निजी कार्यालय के सत्यापित नोट्स के आधार पर स्थिति की समीक्षा की है। प्रकाशित आँकड़े सेवा वितरण में निरंतर प्रगति दर्शाते हैं।\n\nआगे की कार्रवाई के लिए अंतर-मंत्रालयी सहमति और राज्य समन्वय को प्राथमिकता दी जाएगी।';
    }
    return 'Hon. Speaker Sir,\n\nThe Ministry has reviewed the matter using published records and verified notes from the private office. The available figures show continued progress in citizen service delivery.\n\nFurther action will prioritize inter-ministerial concurrence and state coordination.';
  }

  @override
  Widget build(BuildContext context) {
    final AppCopy copy = AppCopy(widget.language);
    return ScreenScaffold(
      header: SectionHeader(
        title: copy.drafting,
        subtitle: widget.language == AppLanguage.hindi
            ? 'सोर्स-ग्राउंडेड ड्राफ्ट, टेम्पलेट नियंत्रण और स्पष्ट प्रोवेनेंस।'
            : 'Source-grounded drafting with template control and visible provenance.',
      ),
      children: <Widget>[
        LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final bool wide = constraints.maxWidth >= 920;
            final Widget editor = DraftEditor(
              copy: copy,
              language: widget.language,
              draft: _draft(widget.language),
              template: _template,
              onTemplateChanged: (String value) => setState(() => _template = value),
            );
            final Widget chunks = SourceChunkPanel(copy: copy, language: widget.language);
            if (wide) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(flex: 3, child: editor),
                  const SizedBox(width: 18),
                  Expanded(flex: 2, child: chunks),
                ],
              );
            }
            return Column(
              children: <Widget>[
                editor,
                const SizedBox(height: 18),
                chunks,
              ],
            );
          },
        ),
      ],
    );
  }
}

class DraftEditor extends StatelessWidget {
  const DraftEditor({
    required this.copy,
    required this.language,
    required this.draft,
    required this.template,
    required this.onTemplateChanged,
    super.key,
  });

  final AppCopy copy;
  final AppLanguage language;
  final String draft;
  final String template;
  final ValueChanged<String> onTemplateChanged;

  @override
  Widget build(BuildContext context) {
    final AppThemeTokens tokens = appTokens(context);
    return PremiumCard(
      hoverable: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: template,
                  decoration: InputDecoration(labelText: copy.template),
                  items: const <DropdownMenuItem<String>>[
                    DropdownMenuItem<String>(value: 'Parliament Answer Draft', child: Text('Parliament Answer Draft')),
                    DropdownMenuItem<String>(value: 'Office Memorandum', child: Text('Office Memorandum')),
                  ],
                  onChanged: (String? value) {
                    if (value != null) {
                      onTemplateChanged(value);
                    }
                  },
                ),
              ),
              const SizedBox(width: 12),
              StatusBadge(label: language == AppLanguage.hindi ? 'द्विभाषी' : 'Bilingual', color: AppColors.accent, icon: Icons.translate),
            ],
          ),
          const SizedBox(height: 18),
          DecoratedBox(
            decoration: BoxDecoration(
              color: tokens.elevated,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: tokens.border),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      const Icon(Icons.edit_note, color: AppColors.primary),
                      const SizedBox(width: 10),
                      Text(template, style: Theme.of(context).textTheme.titleLarge),
                    ],
                  ),
                  const SizedBox(height: 18),
                  SelectableText(
                    draft,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 17, height: 1.75),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SourceChunkPanel extends StatelessWidget {
  const SourceChunkPanel({required this.copy, required this.language, super.key});

  final AppCopy copy;
  final AppLanguage language;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      hoverable: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(copy.sourcesUsed, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 14),
          for (final SourceChunk chunk in sourceChunks) ...<Widget>[
            PremiumCard(
              padding: const EdgeInsets.all(16),
              radius: 18,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      const Icon(Icons.article_outlined, color: AppColors.secondary),
                      const SizedBox(width: 10),
                      Expanded(child: Text(chunk.id, style: Theme.of(context).textTheme.titleMedium)),
                      StatusBadge(label: '${(chunk.confidence * 100).round()}%', color: AppColors.success),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(chunk.title, style: const TextStyle(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 6),
                  Text(chunk.body(language), style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: appTokens(context).textSecondary)),
                ],
              ),
            ),
            if (chunk != sourceChunks.last) const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class ExecutiveCalendar extends StatefulWidget {
  const ExecutiveCalendar({required this.language, super.key});

  final AppLanguage language;

  @override
  State<ExecutiveCalendar> createState() => _ExecutiveCalendarState();
}

class _ExecutiveCalendarState extends State<ExecutiveCalendar> {
  bool _masked = true;

  @override
  Widget build(BuildContext context) {
    final AppCopy copy = AppCopy(widget.language);
    return ScreenScaffold(
      header: SectionHeader(
        title: copy.calendar,
        subtitle: widget.language == AppLanguage.hindi
            ? 'संवेदनशील विवरणों के लिए प्रस्तुति-सुरक्षित मास्किंग के साथ निजी कार्यालय कार्यक्रम।'
            : 'Private-office schedule with presentation-safe masking for sensitive details.',
        action: FilledButton.tonalIcon(
          onPressed: () => setState(() => _masked = !_masked),
          icon: Icon(_masked ? Icons.visibility_off : Icons.visibility),
          label: Text(copy.maskSensitive),
        ),
      ),
      children: <Widget>[
        ResponsiveMetrics(
          cards: const <MetricCard>[
            MetricCard(label: 'Briefings today', value: '08', trend: '+3', icon: Icons.event_note, color: AppColors.primary),
            MetricCard(label: 'Masked events', value: '02', trend: 'Safe', icon: Icons.lock, color: AppColors.error),
            MetricCard(label: 'Public slots', value: '04', trend: '+1', icon: Icons.groups, color: AppColors.success),
          ],
        ),
        PremiumCard(
          hoverable: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                widget.language == AppLanguage.hindi ? 'शनिवार, 6 जून 2026' : 'Saturday, 6 June 2026',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 18),
              for (final CalendarEvent event in calendarEvents) ...<Widget>[
                CalendarTile(event: event, copy: copy, language: widget.language, masked: _masked),
                if (event != calendarEvents.last) const SizedBox(height: 12),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class CalendarTile extends StatelessWidget {
  const CalendarTile({
    required this.event,
    required this.copy,
    required this.language,
    required this.masked,
    super.key,
  });

  final CalendarEvent event;
  final AppCopy copy;
  final AppLanguage language;
  final bool masked;

  @override
  Widget build(BuildContext context) {
    final bool redact = masked && event.sensitive;
    final AppThemeTokens tokens = appTokens(context);
    return PremiumCard(
      padding: EdgeInsets.zero,
      radius: 18,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Row(
          children: <Widget>[
            SizedBox(width: 6, height: 96, child: ColoredBox(color: event.tier.color)),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: 66,
                      child: Text(event.time, style: Theme.of(context).textTheme.titleLarge),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 220),
                            child: redact
                                ? Row(
                                    key: const ValueKey<String>('redacted'),
                                    children: <Widget>[
                                      const Icon(Icons.lock, size: 18, color: AppColors.error),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(copy.masked, style: const TextStyle(fontWeight: FontWeight.w900)),
                                      ),
                                    ],
                                  )
                                : Text(
                                    event.title(language),
                                    key: const ValueKey<String>('visible'),
                                    style: const TextStyle(fontWeight: FontWeight.w900),
                                  ),
                          ),
                          const SizedBox(height: 6),
                          Text(redact ? copy.locationMasked : event.location, style: TextStyle(color: tokens.textSecondary)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    StatusBadge(label: event.tier.label(language), color: event.tier.color),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ApprovalCenter extends StatefulWidget {
  const ApprovalCenter({required this.language, super.key});

  final AppLanguage language;

  @override
  State<ApprovalCenter> createState() => _ApprovalCenterState();
}

class _ApprovalCenterState extends State<ApprovalCenter> {
  final Set<String> _processing = <String>{};
  final Set<String> _done = <String>{};

  Future<void> _approve(ApprovalDraft draft) async {
    setState(() => _processing.add(draft.id));
    await Future<void>.delayed(const Duration(seconds: 2));
    if (!mounted) {
      return;
    }
    setState(() {
      _processing.remove(draft.id);
      _done.add(draft.id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppCopy(widget.language).success)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppCopy copy = AppCopy(widget.language);
    return ScreenScaffold(
      header: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SectionHeader(
            title: copy.approvals,
            subtitle: widget.language == AppLanguage.hindi
                ? 'मानव अनुमोदन के बाद ही आउटबाउंड ब्रोकर को ईग्रेस।'
                : 'Human approval gate before egressing drafts to the outbound broker.',
          ),
          const SizedBox(height: 18),
          ResponsiveMetrics(
            cards: const <MetricCard>[
              MetricCard(label: 'Pending review', value: '02', trend: 'Now', icon: Icons.pending_actions, color: AppColors.warning),
              MetricCard(label: 'Approved today', value: '11', trend: '+18%', icon: Icons.verified, color: AppColors.success),
              MetricCard(label: 'Policy blocks', value: '00', trend: 'Clear', icon: Icons.policy, color: AppColors.primary),
            ],
          ),
        ],
      ),
      children: <Widget>[
        PremiumCard(
          hoverable: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(copy.outgoingQueue, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              for (final ApprovalDraft draft in approvalDrafts) ...<Widget>[
                ApprovalTile(
                  draft: draft,
                  language: widget.language,
                  processing: _processing.contains(draft.id),
                  done: _done.contains(draft.id),
                  onApprove: () => _approve(draft),
                ),
                if (draft != approvalDrafts.last) const SizedBox(height: 12),
              ],
            ],
          ),
        ),
        ActivityTimeline(language: widget.language),
      ],
    );
  }
}

class ApprovalTile extends StatelessWidget {
  const ApprovalTile({
    required this.draft,
    required this.language,
    required this.processing,
    required this.done,
    required this.onApprove,
    super.key,
  });

  final ApprovalDraft draft;
  final AppLanguage language;
  final bool processing;
  final bool done;
  final VoidCallback onApprove;

  @override
  Widget build(BuildContext context) {
    final AppCopy copy = AppCopy(language);
    final AppThemeTokens tokens = appTokens(context);
    return PremiumCard(
      padding: const EdgeInsets.all(18),
      radius: 18,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final bool compact = constraints.maxWidth < 760;
          final Widget body = Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              DecoratedBox(
                decoration: BoxDecoration(
                  color: (done ? AppColors.success : AppColors.primary).withValues(alpha: .12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Icon(done ? Icons.check_circle : Icons.outbox, color: done ? AppColors.success : AppColors.primary),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: <Widget>[
                        StatusBadge(label: draft.type, color: AppColors.secondary),
                        StatusBadge(label: done ? 'Approved' : 'Pending HITL', color: done ? AppColors.success : AppColors.warning),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(draft.subject(language), style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 6),
                    Text(draft.recipient, style: TextStyle(color: tokens.textSecondary, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 6),
                    Text(draft.preview(language), style: TextStyle(color: tokens.textSecondary)),
                    AnimatedSize(
                      duration: const Duration(milliseconds: 220),
                      child: processing
                          ? const Padding(
                              padding: EdgeInsets.only(top: 14),
                              child: SkeletonLines(),
                            )
                          : const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
            ],
          );
          final Widget action = GradientButton(
            label: processing ? copy.processing : copy.approve,
            icon: done ? Icons.verified : Icons.approval,
            onPressed: processing || done ? null : onApprove,
          );
          if (compact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                body,
                const SizedBox(height: 16),
                action,
              ],
            );
          }
          return Row(
            children: <Widget>[
              Expanded(child: body),
              const SizedBox(width: 18),
              SizedBox(width: 310, child: action),
            ],
          );
        },
      ),
    );
  }
}

class ActivityTimeline extends StatelessWidget {
  const ActivityTimeline({required this.language, super.key});

  final AppLanguage language;

  @override
  Widget build(BuildContext context) {
    final AppThemeTokens tokens = appTokens(context);
    final List<String> items = language == AppLanguage.hindi
        ? <String>['नीति उद्धरण सत्यापित', 'निजी नोट परिशिष्ट जोड़ा गया', 'ईग्रेस ब्रोकर स्वास्थ्य सामान्य']
        : <String>['Policy citations verified', 'Private-note annex attached', 'Outbound broker health nominal'];
    return PremiumCard(
      hoverable: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(language == AppLanguage.hindi ? 'गतिविधि टाइमलाइन' : 'Activity Timeline', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          for (int i = 0; i < items.length; i += 1)
            Padding(
              padding: EdgeInsets.only(bottom: i == items.length - 1 ? 0 : 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: .12),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(7),
                          child: Icon(Icons.check, color: AppColors.primary, size: 16),
                        ),
                      ),
                      if (i != items.length - 1)
                        SizedBox(
                          height: 26,
                          child: VerticalDivider(color: tokens.border),
                        ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(items[i], style: Theme.of(context).textTheme.bodyMedium),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
