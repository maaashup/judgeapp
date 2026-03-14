import 'package:flutter/material.dart';
import 'package:mobile/core/theme/app_spacing.dart';
import 'package:mobile/core/utils/formatters.dart';
import 'package:mobile/core/widgets/app_icon_button.dart';
import 'package:mobile/core/widgets/app_text_field.dart';
import 'package:mobile/core/widgets/empty_state.dart';
import 'package:mobile/core/widgets/filter_chip_button.dart';
import 'package:mobile/main.dart';
import 'package:mobile/features/events/data/event.dart';
import 'package:mobile/features/events/data/event_options.dart';
import 'events_controller.dart';
import 'widgets/event_card.dart';
import 'widgets/event_form.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  final EventsController _controller = EventsController();
  final TextEditingController _searchController = TextEditingController();

  String _query = '';
  String? _gameFilter;

  List<Event> get _filteredEvents {
    return _controller.events.where((event) {
      if (_query.isNotEmpty &&
          !event.eventName.toLowerCase().contains(_query.toLowerCase())) {
        return false;
      }
      if (_gameFilter != null && event.game != _gameFilter) {
        return false;
      }
      return true;
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() => _query = _searchController.text.trim());
    });
    _controller.loadEvents();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _openForm([Event? existingEvent]) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (sheetContext) => EventForm(
        existingEvent: existingEvent,
        onSubmit: (data) async {
          Navigator.pop(sheetContext);

          try {
            if (existingEvent == null) {
              await _controller.createEvent(data);
            } else {
              await _controller.updateEvent(existingEvent.id, data);
            }
          } catch (e) {
            if (!mounted) return;
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Save failed: $e')));
          }
        },
      ),
    );
  }

  Future<void> _confirmDelete(Event event) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete event'),
        content: Text(
          'Are you sure you want to delete "${event.eventName}"?\nThis action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await _controller.deleteEvent(event.id);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Delete failed: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([_controller, themeController]),
      builder: (context, _) {
        final cs = Theme.of(context).colorScheme;
        final isDark = themeController.value == ThemeMode.dark;
        final events = _filteredEvents;

        return Scaffold(
          body: RefreshIndicator(
            onRefresh: _controller.loadEvents,
            color: cs.primary,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: _PageHeader(
                    countLabel: _controller.isLoading
                        ? 'Loading...'
                        : '${_controller.events.length} scheduled',
                    isDark: isDark,
                    onToggleTheme: themeController.toggle,
                    onRefresh: _controller.loadEvents,
                  ),
                ),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _StickyHeaderDelegate(
                    height: 64,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xl,
                        vertical: AppSpacing.xs,
                      ),
                      child: AppTextField(
                        controller: _searchController,
                        hintText: 'Search events...',
                        prefixIcon: Icon(
                          Icons.search_rounded,
                          color: cs.onSurface.withValues(alpha: 0.3),
                        ),
                        suffixIcon: _query.isNotEmpty
                            ? IconButton(
                                icon: Icon(
                                  Icons.close_rounded,
                                  color: cs.onSurface.withValues(alpha: 0.3),
                                ),
                                onPressed: _searchController.clear,
                              )
                            : null,
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: _GameFilterRow(
                    selectedGame: _gameFilter,
                    onSelect: (game) => setState(() => _gameFilter = game),
                  ),
                ),
                if (_controller.isLoading)
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (_controller.error != null)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: EmptyState(text: 'Error: ${_controller.error}'),
                  )
                else if (events.isEmpty)
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: EmptyState(text: 'No events found.'),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.xl,
                      AppSpacing.md,
                      AppSpacing.xl,
                      100,
                    ),
                    sliver: SliverList.separated(
                      itemCount: events.length,
                      separatorBuilder: (_, _) =>
                          const SizedBox(height: AppSpacing.lg),
                      itemBuilder: (_, index) {
                        final event = events[index];
                        return EventCard(
                          event: event,
                          onEdit: () => _openForm(event),
                          onDelete: () => _confirmDelete(event),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _openForm(),
            icon: const Icon(Icons.add_rounded),
            label: const Text(
              'New event',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        );
      },
    );
  }
}

class _PageHeader extends StatelessWidget {
  final String countLabel;
  final bool isDark;
  final VoidCallback onToggleTheme;
  final VoidCallback onRefresh;

  const _PageHeader({
    required this.countLabel,
    required this.isDark,
    required this.onToggleTheme,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.xl,
          40,
          AppSpacing.xl,
          AppSpacing.md,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Events',
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    countLabel,
                    style: TextStyle(
                      fontSize: 16,
                      color: cs.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ),
            AppIconButton(
              icon: isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
              onTap: onToggleTheme,
            ),
            AppIconButton(icon: Icons.refresh_rounded, onTap: onRefresh),
          ],
        ),
      ),
    );
  }
}

class _GameFilterRow extends StatelessWidget {
  final String? selectedGame;
  final ValueChanged<String?> onSelect;

  const _GameFilterRow({required this.selectedGame, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.md, bottom: AppSpacing.xs),
      child: SizedBox(
        height: 48,
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: AppSpacing.page,
          children: [
            FilterChipButton(
              label: 'All',
              isSelected: selectedGame == null,
              onTap: () => onSelect(null),
            ),
            ...eventGames.map(
              (game) => FilterChipButton(
                label: shortGameLabel(game),
                isSelected: selectedGame == game,
                onTap: () => onSelect(game),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double height;
  final Color backgroundColor;

  _StickyHeaderDelegate({
    required this.child,
    required this.height,
    required this.backgroundColor,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: backgroundColor,
      alignment: Alignment.center,
      child: child,
    );
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(covariant _StickyHeaderDelegate oldDelegate) => true;
}
