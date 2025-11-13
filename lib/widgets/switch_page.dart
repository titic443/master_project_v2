import 'package:flutter/material.dart';

class SwitchWidgetDemo extends StatefulWidget {
  const SwitchWidgetDemo({super.key});

  @override
  State<SwitchWidgetDemo> createState() => _SwitchWidgetDemoState();
}

class _SwitchWidgetDemoState extends State<SwitchWidgetDemo> {
  bool _wifiEnabled = true;
  bool _bluetoothEnabled = false;
  bool _airplaneMode = false;
  bool _notifications = true;
  bool _darkMode = false;
  bool _autoSync = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Switch Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Basic Switches',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Wi-Fi'),
                          Switch(
                            key: const Key('wifi_switch'),
                            value: _wifiEnabled,
                            onChanged: (value) {
                              setState(() {
                                _wifiEnabled = value;
                              });
                            },
                          ),
                        ],
                      ),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Bluetooth'),
                          Switch(
                            key: const Key('bluetooth_switch'),
                            value: _bluetoothEnabled,
                            onChanged: (value) {
                              setState(() {
                                _bluetoothEnabled = value;
                              });
                            },
                          ),
                        ],
                      ),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Airplane Mode'),
                          Switch(
                            key: const Key('airplane_switch'),
                            value: _airplaneMode,
                            onChanged: (value) {
                              setState(() {
                                _airplaneMode = value;
                                if (value) {
                                  _wifiEnabled = false;
                                  _bluetoothEnabled = false;
                                }
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'SwitchListTile',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SwitchListTile(
                        key: const Key('notifications_switch'),
                        title: const Text('Notifications'),
                        subtitle: const Text('Enable push notifications'),
                        value: _notifications,
                        onChanged: (value) {
                          setState(() {
                            _notifications = value;
                          });
                        },
                      ),
                      SwitchListTile(
                        key: const Key('dark_mode_switch'),
                        title: const Text('Dark Mode'),
                        subtitle: const Text('Use dark theme'),
                        value: _darkMode,
                        secondary: Icon(
                          _darkMode ? Icons.dark_mode : Icons.light_mode,
                          color: _darkMode ? Colors.blue : Colors.orange,
                        ),
                        onChanged: (value) {
                          setState(() {
                            _darkMode = value;
                          });
                        },
                      ),
                      SwitchListTile(
                        key: const Key('auto_sync_switch'),
                        title: const Text('Auto Sync'),
                        subtitle: const Text('Automatically sync data'),
                        value: _autoSync,
                        secondary: const Icon(Icons.sync),
                        onChanged: (value) {
                          setState(() {
                            _autoSync = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Styled Switches',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Custom Colors'),
                          Switch(
                            key: const Key('custom_color_switch'),
                            value: _wifiEnabled,
                            activeColor: Colors.green,
                            onChanged: (value) {
                              setState(() {
                                _wifiEnabled = value;
                              });
                            },
                          ),
                        ],
                      ),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Disabled Switch'),
                          Switch(
                            key: const Key('disabled_switch'),
                            value: false,
                            onChanged: null,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Status Summary',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        key: const Key('status_summary_text'),
                        'Wi-Fi: ${_wifiEnabled ? 'Enabled' : 'Disabled'}\n'
                        'Bluetooth: ${_bluetoothEnabled ? 'Enabled' : 'Disabled'}\n'
                        'Airplane Mode: ${_airplaneMode ? 'Enabled' : 'Disabled'}\n'
                        'Notifications: ${_notifications ? 'Enabled' : 'Disabled'}\n'
                        'Dark Mode: ${_darkMode ? 'Enabled' : 'Disabled'}\n'
                        'Auto Sync: ${_autoSync ? 'Enabled' : 'Disabled'}',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Quick Actions',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            key: const Key('enable_all_button'),
                            onPressed: () {
                              setState(() {
                                _wifiEnabled = true;
                                _bluetoothEnabled = true;
                                _notifications = true;
                                _autoSync = true;
                                _airplaneMode = false;
                              });
                            },
                            child: const Text('Enable All'),
                          ),
                          ElevatedButton(
                            key: const Key('disable_all_button'),
                            onPressed: () {
                              setState(() {
                                _wifiEnabled = false;
                                _bluetoothEnabled = false;
                                _notifications = false;
                                _autoSync = false;
                                _airplaneMode = false;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Disable All'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
