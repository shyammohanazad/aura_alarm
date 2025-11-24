import 'package:aura_alarm/theme_data.dart';
import 'package:flutter/material.dart';


class WorldClockHomePage extends StatefulWidget {
  const WorldClockHomePage({super.key});

  @override
  State<WorldClockHomePage> createState() => _WorldClockHomePageState();
}

class _WorldClockHomePageState extends State<WorldClockHomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  String _formatForUtcOffsetHours(int offsetHours) {
    final utcNow = DateTime.now().toUtc();
    final dt = utcNow.add(Duration(hours: offsetHours));
    final hour12 = (dt.hour % 12 == 0) ? 12 : (dt.hour % 12);
    final mm = dt.minute.toString().padLeft(2, '0');
    final hh = hour12.toString().padLeft(2, '0');
    final ampm = dt.hour >= 12 ? 'PM' : 'AM';
    return '$hh:$mm $ampm';
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final localHour12 = (now.hour % 12 == 0) ? 12 : (now.hour % 12);
    final timeFormat =
        "${localHour12.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')} ${now.hour >= 12 ? 'PM' : 'AM'}";

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: const Padding(
          padding: EdgeInsets.only(left: 16.0),
          child: Icon(Icons.menu, color: AppColors.textPrimary),
        ),
        title: Text(
          'WORLD CLOCK',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Local Time',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                timeFormat,
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),

              // Simple world clock list (static examples with UTC offsets)
              _WorldClockTile(
                city: 'New York, USA',
                offsetLabel: 'UTC-05:00',
                timeText: _formatForUtcOffsetHours(-5),
              ),
              _WorldClockTile(
                city: 'London, UK',
                offsetLabel: 'UTC±00:00',
                timeText: _formatForUtcOffsetHours(0),
              ),
              _WorldClockTile(
                city: 'Dubai, UAE',
                offsetLabel: 'UTC+04:00',
                timeText: _formatForUtcOffsetHours(4),
              ),
              _WorldClockTile(
                city: 'Tokyo, Japan',
                offsetLabel: 'UTC+09:00',
                timeText: _formatForUtcOffsetHours(9),
              ),
            ],
          ),
        ),
      ),
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.language_rounded, size: 24),
            label: 'Clock',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.alarm, size: 24),
            label: 'Alarm',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add, color: Colors.transparent),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.hourglass_empty, size: 24),
            label: 'Timer',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timer_outlined, size: 24),
            label: 'Stopwatch',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class _WorldClockTile extends StatelessWidget {
  final String city;
  final String offsetLabel;
  final String timeText;

  const _WorldClockTile({
    required this.city,
    required this.offsetLabel,
    required this.timeText,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.public, color: AppColors.textSecondary),
      title: Text(city, style: Theme.of(context).textTheme.titleMedium),
      subtitle: Text(offsetLabel, style: Theme.of(context).textTheme.bodySmall),
      trailing: Text(
        timeText,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
