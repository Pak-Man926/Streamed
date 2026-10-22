class SportCategory {
  final String id;
  final String label;
  final String mark;

  const SportCategory({
    required this.id,
    required this.label,
    required this.mark,
  });

  static const List<SportCategory> defaults = [
    SportCategory(id: 'all', label: 'All', mark: '✦'),
    SportCategory(id: 'football', label: 'Football', mark: '◉'),
    SportCategory(id: 'basketball', label: 'Basketball', mark: '●'),
    SportCategory(id: 'tennis', label: 'Tennis', mark: '⌁'),
    SportCategory(id: 'racing', label: 'Racing', mark: '≋'),
  ];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SportCategory &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
