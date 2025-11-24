import 'package:aura_alarm/clock_widget.dart';
import 'package:aura_alarm/theme_data.dart';
import 'package:aura_alarm/user_prefs.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // More accurate offsets including half hour for Kolkata
  final Map<String, Duration> _cityOffsetDurations = const {
    'London': Duration(hours: 0),
    'New York': Duration(hours: -5),
    'Kolkata': Duration(hours: 5, minutes: 30),
    'Tokyo': Duration(hours: 9),
    'Dubai': Duration(hours: 4),
  };

  String _selectedCity = 'London';

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    // Use user-selected country/city from user preferences (temporary hardcoded provider)
    final Duration userOffset = UserPrefs.utcOffset;
    final nowUtc = DateTime.now().toUtc();
    final cityNow = nowUtc.add(userOffset);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.background,
      drawer: _buildDrawer(context),
      drawerEdgeDragWidth: 100, // enables edge drag to open
      drawerScrimColor: Colors.black54,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColors.secondHand,
        elevation: 8,
        shape: const CircleBorder(),
        child: const Icon(
          Icons.add,
          color: AppColors.onDarkModeSurface,
          size: 30,
        ),
      ),
      floatingActionButtonLocation: const _LoweredCenterDockedFabLocation(6),
      bottomNavigationBar: BottomAppBar(
        color: AppColors.surface,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.language_rounded,
                label: 'Clock',
                active: true,
                onTap: () {},
              ),
              _NavItem(
                icon: Icons.alarm,
                label: 'Alarm',
                active: false,
                onTap: () {},
              ),
              const SizedBox(width: 56),
              _NavItem(
                icon: Icons.hourglass_empty,
                label: 'Timer',
                active: false,
                onTap: () {},
              ),
              _NavItem(
                icon: Icons.timer_outlined,
                label: 'Stopwatch',
                active: false,
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // First Row: breadcrumb left as a button to open drawer, title at right
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 12.0,
              ),
              child: Row(
                children: [
                  // Breadcrumb/Menu button (opens drawer) - circular elevated with inner depth
                  _CircularDepthButton(
                    onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                    icon: Icons.menu,
                  ),
                  const Spacer(),
                  // Title at right with padding
                  Padding(
                    padding: const EdgeInsets.only(right: 0),
                    child: Text(
                      'Aura ALarm',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                ],
              ),
            ),

            // Second Row: Local Time section
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 8.0,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Local Time',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 6),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              _formatTime(cityNow),
                              style: Theme.of(context).textTheme.displaySmall
                                  ?.copyWith(
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              UserPrefs.timeZoneAbbreviation, // e.g. IST
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Country name and flag
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        UserPrefs.countryFlag,
                        style: const TextStyle(fontSize: 28),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        UserPrefs.countryName,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Third Row: Analog clock with digital time inside dial
            Expanded(
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Place digital time slightly lower and draw clock above it so hands overlay text
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        // Provide a center overlay below hands via clock widget
                        AnalogClockWidget(
                          offset: userOffset,
                          centerOverlay: Padding(
                            padding: const EdgeInsets.only(top: 24.0),
                            child: Text(
                              _formatTime(cityNow),
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.w600,
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

            const SizedBox(height: 4),

            // Fourth Row: horizontally scrollable city buttons
            SizedBox(
              height: 64,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16).copyWith(bottom: 8),
                scrollDirection: Axis.horizontal,
                itemCount: _cityOffsetDurations.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final city = _cityOffsetDurations.keys.elementAt(index);
                  final isSelected = city == _selectedCity;
                  return ChoiceChip(
                    selected: isSelected,
                    label: Text(city),
                    onSelected: (_) {
                      setState(() {
                        _selectedCity = city;
                      });
                    },
                    selectedColor: AppColors.accent.withOpacity(0.25),
                    labelStyle: TextStyle(
                      color: isSelected
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                    backgroundColor: AppColors.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: isSelected
                            ? AppColors.accent
                            : AppColors.divider,
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final hour12 = (dt.hour % 12 == 0) ? 12 : (dt.hour % 12);
    final mm = dt.minute.toString().padLeft(2, '0');
    final hh = hour12.toString().padLeft(2, '0');
    final ampm = dt.hour >= 12 ? 'PM' : 'AM';
    return '$hh:$mm $ampm';
  }

  Drawer _buildDrawer(BuildContext context) {
    // Drawer that slides from left, covers ~55% width with left padding 20px
    final width = MediaQuery.of(context).size.width * 0.55;
    return Drawer(
      width: width,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, top: 24.0, right: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Menu', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.access_time),
              title: const Text('World Clock'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.alarm),
              title: const Text('Alarms'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.timer),
              title: const Text('Timer'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.hourglass_bottom),
              title: const Text('Stopwatch'),
              onTap: () {},
            ),
            const Spacer(),
            Text('Settings', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

class _FlagIcon extends StatelessWidget {
  final String city;
  const _FlagIcon({required this.city});

  @override
  Widget build(BuildContext context) {
    // Simple emoji flags as placeholders
    String emoji = '🌍';
    switch (city) {
      case 'London':
        emoji = '🇬🇧';
        break;
      case 'New York':
        emoji = '🇺🇸';
        break;
      case 'Kolkata':
        emoji = '🇮🇳';
        break;
      case 'Tokyo':
        emoji = '🇯🇵';
        break;
      case 'Dubai':
        emoji = '🇦🇪';
        break;
    }
    return Text(emoji, style: const TextStyle(fontSize: 28));
  }
}

class _CircularDepthButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  const _CircularDepthButton({required this.onPressed, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.surface,
        boxShadow: [
          // Outer shadow for elevation
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
          // Subtle top-left highlight for depth
          const BoxShadow(
            color: Colors.white10,
            blurRadius: 0,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onPressed,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Inner circle for inset depth
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.background,
                  boxShadow: [
                    // Inner shadow not supported; omit for compatibility
                  ],
                ),
              ),
              Icon(icon, color: AppColors.textPrimary),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoweredCenterDockedFabLocation extends FloatingActionButtonLocation {
  final double offsetY;
  const _LoweredCenterDockedFabLocation(this.offsetY);

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry geometry) {
    final base = FloatingActionButtonLocation.centerDocked;
    final baseOffset = base.getOffset(geometry);
    return Offset(baseOffset.dx, baseOffset.dy + offsetY);
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _NavItem({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = active
        ? AppColors.onDarkModeSurface
        : AppColors.textSecondary;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(color: color, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
