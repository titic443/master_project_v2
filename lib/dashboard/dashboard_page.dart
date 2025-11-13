import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});
  static const route = '/dashboard';

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedTab = 0;
  bool _showNotifications = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            key: const Key('dashboard_notifications_button'),
            icon: Badge(
              isLabelVisible: _showNotifications,
              label: const Text('3'),
              child: const Icon(Icons.notifications),
            ),
            onPressed: () {
              setState(() {
                _showNotifications = !_showNotifications;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(_showNotifications
                      ? 'Notifications enabled'
                      : 'Notifications disabled'),
                ),
              );
            },
          ),
          IconButton(
            key: const Key('dashboard_settings_button'),
            icon: const Icon(Icons.settings),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Settings clicked')),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWelcomeCard(),
              const SizedBox(height: 16),
              _buildStatsCards(),
              const SizedBox(height: 24),
              _buildQuickActions(),
              const SizedBox(height: 24),
              _buildRecentActivity(),
              const SizedBox(height: 24),
              _buildProgressSection(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        key: const Key('dashboard_bottom_nav'),
        currentIndex: _selectedTab,
        onTap: (index) {
          setState(() {
            _selectedTab = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Analytics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Card(
      elevation: 2,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue[700]!,
              Colors.blue[500]!,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'สวัสดี, ผู้ใช้งาน',
              key: Key('dashboard_welcome_text'),
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'ยินดีต้อนรับกลับมา! วันนี้คุณมี 5 งานที่ต้องทำ',
              key: const Key('dashboard_subtitle_text'),
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCards() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'งานทั้งหมด',
            '24',
            Icons.task_alt,
            Colors.purple,
            'dashboard_total_tasks',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'เสร็จสิ้น',
            '18',
            Icons.check_circle,
            Colors.green,
            'dashboard_completed_tasks',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'กำลังดำเนินการ',
            '6',
            Icons.pending,
            Colors.orange,
            'dashboard_pending_tasks',
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
    String keyPrefix,
  ) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              key: Key('${keyPrefix}_value'),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              key: Key('${keyPrefix}_label'),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'การดำเนินการด่วน',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                'เพิ่มงาน',
                Icons.add_circle,
                Colors.blue,
                'dashboard_add_task_button',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionButton(
                'รายงาน',
                Icons.bar_chart,
                Colors.green,
                'dashboard_report_button',
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                'ข้อความ',
                Icons.message,
                Colors.orange,
                'dashboard_message_button',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionButton(
                'ตั้งค่า',
                Icons.settings,
                Colors.purple,
                'dashboard_settings_action_button',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton(
    String label,
    IconData icon,
    Color color,
    String key,
  ) {
    return ElevatedButton(
      key: Key(key),
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$label clicked')),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: Column(
        children: [
          Icon(icon, size: 28),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildRecentActivity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'กิจกรรมล่าสุด',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Card(
          child: Column(
            children: [
              _buildActivityTile(
                'งานใหม่ถูกมอบหมาย',
                '5 นาทีที่แล้ว',
                Icons.assignment,
                Colors.blue,
                'dashboard_activity_1',
              ),
              const Divider(height: 1),
              _buildActivityTile(
                'คำขอได้รับการอนุมัติ',
                '1 ชั่วโมงที่แล้ว',
                Icons.check_circle,
                Colors.green,
                'dashboard_activity_2',
              ),
              const Divider(height: 1),
              _buildActivityTile(
                'ความคิดเห็นใหม่',
                '2 ชั่วโมงที่แล้ว',
                Icons.comment,
                Colors.orange,
                'dashboard_activity_3',
              ),
              const Divider(height: 1),
              _buildActivityTile(
                'อัปเดตระบบ',
                '5 ชั่วโมงที่แล้ว',
                Icons.system_update,
                Colors.purple,
                'dashboard_activity_4',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActivityTile(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    String key,
  ) {
    return ListTile(
      key: Key(key),
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(0.2),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$title clicked')),
        );
      },
    );
  }

  Widget _buildProgressSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'ความคืบหน้าโครงการ',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildProgressItem('โครงการ A', 0.75, Colors.blue),
                const SizedBox(height: 16),
                _buildProgressItem('โครงการ B', 0.45, Colors.green),
                const SizedBox(height: 16),
                _buildProgressItem('โครงการ C', 0.90, Colors.orange),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProgressItem(String title, double progress, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              key: Key('${title.toLowerCase().replaceAll(' ', '_')}_title'),
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            Text(
              '${(progress * 100).toInt()}%',
              key: Key('${title.toLowerCase().replaceAll(' ', '_')}_percentage'),
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            key: Key('${title.toLowerCase().replaceAll(' ', '_')}_progress'),
            value: progress,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 8,
          ),
        ),
      ],
    );
  }
}
