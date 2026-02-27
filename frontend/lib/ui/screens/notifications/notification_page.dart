import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'cubit/notification_cubit.dart';
import 'cubit/notification_state.dart';
import '../../../../data/constant/enums.dart';
import '../../di/di_config.dart';

@RoutePage()
class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<NotificationCubit>()..loadNotifications(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Notifications'), elevation: 0),
        body: BlocBuilder<NotificationCubit, NotificationState>(
          builder: (context, state) {
            if (state.status == BaseStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.notifications.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.notifications_none,
                      size: 64,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No notifications yet',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () =>
                  context.read<NotificationCubit>().loadNotifications(),
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: state.notifications.length,
                itemBuilder: (context, index) {
                  final notification = state.notifications[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    elevation: notification.isRead ? 0 : 2,
                    color: notification.isRead
                        ? Colors.grey.shade50
                        : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: notification.isRead
                            ? Colors.grey.shade200
                            : Colors.blue.withOpacity(0.1),
                      ),
                    ),
                    child: ListTile(
                      onTap: () {
                        if (!notification.isRead) {
                          context.read<NotificationCubit>().markAsRead(
                            notification.id,
                          );
                        }
                      },
                      leading: CircleAvatar(
                        backgroundColor: _getIconColor(
                          notification.type,
                        ).withOpacity(0.1),
                        child: Icon(
                          _getIcon(notification.type),
                          color: _getIconColor(notification.type),
                          size: 20,
                        ),
                      ),
                      title: Text(
                        notification.title,
                        style: TextStyle(
                          fontWeight: notification.isRead
                              ? FontWeight.normal
                              : FontWeight.bold,
                          color: notification.isRead
                              ? Colors.grey.shade700
                              : Colors.black,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text(
                            notification.message,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            DateFormat(
                              'MMM d, HH:mm',
                            ).format(notification.createdAt),
                            style: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                      trailing: !notification.isRead
                          ? Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                              ),
                            )
                          : null,
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  IconData _getIcon(String type) {
    switch (type) {
      case 'REQUEST_CREATED':
        return Icons.add_circle_outline;
      case 'REQUEST_APPROVED':
        return Icons.check_circle_outline;
      case 'REQUEST_REJECTED':
        return Icons.cancel_outlined;
      default:
        return Icons.notifications_outlined;
    }
  }

  Color _getIconColor(String type) {
    switch (type) {
      case 'REQUEST_CREATED':
        return Colors.blue;
      case 'REQUEST_APPROVED':
        return Colors.green;
      case 'REQUEST_REJECTED':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
