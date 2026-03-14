String formatEventDate(DateTime dt) {
  const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  final day = days[dt.weekday - 1];
  final month = months[dt.month - 1];
  final hour = dt.hour == 0 ? 12 : (dt.hour > 12 ? dt.hour - 12 : dt.hour);
  final minute = dt.minute.toString().padLeft(2, '0');
  final meridiem = dt.hour >= 12 ? 'PM' : 'AM';

  return '$day, $month ${dt.day}, ${dt.year} · $hour:$minute $meridiem';
}

String formatPickerDate(DateTime dt) {
  return '${dt.month}/${dt.day}/${dt.year}';
}

String countryLabel(String country) {
  switch (country) {
    case 'USA':
      return '🇺🇸 USA';
    case 'Japan':
      return '🇯🇵 Japan';
    case 'UK':
      return '🇬🇧 UK';
    case 'Germany':
      return '🇩🇪 Germany';
    case 'France':
      return '🇫🇷 France';
    default:
      return country;
  }
}

String shortGameLabel(String game) {
  switch (game) {
    case 'Cardfight!! Vanguard':
      return 'Vanguard';
    case 'Weiss Schwarz':
      return 'Weiss';
    case 'Hololive TCG':
      return 'Hololive';
    case 'Shadowverse: Evolve':
      return 'Shadowverse';
    default:
      return game;
  }
}
