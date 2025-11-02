import 'package:flutter/material.dart';
import 'archive_screen.dart';

class TodayScreen extends StatelessWidget {
  const TodayScreen({super.key});

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
              child: _buildTimeline(),
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
                    day['day']!,
                    style: TextStyle(
                      color: isSelected ? Colors.black : Colors.grey[500],
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    day['date']!,
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

  Widget _buildTimeline() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildTimelineItem(
              time: '08:00 AM',
              duration: '30m',
              title: '',
              isPast: true,
            ),
            _buildTimelineItem(
              time: '9:15 AM',
              duration: '30m',
              title: 'Weekly catch-up',
              hasNotification: true,
              hasCalendar: true,
              hasTimer: true,
            ),
            _buildTimelineItem(
              time: '10:00 AM',
              duration: '2h',
              title: 'Finalize slides for the conference',
              isHighlighted: true,
              hasNotification: true,
              currentTime: '11:23 AM',
            ),
            _buildTimelineItem(
              time: '12:30 PM',
              duration: '1h 15m',
              title: 'Lunch with Sofia',
              emoji: '🍕',
              hasLock: true,
              hasTimer: true,
            ),
            _buildFreeTime(),
            _buildTimelineItem(
              time: '',
              duration: '',
              title: 'Goals progress review',
              hasNotification: true,
              isLast: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineItem({
    required String time,
    required String duration,
    required String title,
    bool isPast = false,
    bool isHighlighted = false,
    bool hasNotification = false,
    bool hasCalendar = false,
    bool hasTimer = false,
    bool hasLock = false,
    String? emoji,
    String? currentTime,
    bool isLast = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline left side
        SizedBox(
          width: 80,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (time.isNotEmpty)
                Text(
                  time,
                  style: TextStyle(
                    color: isPast ? Colors.grey[700] : Colors.grey[400],
                    fontSize: 12,
                  ),
                ),
              if (duration.isNotEmpty)
                Text(
                  duration,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 11,
                  ),
                ),
            ],
          ),
        ),
        // Timeline indicator
        Column(
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isHighlighted ? Colors.transparent : const Color(0xFF2C2C2E),
                border: Border.all(
                  color: isHighlighted ? Colors.white : Colors.grey[700]!,
                  width: isHighlighted ? 3 : 2,
                ),
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: isHighlighted ? 180 : 80,
                decoration: BoxDecoration(
                  gradient: currentTime != null
                      ? const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.white, Colors.grey],
                        )
                      : null,
                  color: currentTime == null ? Colors.grey[800] : null,
                ),
              ),
          ],
        ),
        const SizedBox(width: 12),
        // Task card
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isHighlighted
                        ? const Color(0xFFB8B5FF)
                        : const Color(0xFF2C2C2E),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                if (emoji != null) ...[
                                  Text(
                                    emoji,
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                  const SizedBox(width: 8),
                                ],
                                Expanded(
                                  child: Text(
                                    title,
                                    style: TextStyle(
                                      color: isHighlighted ? Colors.black : Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              if (hasNotification)
                                Icon(
                                  Icons.notifications_none,
                                  color: isHighlighted ? Colors.black : Colors.grey[400],
                                  size: 20,
                                ),
                              if (hasCalendar) ...[
                                const SizedBox(width: 8),
                                Icon(
                                  Icons.calendar_today_outlined,
                                  color: Colors.grey[400],
                                  size: 18,
                                ),
                              ],
                              if (hasTimer) ...[
                                const SizedBox(width: 8),
                                Icon(
                                  Icons.timer_outlined,
                                  color: Colors.grey[400],
                                  size: 20,
                                ),
                              ],
                              if (hasLock) ...[
                                const SizedBox(width: 8),
                                Icon(
                                  Icons.lock_outline,
                                  color: Colors.grey[400],
                                  size: 18,
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                      if (currentTime != null) ...[
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFF6B6B),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                currentTime,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              '$time  $duration',
                              style: TextStyle(
                                color: Colors.black.withOpacity(0.6),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ] else if (!isHighlighted && time.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          '$time  $duration',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFreeTime() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          const SizedBox(width: 80),
          Icon(
            Icons.hourglass_empty,
            color: Colors.grey[600],
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            '3h 15m',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'Free time',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
