import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../state/notification_state.dart';
import '../../../state/auth_state.dart';
import '../../../models/notification_model.dart';
import '../../../core/utils/responsive.dart';

/// Notifications screen for logged-in users
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authState = Get.put(AuthState());
    final notificationState = Get.put(NotificationState());

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        toolbarHeight: 0,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Responsive.constrained(
          Obx(
            () => authState.isAuthenticated
                ? _NotificationsContent(notificationState: notificationState)
                : _NotAuthenticatedView(),
          ),
        ),
      ),
    );
  }
}

/// Main content for notifications screen
class _NotificationsContent extends StatelessWidget {
  final NotificationState notificationState;

  const _NotificationsContent({required this.notificationState});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header Section
        _HeaderSection(notificationState: notificationState),

        // Notifications List
        Expanded(
          child: Obx(() {
            final notifications = notificationState.notifications;

            if (notifications.isEmpty) {
              return _EmptyNotificationsView();
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return _NotificationCard(
                  notification: notification,
                  notificationState: notificationState,
                );
              },
            );
          }),
        ),
      ],
    );
  }
}

/// Header section with title, count, and actions
class _HeaderSection extends StatelessWidget {
  final NotificationState notificationState;

  const _HeaderSection({required this.notificationState});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    return Container(
      padding: EdgeInsets.fromLTRB(
        isSmallScreen ? 16 : 20,
        16,
        isSmallScreen ? 16 : 20,
        8,
      ),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        border: Border(bottom: BorderSide(color: theme.dividerColor, width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back button and title
          Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_rounded,
                  color: theme.colorScheme.onSurface,
                  size: 24,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                onPressed: () => context.pop(),
                tooltip: 'Back',
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Notifications',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 24 : 28,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                      fontFamily: AppTheme.fontFamily,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Obx(() {
                    final unreadCount = notificationState.unreadCount;
                    return Text(
                      unreadCount > 0
                          ? '$unreadCount unread ${unreadCount == 1 ? 'notification' : 'notifications'}'
                          : 'All caught up!',
                      style: TextStyle(
                        fontSize: 13,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontFamily: AppTheme.fontFamily,
                      ),
                    );
                  }),
                ],
              ),
            ],
          ),

          // Mark all as read button
          Obx(() {
            final hasUnread = notificationState.unreadCount > 0;
            if (!hasUnread) return const SizedBox.shrink();

            return TextButton(
              onPressed: () => notificationState.markAllAsRead(),
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.redPrimary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
              child: Text(
                'Mark all read',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  fontFamily: AppTheme.fontFamily,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

/// Notification card widget
class _NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  final NotificationState notificationState;

  const _NotificationCard({
    required this.notification,
    required this.notificationState,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: notification.isRead ? theme.colorScheme.surface : theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: notification.isRead
              ? theme.dividerColor
              : AppTheme.redPrimary.withValues(alpha: 0.3),
          width: notification.isRead ? 1 : 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (!notification.isRead) {
              notificationState.markAsRead(notification.id);
            }
            if (notification.actionUrl != null) {
              context.push(notification.actionUrl!);
            }
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: EdgeInsets.all(isSmallScreen ? 14 : 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon container
                Container(
                  width: isSmallScreen ? 44 : 48,
                  height: isSmallScreen ? 44 : 48,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: _getGradientColors(context, notification.type),
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: _getGradientColors(
                          context,
                          notification.type,
                        )[0].withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    _getIcon(notification.type),
                    color: Theme.of(context).colorScheme.onSurface,
                    size: isSmallScreen ? 22 : 24,
                  ),
                ),
                const SizedBox(width: 12),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title and unread indicator
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              notification.title,
                              style: TextStyle(
                                fontSize: isSmallScreen ? 15 : 16,
                                fontWeight: notification.isRead
                                    ? FontWeight.w600
                                    : FontWeight.bold,
                                color: Theme.of(context).colorScheme.onSurface,
                                fontFamily: AppTheme.fontFamily,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (!notification.isRead) ...[
                            const SizedBox(width: 8),
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: AppTheme.redPrimary,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 6),

                      // Message
                      Text(
                        notification.message,
                        style: TextStyle(
                          fontSize: isSmallScreen ? 13 : 14,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontFamily: AppTheme.fontFamily,
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),

                      // Time
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 12,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _formatTime(notification.createdAt),
                            style: TextStyle(
                              fontSize: 11,
                              color: Theme.of(context).colorScheme.outline,
                              fontFamily: AppTheme.fontFamily,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Delete button
                IconButton(
                  icon: Icon(Icons.close, size: 18, color: Theme.of(context).colorScheme.outline),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 32,
                  ),
                  onPressed: () {
                    notificationState.deleteNotification(notification.id);
                  },
                  tooltip: 'Delete',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Color> _getGradientColors(BuildContext context, NotificationType type) {
    switch (type) {
      case NotificationType.auction:
        return [AppTheme.redPrimary, AppTheme.redPressed];
      case NotificationType.booking:
        return [AppTheme.info, AppTheme.info.withValues(alpha: 0.8)];
      case NotificationType.wallet:
        return [AppTheme.warning, AppTheme.warning.withValues(alpha: 0.8)];
      case NotificationType.verification:
        return [AppTheme.success, AppTheme.success.withValues(alpha: 0.8)];
      case NotificationType.parts:
        return [Colors.purple.shade400, Colors.purple.shade600];
      case NotificationType.system:
        final outline = Theme.of(context).colorScheme.outline;
        return [outline, outline.withValues(alpha: 0.8)];
    }
  }

  IconData _getIcon(NotificationType type) {
    switch (type) {
      case NotificationType.auction:
        return Icons.gavel;
      case NotificationType.booking:
        return Icons.calendar_today;
      case NotificationType.wallet:
        return Icons.account_balance_wallet;
      case NotificationType.verification:
        return Icons.verified;
      case NotificationType.parts:
        return Icons.build;
      case NotificationType.system:
        return Icons.info;
    }
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('MMM d, yyyy').format(dateTime);
    }
  }
}

/// Empty state view
class _EmptyNotificationsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.notifications_none,
                size: 64,
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No Notifications',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
                fontFamily: AppTheme.fontFamily,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'You\'re all caught up!\nWe\'ll notify you when something important happens.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontFamily: AppTheme.fontFamily,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Not authenticated view
class _NotAuthenticatedView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.lock_outline, size: 64, color: Theme.of(context).colorScheme.outline),
            const SizedBox(height: 24),
            Text(
              'Login Required',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
                fontFamily: AppTheme.fontFamily,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please login to view your notifications',
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontFamily: AppTheme.fontFamily,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.push(AppConstants.routeLogin),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.redPrimary,
                foregroundColor: AppTheme.textPrimary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Login',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: AppTheme.fontFamily,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
