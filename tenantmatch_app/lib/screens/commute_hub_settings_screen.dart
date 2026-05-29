import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/property.dart';
import '../main.dart';
import '../services/commute_service.dart';
import '../widgets/app_top_bar.dart';
import '../widgets/toast.dart';

class CommuteHubSettingsScreen extends StatefulWidget {
  const CommuteHubSettingsScreen({super.key});

  @override
  State<CommuteHubSettingsScreen> createState() =>
      _CommuteHubSettingsScreenState();
}

class _CommuteHubSettingsScreenState extends State<CommuteHubSettingsScreen>
    with SingleTickerProviderStateMixin {
  final _nameCtrl = TextEditingController();
  final _addrCtrl = TextEditingController();
  final _destNameCtrl = TextEditingController();
  int? _editingIndex;

  @override
  void initState() {
    super.initState();
    commuteService.destinationsNotifier.addListener(_onChanged);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _addrCtrl.dispose();
    _destNameCtrl.dispose();
    commuteService.destinationsNotifier.removeListener(_onChanged);
    super.dispose();
  }

  void _onChanged() => setState(() {});

  void _addDestination() {
    final name = _nameCtrl.text.trim();
    final addr = _addrCtrl.text.trim();
    if (name.isEmpty || addr.isEmpty) {
      showToast(context, 'Please enter both a name and address');
      return;
    }
    if (_editingIndex != null) {
      // Update existing — just remove and re-add simplified
      commuteService.removeDestination(_editingIndex!).then((_) {
        commuteService.addDestination(name, addr);
      });
      _editingIndex = null;
    } else {
      commuteService.addDestination(name, addr);
    }
    _nameCtrl.clear();
    _addrCtrl.clear();
    showToast(context, 'Destination added');
  }

  void _startEdit(int index) {
    final d = commuteService.destinations[index];
    _nameCtrl.text = d.name;
    _addrCtrl.text = d.address;
    setState(() => _editingIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final destinations = commuteService.destinations;
    final sampleProperty = PropertyListing.sampleProperties[0];

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Column(
          children: [
            AppTopBar(title: 'Commute Hub'),
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(AppTheme.containerMargin),
                children: [
                  // Map illustration
                  Semantics(
                    label: 'Commute hub map',
                    child: Container(
                      height: 150,
                      decoration: BoxDecoration(
                        color: cs.secondaryContainer.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: cs.secondaryContainer.withOpacity(0.5)),
                      ),
                      child: Center(
                        child: destinations.isEmpty
                            ? Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.map,
                                      size: 40,
                                      color: cs.secondary.withOpacity(0.5)),
                                  const SizedBox(height: 8),
                                  Text('Add destinations below',
                                      style: TextStyle(
                                          color: cs.secondary
                                              .withOpacity(0.7))),
                                ],
                              )
                            : Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.map,
                                      size: 36,
                                      color: cs.secondary.withOpacity(0.7)),
                                  const SizedBox(height: 8),
                                  Text(
                                    '${destinations.length} destination${destinations.length > 1 ? 's' : ''} set',
                                    style: AppTextStyle.headlineSm
                                        .copyWith(color: cs.primary),
                                  ),
                                  Text(
                                    'Commute estimates calculated per property',
                                    style: AppTextStyle.bodyMd.copyWith(
                                        color: cs.onSurfaceVariant, fontSize: 13),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
                  SizedBox(height: AppTheme.spacingLg),

                  // Saved Destinations
                  Text('Saved Destinations',
                      style: AppTextStyle.headlineMd
                          .copyWith(color: cs.primary)),
                  SizedBox(height: AppTheme.spacingSm),
                  if (destinations.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Text('No destinations yet. Add your first one below.',
                          style: AppTextStyle.bodyMd
                              .copyWith(color: cs.onSurfaceVariant)),
                    )
                  else
                    ...destinations.asMap().entries.map((e) =>
                        _destCard(e.key, e.value, context)),
                  SizedBox(height: AppTheme.spacingLg),

                  // Sample commute calculation preview
                  if (destinations.isNotEmpty) ...[
                    Text('Sample Commute Estimates',
                        style: AppTextStyle.headlineMd
                            .copyWith(color: cs.primary)),
                    SizedBox(height: AppTheme.spacingSm),
                    Container(
                      padding: EdgeInsets.all(AppTheme.spacingMd),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceContainerLowOf(context),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: cs.outlineVariant),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(sampleProperty.address,
                              style: AppTextStyle.bodyMd.copyWith(
                                  fontWeight: FontWeight.w600)),
                          SizedBox(height: AppTheme.spacingSm),
                          ...commuteService
                              .calculateCommuteTimes(sampleProperty)
                              .map((ct) => Padding(
                                    padding: const EdgeInsets.only(bottom: 4),
                                    child: Row(children: [
                                      Icon(Icons.directions_transit,
                                          size: 16, color: cs.secondary),
                                      SizedBox(width: 8),
                                      Text('${ct.key}: ',
                                          style: AppTextStyle.bodyMd),
                                      Text('${ct.value} min',
                                          style: AppTextStyle.bodyMd.copyWith(
                                              fontWeight: FontWeight.w600,
                                              color: cs.primary)),
                                    ]),
                                  )),
                        ],
                      ),
                    ),
                    SizedBox(height: AppTheme.spacingLg),
                  ],

                  // Add / Edit Destination
                  Text(
                      _editingIndex != null
                          ? 'Edit Destination'
                          : 'Add New Destination',
                      style: AppTextStyle.headlineMd
                          .copyWith(color: cs.primary)),
                  SizedBox(height: AppTheme.spacingSm),
                  Container(
                    padding: EdgeInsets.all(AppTheme.spacingMd),
                    decoration: BoxDecoration(
                      color: cs.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: cs.outlineVariant),
                    ),
                    child: Column(
                      children: [
                        Semantics(
                          label: 'Destination name',
                          child: Container(
                            decoration: BoxDecoration(
                              color: cs.surface,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: cs.outlineVariant),
                            ),
                            padding:
                                EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            child: Row(children: [
                              Icon(Icons.label_outline,
                                  color: cs.onSurfaceVariant, size: 20),
                              SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  controller: _nameCtrl,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    isDense: true,
                                    contentPadding: EdgeInsets.zero,
                                    hintText: 'e.g. Work, Gym, School',
                                    hintStyle: AppTextStyle.bodyMd.copyWith(
                                        color: cs.onSurfaceVariant),
                                  ),
                                ),
                              ),
                            ]),
                          ),
                        ),
                        SizedBox(height: AppTheme.spacingSm),
                        Semantics(
                          label: 'Destination address',
                          child: Container(
                            decoration: BoxDecoration(
                              color: cs.surface,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: cs.outlineVariant),
                            ),
                            padding:
                                EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            child: Row(children: [
                              Icon(Icons.location_on_outlined,
                                  color: cs.onSurfaceVariant, size: 20),
                              SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  controller: _addrCtrl,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    isDense: true,
                                    contentPadding: EdgeInsets.zero,
                                    hintText: 'Enter address or place',
                                    hintStyle: AppTextStyle.bodyMd.copyWith(
                                        color: cs.onSurfaceVariant),
                                  ),
                                ),
                              ),
                            ]),
                          ),
                        ),
                        SizedBox(height: AppTheme.spacingMd),
                        GestureDetector(
                          onTap: _addDestination,
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              color: cs.primary,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              _editingIndex != null ? 'Update' : 'Add Destination',
                              textAlign: TextAlign.center,
                              style: AppTextStyle.headlineSm
                                  .copyWith(color: cs.onPrimary),
                            ),
                          ),
                        ),
                        if (_editingIndex != null) ...[
                          SizedBox(height: 8),
                          GestureDetector(
                            onTap: () {
                              _nameCtrl.clear();
                              _addrCtrl.clear();
                              setState(() => _editingIndex = null);
                            },
                            child: Text('Cancel',
                                style: AppTextStyle.bodyMd
                                    .copyWith(color: cs.error)),
                          ),
                        ],
                      ],
                    ),
                  ),
                  SizedBox(height: AppTheme.spacingLg),

                  // Check Commute Times button
                  Semantics(
                    label: 'View commute times for all properties',
                    button: true,
                    child: GestureDetector(
                      onTap: destinations.isEmpty
                          ? () => showToast(context, 'Add a destination first')
                          : () => _showCommuteOverview(context),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: cs.primary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Check Commute Times',
                          textAlign: TextAlign.center,
                          style: AppTextStyle.headlineSm
                              .copyWith(color: cs.onPrimary),
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
    );
  }

  void _showCommuteOverview(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final props = PropertyListing.sampleProperties;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        contentPadding: EdgeInsets.fromLTRB(24, 28, 24, 20),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Commute Overview',
                  style: AppTextStyle.headlineMd.copyWith(color: cs.primary)),
              SizedBox(height: AppTheme.spacingMd),
              ...props.take(3).map((p) {
                final times =
                    commuteService.calculateCommuteTimes(p);
                return Container(
                  margin: EdgeInsets.only(bottom: 8),
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceContainerLowOf(context),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(p.address,
                          style: AppTextStyle.bodyMd.copyWith(
                              fontWeight: FontWeight.w600),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                      SizedBox(height: 4),
                      ...times.map((t) => Text(
                            '${t.key}: ${t.value} min',
                            style: AppTextStyle.bodyMd.copyWith(
                                color: cs.onSurfaceVariant),
                          )),
                    ],
                  ),
                );
              }),
              SizedBox(height: AppTheme.spacingMd),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: Text('Close'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _destCard(int i, CommuteDestination dest, BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Semantics(
      label: '${dest.name}, ${dest.address}',
      child: Container(
        margin: EdgeInsets.only(bottom: 8),
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: cs.outlineVariant),
        ),
        child: Row(
          children: [
            Semantics(
              label: 'Destination icon',
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.surfaceContainerLowOf(context),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.place, size: 22, color: cs.primary),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(dest.name,
                      style: AppTextStyle.bodyMd
                          .copyWith(fontWeight: FontWeight.w600)),
                  Text(dest.address,
                      style: AppTextStyle.bodyMd.copyWith(
                          color: cs.onSurfaceVariant, fontSize: 13),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            Semantics(
              label: 'Edit ${dest.name}',
              button: true,
              child: GestureDetector(
                onTap: () => _startEdit(i),
                child: Container(
                  padding: EdgeInsets.all(8),
                  child:
                      Icon(Icons.edit, size: 20, color: cs.onSurfaceVariant),
                ),
              ),
            ),
            Semantics(
              label: 'Delete ${dest.name}',
              button: true,
              child: GestureDetector(
                onTap: () {
                  commuteService.removeDestination(i);
                  showToast(context, '${dest.name} removed');
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  child: Icon(Icons.delete_outline,
                      size: 20, color: cs.error),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
