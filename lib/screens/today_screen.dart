import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'archive_screen.dart';

class TodayScreen extends StatefulWidget {
  const TodayScreen({super.key});

  @override
  State<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends State<TodayScreen> {
  final PageController _pageController = PageController(
    viewportFraction: 0.85,
    initialPage: DateTime.now().hour,
  );

  // Sample hourly tasks - will be replaced with real data later
  final List<HourlyTask> tasks = List.generate(24, (index) {
    // Add some sample tasks
    if (index == 8) {
      return HourlyTask(
        hour: index,
        title: 'Morning Routine',
        emoji: '☀️',
        duration: 1,
      );
    } else if (index == 9) {
      return HourlyTask(
        hour: index,
        title: 'Work Block',
        emoji: '💼',
        duration: 4,
        isBlock: true,
      );
    } else if (index == 13) {
      return HourlyTask(
        hour: index,
        title: 'Lunch Break',
        emoji: '🍕',
        duration: 1,
      );
    } else if (index == 17) {
      return HourlyTask(
        hour: index,
        title: 'Gym',
        emoji: '💪',
        duration: 1,
      );
    } else if (index == 23) {
      return HourlyTask(
        hour: index,
        title: 'Sleep',
        emoji: '😴',
        duration: 8,
        isBlock: true,
      );
    }
    return HourlyTask(hour: index, title: '', duration: 1);
  });

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1E),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            _buildWeekCalendar(),
            Expanded(
              child: _buildCarouselTimeline(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Text(
                'Today ',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                '3/7',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ArchiveScreen(),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2C2C2E),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.archive_outlined,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF2C2C2E),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.view_module_outlined,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeekCalendar() {
    final days = [
      {'day': 'Mon', 'date': '15'},
      {'day': 'Tue', 'date': '16', 'selected': true},
      {'day': 'Wed', 'date': '17'},
      {'day': 'Thu', 'date': '18'},
      {'day': 'Fri', 'date': '19'},
      {'day': 'Sat', 'date': '20'},
      {'day': 'Sun', 'date': '21'},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        height: 70,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: days.length,
          itemBuilder: (context, index) {
            final day = days[index];
            final isSelected = day['selected'] == true;
            return Container(
              width: 50,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFB8B5FF) : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    day['day'] as String,
                    style: TextStyle(
                      color: isSelected ? Colors.black : Colors.grey[500],
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    day['date'] as String,
                    style: TextStyle(
                      color: isSelected ? Colors.black : Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCarouselTimeline() {
    return Stack(
      children: [
        // Timeline line in the center background
        Positioned.fill(
          child: Center(
            child: Container(
              width: 2,
              margin: const EdgeInsets.symmetric(vertical: 40),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.grey[800]!,
                    Colors.grey[700]!,
                    Colors.grey[800]!,
                  ],
                ),
              ),
            ),
          ),
        ),
        // Carousel of tiles
        PageView.builder(
          controller: _pageController,
          scrollDirection: Axis.vertical,
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            return AnimatedBuilder(
              animation: _pageController,
              builder: (context, child) {
                double value = 1.0;
                if (_pageController.position.haveDimensions) {
                  value = _pageController.page! - index;
                  value = (1 - (value.abs() * 0.3)).clamp(0.7, 1.0);
                }

                return Center(
                  child: SizedBox(
                    height: Curves.easeInOut.transform(value) * 280,
                    child: child,
                  ),
                );
              },
              child: _buildHourlyTile(tasks[index]),
            );
          },
        ),
      ],
    );
  }

  Widget _buildHourlyTile(HourlyTask task) {
    final isCurrentHour = task.hour == DateTime.now().hour;
    final hasTask = task.title.isNotEmpty;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Circle indicator
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCurrentHour
                    ? const Color(0xFFB8B5FF)
                    : hasTask
                        ? const Color(0xFF2C2C2E)
                        : Colors.transparent,
                border: Border.all(
                  color: isCurrentHour
                      ? const Color(0xFFB8B5FF)
                      : hasTask
                          ? Colors.white.withOpacity(0.3)
                          : Colors.grey[800]!,
                  width: isCurrentHour ? 3 : 2,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Time label
            Text(
              _formatHour(task.hour),
              style: TextStyle(
                color: isCurrentHour ? const Color(0xFFB8B5FF) : Colors.grey[400],
                fontSize: 16,
                fontWeight: isCurrentHour ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            const SizedBox(height: 12),
            // Task card
            if (hasTask)
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: task.isBlock
                      ? const Color(0xFFB8B5FF).withOpacity(0.2)
                      : const Color(0xFF2C2C2E),
                  borderRadius: BorderRadius.circular(20),
                  border: task.isBlock
                      ? Border.all(
                          color: const Color(0xFFB8B5FF),
                          width: 2,
                        )
                      : null,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (task.emoji != null) ...[
                          Text(
                            task.emoji!,
                            style: const TextStyle(fontSize: 32),
                          ),
                          const SizedBox(width: 12),
                        ],
                        Flexible(
                          child: Text(
                            task.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    if (task.isBlock) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFB8B5FF).withOpacity(0.3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${task.duration} hour${task.duration > 1 ? 's' : ''} block',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              )
            else
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF2C2C2E).withOpacity(0.3),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.grey[800]!,
                    width: 1,
                  ),
                ),
                child: Text(
                  'Free time',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _formatHour(int hour) {
    if (hour == 0) return '12:00 AM';
    if (hour < 12) return '$hour:00 AM';
    if (hour == 12) return '12:00 PM';
    return '${hour - 12}:00 PM';
  }
}

// Data model for hourly tasks
class HourlyTask {
  final int hour;
  final String title;
  final String? emoji;
  final int duration; // in hours
  final bool isBlock;

  HourlyTask({
    required this.hour,
    required this.title,
    this.emoji,
    this.duration = 1,
    this.isBlock = false,
  });
}
