
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:event_tracker_flutter/event_tracker_flutter.dart';
// pub dev code

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ── Initialise the SDK once at app startup ──────────────────────────────
  await EventTrackerFlutter.initialize(
    eventKey: 'YOUR_EVENT_KEY', // replace with your key
    debug: false,
  );

  runApp(const MyApp());

  
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Event Tracker Demo',
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: const LoginScreen(),
    );
  }
}



// ── Home Screen ─────────────────────────────────────────────────────────────

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> _log = [];

  

  @override
  void initState() {
    super.initState();
    _trackScreenView('HomeScreen');
  }

Future<void> _testPageMethod() async {
  await EventTrackerFlutter.page(
    'HomeScreen',
    properties: {
      'screen_class': 'HomeScreen',
      'source': 'manual_page_button',
    },
  );

  _addLog('page() → HomeScreen');
}

Future<void> _testFlush() async {
  await EventTrackerFlutter.flush();

  _addLog('flush() called');
}
  

Future<void> _trackScreenView(String screenName) async {
  try {
    await EventTrackerFlutter.track(
      eventName: 'page_view',
      properties: {'screen_name': screenName},
    );
    _addLog('page_view → screen_name: $screenName');
  } catch (e) {
    _addLog('page_view failed: $e');
  }
}
  

Future<void> _trackButtonClick(String buttonName) async {
  try {
    await EventTrackerFlutter.track(
      eventName: 'button_clicked',
      properties: {'button_name': buttonName},
    );
    _addLog('button_clicked → button_name: $buttonName');
  } catch (e) {
    _addLog('button_clicked failed: $e');
  }
}

void _addLog(String message) {
  if (!mounted) return;
  setState(() => _log.insert(0, message));
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Event Tracker Demo')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Action buttons ─────────────────────────────────────────────
            FilledButton.icon(
              icon: const Icon(Icons.visibility),
              label: const Text('Track Page View'),
              onPressed: () => _trackScreenView('HomeScreen'),
            ),
            const SizedBox(height: 8),
            FilledButton.icon(
              icon: const Icon(Icons.ads_click),
              label: const Text('Track Button Click'),
              onPressed: () => _trackButtonClick('demo_button'),
            ),
            const SizedBox(height: 8),

            const SizedBox(height: 8),

FilledButton.icon(
  icon: const Icon(Icons.pages),
  label: const Text('Test Page Method'),
  onPressed: _testPageMethod,
),

const SizedBox(height: 8),

FilledButton.icon(
  icon: const Icon(Icons.sync),
  label: const Text('Flush Events'),
  onPressed: _testFlush,
),

const SizedBox(height: 8),

OutlinedButton.icon(
  icon: const Icon(Icons.login),
  label: const Text('Go to Login / Test Identify'),
  onPressed: () {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
    );
  },
),
          
            const SizedBox(height: 24),
            const Text(
              'Event Log',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const Divider(),

            // ── Live event log ─────────────────────────────────────────────
            Expanded(
              child: _log.isEmpty
                  ? const Center(
                      child: Text(
                        'No events yet. Tap a button above.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _log.length,
                      itemBuilder: (_, i) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.check_circle,
                                size: 16, color: Colors.green),
                            const SizedBox(width: 8),
                            Expanded(child: Text(_log[i])),
                          ],
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Login Screen (demonstrates identify + multi-screen tracking) ───────────

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final TextEditingController _phoneController =
      TextEditingController();

  String _status = '';

  @override
void dispose() {
  _phoneController.dispose();
  super.dispose();
}

  @override
  void initState() {
    super.initState();

    EventTrackerFlutter.track(
      eventName: 'page_view',
      properties: {'screen_name': 'LoginScreen'},
    );
  }
Future<void> _continueAsGuest() async {
  final sessionId = DateTime.now().millisecondsSinceEpoch.toString();

  try {
    await EventTrackerFlutter.identifyAnonymous(
      sessionId: sessionId,
      traits: {
        'login_type': 'guest',
        'source': 'login_screen',
      },
    );

    setState(() {
      _status = 'Guest session started';
    });

    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        ),
      );
    }
  } catch (e) {
    setState(() {
      _status = 'Guest login failed: $e';
    });
  }
}
 Future<void> _identifyUser() async {

  final phone = _phoneController.text.trim();

  if (phone.isEmpty) {
    setState(() {
      _status = 'Please enter phone number';
    });
    return;
  }

  try {

    await EventTrackerFlutter.identify(
      contactNumber: phone,
    );

    await EventTrackerFlutter.track(
      eventName: 'user_identified',
      properties: {
        'contact_no': phone,
      },
    );

    setState(() {
      _status = 'User identified successfully';
    });

    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        ),
      );
    }

  } catch (e) {

    setState(() {
      _status = 'Identify failed: $e';
    });

  }
}

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text('Login'),
      ),

      body: Padding(

        padding: const EdgeInsets.all(16),

        child: Column(

          crossAxisAlignment: CrossAxisAlignment.stretch,

          children: [

            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
                hintText: 'Enter phone number',
              ),
            ),

            const SizedBox(height: 16),

            FilledButton(
              onPressed: _identifyUser,
              child: const Text('Login & Identify User'),
            ),

            const SizedBox(height: 16),

            const SizedBox(height: 12),

OutlinedButton(
  onPressed: _continueAsGuest,
  child: const Text('Continue as Guest'),
),

            Text(
              _status,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),

            const Spacer(),

           
          ],
        ),
      ),
    );
  }
}

