/// Grouping used for icons and for explaining why an item was generated.
enum ChecklistCategory {
  water,
  food,
  medical,
  documents,
  tools,
  clothing,
  children,
  seniors,
  disability,
  pets,
  contacts,
}

/// A single checklist row. [isDone] is the only mutable-looking part, and we
/// model it immutably so the provider can rebuild lists safely.
class ChecklistItem {
  const ChecklistItem({
    required this.id,
    required this.title,
    required this.detail,
    this.isDone = false,
    this.category = ChecklistCategory.tools,
    this.isPersonalised = false,
  });

  final String id;
  final String title;
  final String detail;
  final bool isDone;
  final ChecklistCategory category;

  /// True when the item was generated because of the household profile
  /// (children, seniors, disability support or pets).
  final bool isPersonalised;

  ChecklistItem copyWith({bool? isDone}) => ChecklistItem(
        id: id,
        title: title,
        detail: detail,
        isDone: isDone ?? this.isDone,
        category: category,
        isPersonalised: isPersonalised,
      );
}
