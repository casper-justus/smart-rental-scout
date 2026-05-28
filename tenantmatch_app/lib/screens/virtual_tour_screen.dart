import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:panorama_viewer/panorama_viewer.dart' as pv;
import '../theme/app_theme.dart';
import '../widgets/toast.dart';

class _RoomData {
  final String name;
  final IconData icon;
  final String desc;
  final String imageUrl;
  final List<String> features;
  const _RoomData({
    required this.name,
    required this.icon,
    required this.desc,
    required this.imageUrl,
    this.features = const [],
  });
}

const _rooms = [
  _RoomData(
    name: 'Living Room',
    icon: Icons.living,
    desc: 'Open concept with city views',
    imageUrl: 'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?auto=format&fit=crop&q=80&w=2070&h=1035',
    features: ['Hardwood floors', 'Floor-to-ceiling windows', 'Smart lighting'],
  ),
  _RoomData(
    name: 'Kitchen',
    icon: Icons.kitchen,
    desc: 'Stainless steel appliances',
    imageUrl: 'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?auto=format&fit=crop&q=80&w=2070&h=1035',
    features: ['Quartz countertops', 'Stainless steel', 'Gas range'],
  ),
  _RoomData(
    name: 'Master Bedroom',
    icon: Icons.bed,
    desc: 'Walk-in closet, en-suite',
    imageUrl: 'https://images.unsplash.com/photo-1616594039964-ae9021a400a0?auto=format&fit=crop&q=80&w=2070&h=1035',
    features: ['King-size layout', 'En-suite', 'Blackout shades'],
  ),
];

class VirtualTourScreen extends StatefulWidget {
  final String propertyId;
  const VirtualTourScreen({super.key, this.propertyId = ''});

  @override
  State<VirtualTourScreen> createState() => _VirtualTourScreenState();
}

class _VirtualTourScreenState extends State<VirtualTourScreen> {
  int _currentRoom = 0;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final room = _rooms[_currentRoom];
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          pv.PanoramaViewer(
            child: Image.network(room.imageUrl, fit: BoxFit.cover),
            interactive: true,
            sensorControl: pv.SensorControl.orientation,
          ),
          // Gradient top bar
          Positioned(
            top: 0, left: 0, right: 0,
            child: Container(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 8, bottom: 16),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black87, Colors.transparent],
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(room.name, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                        Text(room.desc, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.screen_rotation, color: Colors.white70),
                    onPressed: () => showToast(context, 'Drag to look around in portrait or landscape'),
                  ),
                ],
              ),
            ),
          ),
          // Compass indicator
          Positioned(
            top: MediaQuery.of(context).padding.top + 60,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white38, width: 1.5),
              ),
              child: const Icon(Icons.navigation, color: Colors.cyanAccent, size: 24),
            ),
          ),
          // Room features overlay
          Positioned(
            left: 20,
            bottom: 140,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: room.features.map((f) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.check_circle, size: 14, color: Colors.greenAccent),
                      const SizedBox(width: 6),
                      Text(f, style: const TextStyle(color: Colors.white, fontSize: 12)),
                    ],
                  ),
                )).toList(),
              ),
            ),
          ),
          // Navigation hotspots
          ...List.generate(2, (i) {
            final align = i == 0 ? Alignment.centerLeft : Alignment.centerRight;
            final label = i == 0 ? 'Hallway' : 'Balcony';
            return Positioned(
              left: i == 0 ? 20 : null,
              right: i == 1 ? 20 : null,
              top: MediaQuery.of(context).size.height * 0.4,
              child: GestureDetector(
                onTap: () => showToast(context, 'Moving to $label...'),
                child: Column(
                  children: [
                    Icon(
                      i == 0 ? Icons.arrow_back : Icons.arrow_forward,
                      color: Colors.white,
                      size: 36,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 11)),
                    ),
                  ],
                ),
              ),
            );
          }),
          // Bottom room selector
          Positioned(
            bottom: 30,
            left: 0, right: 0,
            child: SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _rooms.length,
                itemBuilder: (context, index) {
                  final r = _rooms[index];
                  final active = index == _currentRoom;
                  return GestureDetector(
                    onTap: () => setState(() => _currentRoom = index),
                    child: Container(
                      width: 80,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: active ? Colors.cyanAccent : Colors.transparent,
                          width: 2,
                        ),
                        image: DecorationImage(
                          image: NetworkImage(r.imageUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.black26,
                        ),
                        alignment: Alignment.bottomCenter,
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          r.name.split(' ').first,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
