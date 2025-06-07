String formatTimeAgo(DateTime dateTime) {
  final duration = DateTime.now().difference(dateTime);

  if (duration.inSeconds < 60) return 'Just now';
  if (duration.inMinutes < 60) return '${duration.inMinutes} min ago';
  if (duration.inHours < 24) return '${duration.inHours} hours ago';
  if (duration.inDays == 1) return 'Yesterday';
  return '${duration.inDays} days ago';
}
