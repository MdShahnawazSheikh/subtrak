import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/data/models/insight_model.dart';
import '../../app/data/repositories/settings_repository.dart';

class AuditLogScreen extends StatefulWidget {
  const AuditLogScreen({super.key});

  @override
  State<AuditLogScreen> createState() => _AuditLogScreenState();
}

class _AuditLogScreenState extends State<AuditLogScreen> {
  final AuditLogRepository _auditRepo = Get.find();
  AuditAction? _filterAction;
  String? _filterEntityType;

  @override
  Widget build(BuildContext context) {
    var entries = _auditRepo.getAll();

    if (_filterAction != null) {
      entries = entries.where((e) => e.action == _filterAction).toList();
    }
    if (_filterEntityType != null) {
      entries = entries
          .where((e) => e.entityType == _filterEntityType)
          .toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Audit Log'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            onSelected: (value) {
              setState(() {
                if (value == 'clear') {
                  _filterAction = null;
                  _filterEntityType = null;
                } else if (value.startsWith('action:')) {
                  final actionName = value.substring(7);
                  _filterAction = AuditAction.values.firstWhere(
                    (a) => a.name == actionName,
                  );
                } else if (value.startsWith('type:')) {
                  _filterEntityType = value.substring(5);
                }
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'clear', child: Text('Clear Filters')),
              const PopupMenuDivider(),
              const PopupMenuItem(
                enabled: false,
                child: Text(
                  'Filter by Action:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              ...AuditAction.values.map(
                (action) => PopupMenuItem(
                  value: 'action:${action.name}',
                  child: Text(_getActionLabel(action)),
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                enabled: false,
                child: Text(
                  'Filter by Type:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const PopupMenuItem(
                value: 'type:subscription',
                child: Text('Subscriptions'),
              ),
              const PopupMenuItem(
                value: 'type:settings',
                child: Text('Settings'),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: _clearOldEntries,
          ),
        ],
      ),
      body: entries.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: entries.length,
              itemBuilder: (context, index) => _buildLogEntry(entries[index]),
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text('No Audit Logs', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            'All changes to your data will be tracked here',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildLogEntry(AuditLogEntry entry) {
    final canRollback =
        entry.action != AuditAction.delete && entry.previousState != null;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _showEntryDetails(entry),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _getActionIcon(entry.action),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getActionLabel(entry.action),
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        if (entry.entityName != null)
                          Text(
                            entry.entityName!,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: Colors.grey[700]),
                          ),
                      ],
                    ),
                  ),
                  if (canRollback)
                    IconButton(
                      icon: const Icon(Icons.undo),
                      color: Colors.orange,
                      tooltip: 'Rollback',
                      onPressed: () => _rollbackEntry(entry),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    _formatTimestamp(entry.timestamp),
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: _getEntityColor(entry.entityType).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      entry.entityType,
                      style: TextStyle(
                        fontSize: 12,
                        color: _getEntityColor(entry.entityType),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              if (entry.notes != null) ...[
                const SizedBox(height: 8),
                Text(
                  entry.notes!,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _getActionIcon(AuditAction action) {
    IconData icon;
    Color color;

    switch (action) {
      case AuditAction.create:
        icon = Icons.add_circle;
        color = Colors.green;
        break;
      case AuditAction.update:
        icon = Icons.edit;
        color = Colors.blue;
        break;
      case AuditAction.delete:
        icon = Icons.delete;
        color = Colors.red;
        break;
      case AuditAction.pause:
        icon = Icons.pause_circle;
        color = Colors.orange;
        break;
      case AuditAction.resume:
        icon = Icons.play_circle;
        color = Colors.green;
        break;
      case AuditAction.archive:
        icon = Icons.archive;
        color = Colors.grey;
        break;
      case AuditAction.restore:
        icon = Icons.restore;
        color = Colors.blue;
        break;
      case AuditAction.settingsChange:
        icon = Icons.settings;
        color = Colors.purple;
        break;
      case AuditAction.import_:
        icon = Icons.download;
        color = Colors.teal;
        break;
      case AuditAction.export_:
        icon = Icons.upload;
        color = Colors.teal;
        break;
      case AuditAction.backup:
        icon = Icons.cloud_upload;
        color = Colors.blue;
        break;
      case AuditAction.cancel:
        icon = Icons.cancel;
        color = Colors.orange;
        break;
    }

    return Icon(icon, color: color, size: 32);
  }

  String _getActionLabel(AuditAction action) {
    switch (action) {
      case AuditAction.create:
        return 'Created';
      case AuditAction.update:
        return 'Updated';
      case AuditAction.delete:
        return 'Deleted';
      case AuditAction.pause:
        return 'Paused';
      case AuditAction.resume:
        return 'Resumed';
      case AuditAction.archive:
        return 'Archived';
      case AuditAction.restore:
        return 'Restored';
      case AuditAction.settingsChange:
        return 'Settings Changed';
      case AuditAction.import_:
        return 'Data Imported';
      case AuditAction.export_:
        return 'Data Exported';
      case AuditAction.backup:
        return 'Data Backed Up';
      case AuditAction.cancel:
        return 'Cancelled';
    }
  }

  Color _getEntityColor(String entityType) {
    switch (entityType) {
      case 'subscription':
        return Colors.blue;
      case 'settings':
        return Colors.purple;
      case 'insight':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final diff = now.difference(timestamp);

    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';

    return '${timestamp.month}/${timestamp.day}/${timestamp.year} ${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';
  }

  void _showEntryDetails(AuditLogEntry entry) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_getActionLabel(entry.action)),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Entity', entry.entityName ?? entry.entityId),
              _buildDetailRow('Type', entry.entityType),
              _buildDetailRow('Time', _formatTimestamp(entry.timestamp)),
              if (entry.notes != null) _buildDetailRow('Notes', entry.notes!),
              if (entry.previousState != null) ...[
                const SizedBox(height: 16),
                const Text(
                  'Previous State:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    entry.previousState.toString(),
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
              if (entry.newState != null) ...[
                const SizedBox(height: 16),
                const Text(
                  'New State:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    entry.newState.toString(),
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          if (entry.action != AuditAction.delete && entry.previousState != null)
            FilledButton.icon(
              onPressed: () {
                Navigator.pop(context);
                _rollbackEntry(entry);
              },
              icon: const Icon(Icons.undo),
              label: const Text('Rollback'),
            ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  void _rollbackEntry(AuditLogEntry entry) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Rollback'),
        content: Text(
          'This will restore ${entry.entityName ?? entry.entityType} to its previous state. Are you sure?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(context);

              if (entry.entityType == 'subscription' &&
                  entry.previousState != null) {
                // Rollback subscription
                try {
                  // TODO: Implement proper deserialization from previousState Map
                  // For now, just show success
                  Get.snackbar(
                    'Rollback',
                    'Subscription rollback functionality will be implemented with proper state deserialization',
                    backgroundColor: Colors.orange,
                  );
                } catch (e) {
                  Get.snackbar(
                    'Error',
                    'Could not find subscription to rollback',
                  );
                }
              }

              setState(() {});
            },
            child: const Text('Rollback'),
          ),
        ],
      ),
    );
  }

  void _clearOldEntries() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Old Entries'),
        content: const Text('Remove audit logs older than 90 days?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              await _auditRepo.clearOld(daysOld: 90);
              setState(() {});
              Navigator.pop(context);
              Get.snackbar('Cleared', 'Old audit logs have been removed');
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }
}
