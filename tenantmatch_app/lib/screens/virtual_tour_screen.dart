import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/toast.dart';
import '../widgets/app_top_bar.dart';

class _RoomData {
  final String name;
  final IconData icon;
  final String desc;
  final Color color1;
  final Color color2;
  final List<String> features;

  const _RoomData({
    required this.name,
    required this.icon,
    required this.desc,
    required this.color1,
    required this.color2,
    this.features = const [],
  });
}

const _rooms = [
  _RoomData(
    name: 'Living Room',
    icon: Icons.living,
    desc: 'Open concept with city views',
    color1: Color(0xFF2D5F8A),
    color2: Color(0xFF1A365D),
    features: ['Hardwood floors', 'Floor-to-ceiling windows', 'Smart lighting', 'Built-in sound system'],
  ),
  _RoomData(
    name: 'Kitchen',
    icon: Icons.kitchen,
    desc: 'Stainless steel appliances',
    color1: Color(0xFF8A6E2D),
    color2: Color(0xFF5D4A1A),
    features: ['Quartz countertops', 'Stainless steel appliances', 'Gas range', 'Breakfast bar'],
  ),
  _RoomData(
    name: 'Master Bedroom',
    icon: Icons.bed,
    desc: 'Walk-in closet, en-suite',
    color1: Color(0xFF6B2D8A),
    color2: Color(0xFF3D1A5D),
    features: ['King-size layout', 'Walk-in closet', 'En-suite bathroom', 'Blackout shades'],
  ),
  _RoomData(
    name: 'Bedroom 2',
    icon: Icons.bedroom_parent,
    desc: 'Great for home office',
    color1: Color(0xFF2D8A5F),
    color2: Color(0xFF1A5D3D),
    features: ['Built-in desk', 'Closet', 'North-facing windows', 'Ceiling fan'],
  ),
  _RoomData(
    name: 'Bathroom',
    icon: Icons.bathtub,
    desc: 'Modern fixtures',
    color1: Color(0xFF2D6B8A),
    color2: Color(0xFF1A4A5D),
    features: ['Rain shower', 'Soaking tub', 'Heated floors', 'LED mirror'],
  ),
  _RoomData(
    name: 'Balcony',
    icon: Icons.deck,
    desc: 'City skyline view',
    color1: Color(0xFF8A5F2D),
    color2: Color(0xFF5D3D1A),
    features: ['City skyline view', 'Seating area', 'Planters', 'String lights'],
  ),
];

class VirtualTourScreen extends StatefulWidget {
  const VirtualTourScreen({super.key});

  @override
  State<VirtualTourScreen> createState() => _VirtualTourScreenState();
}

class _VirtualTourScreenState extends State<VirtualTourScreen> {
  int _currentRoom = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final room = _rooms[_currentRoom];

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Column(
          children: [
            AppTopBar(title: 'Virtual Tour'),
            Expanded(
              child: Column(
                children: [
                  // 360° Panorama room view
                  Semantics(
                    label: '360 degree view of ${room.name}',
                    child: Container(
                      height: 280,
                      width: double.infinity,
                      margin: EdgeInsets.all(AppTheme.containerMargin),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          colors: [room.color1, room.color2],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: room.color1.withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 400),
                            child: Center(
                              key: ValueKey(_currentRoom),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    room.icon,
                                    size: 64,
                                    color: Colors.white.withOpacity(0.6),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    '360° ${room.name}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Drag to explore',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.7),
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Room navigation hotspots
                          ...List.generate(_rooms.length, (i) {
                            if (i == _currentRoom) return const SizedBox();
                            // Position hotspots at different corners based on index
                            final positions = [
                              const Alignment(0.7, -0.7),
                              const Alignment(-0.7, -0.5),
                              const Alignment(0.6, 0.6),
                              const Alignment(-0.6, 0.7),
                              const Alignment(0.0, -0.8),
                              const Alignment(-0.8, 0.0),
                            ];
                            return Align(
                              alignment: i < positions.length ? positions[i] : Alignment.center,
                              child: Semantics(
                                label: 'Navigate to ${_rooms[i].name}',
                                button: true,
                                child: GestureDetector(
                                  onTap: () => _navigateToRoom(i),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                      color: cs.surface.withOpacity(0.9),
                                      borderRadius: BorderRadius.circular(999),
                                      border: Border.all(color: Colors.white38),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(_rooms[i].icon, size: 14, color: cs.primary),
                                        const SizedBox(width: 4),
                                        Text(
                                          _rooms[i].name,
                                          style: AppTextStyle.bodyMd.copyWith(
                                            color: cs.primary,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                  // Room title and description
                  Semantics(
                    header: true,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: AppTheme.containerMargin),
                      child: Row(
                        children: [
                          Icon(room.icon, color: cs.primary, size: 24),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  room.name,
                                  style: AppTextStyle.headlineLgMobile.copyWith(color: cs.primary),
                                ),
                                Text(
                                  room.desc,
                                  style: AppTextStyle.bodyMd.copyWith(color: cs.onSurfaceVariant),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingMd),
                  // Room features
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppTheme.containerMargin),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: room.features.map((f) => Semantics(
                        label: 'Feature: $f',
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppTheme.surfaceContainerLowOf(context),
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(color: cs.outlineVariant),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.check_circle_outline, size: 14, color: cs.secondary),
                              const SizedBox(width: 6),
                              Text(f, style: AppTextStyle.bodyMd.copyWith(fontSize: 13)),
                            ],
                          ),
                        ),
                      )).toList(),
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingMd),
                  // Room carousel strip
                  Semantics(
                    label: 'Room carousel',
                    child: SizedBox(
                      height: 80,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(horizontal: AppTheme.containerMargin),
                        itemCount: _rooms.length,
                        itemBuilder: (_, i) {
                          final r = _rooms[i];
                          final isSelected = i == _currentRoom;
                          return Semantics(
                            label: '${r.name}${isSelected ? ", selected" : ""}',
                            button: true,
                            child: GestureDetector(
                              onTap: () => _navigateToRoom(i),
                              child: Container(
                                width: 70,
                                margin: const EdgeInsets.only(right: 8),
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(
                                  color: isSelected ? cs.secondaryContainer : cs.surface,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isSelected ? cs.secondary : cs.outlineVariant,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Icon(
                                      r.icon,
                                      size: 22,
                                      color: isSelected
                                          ? cs.onSecondaryContainer
                                          : cs.onSurfaceVariant,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      r.name.split(' ').first,
                                      style: AppTextStyle.labelCaps.copyWith(
                                        fontSize: 10,
                                        color: isSelected
                                            ? cs.onSecondaryContainer
                                            : cs.onSurfaceVariant,
                                      ),
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  // Navigation buttons
                  Padding(
                    padding: EdgeInsets.all(AppTheme.containerMargin),
                    child: Row(
                      children: [
                        Expanded(
                          child: Semantics(
                            label: 'Previous room',
                            button: true,
                            child: GestureDetector(
                              onTap: _currentRoom > 0 ? () => _navigateToRoom(_currentRoom - 1) : null,
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  border: Border.all(color: cs.outlineVariant),
                                  borderRadius: BorderRadius.circular(12),
                                  color: _currentRoom > 0 ? cs.surface : cs.surface.withOpacity(0.5),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.arrow_back, size: 18, color: _currentRoom > 0 ? cs.primary : cs.onSurfaceVariant),
                                    const SizedBox(width: 4),
                                    Text('Previous', style: AppTextStyle.bodyMd.copyWith(
                                      color: _currentRoom > 0 ? cs.primary : cs.onSurfaceVariant,
                                    )),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Semantics(
                            label: 'Next room',
                            button: true,
                            child: GestureDetector(
                              onTap: _currentRoom < _rooms.length - 1 ? () => _navigateToRoom(_currentRoom + 1) : null,
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: cs.primary,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Next', style: AppTextStyle.bodyMd.copyWith(color: cs.onPrimary)),
                                    const SizedBox(width: 4),
                                    Icon(Icons.arrow_forward, size: 18, color: cs.onPrimary),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToRoom(int index) {
    if (index == _currentRoom) return;
    setState(() {
      _currentRoom = index;
    });
    showToast(context, 'Exploring ${_rooms[index].name}');
  }
}
