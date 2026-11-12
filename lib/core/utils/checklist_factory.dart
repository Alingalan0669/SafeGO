import '../../models/checklist_item.dart';
import '../../models/household_profile.dart';
import 'app_utils.dart';

/// Pure checklist builders.
///
/// Keeping generation out of the UI/provider makes it easy to test:
/// [buildPackChecklist] always returns the same list for the same profile.

/// The four preparedness steps from the Prepare frame.
const List<ChecklistItem> prepareChecklistTemplate = [
  ChecklistItem(
    id: 'prep.plan',
    title: 'Family emergency plan',
    detail: 'Agree on what everyone will do.',
    category: ChecklistCategory.contacts,
  ),
  ChecklistItem(
    id: 'prep.contacts',
    title: 'Emergency contacts',
    detail: 'Save family and local contacts.',
    category: ChecklistCategory.contacts,
  ),
  ChecklistItem(
    id: 'prep.documents',
    title: 'Important documents',
    detail: 'Keep copies in a waterproof pouch.',
    category: ChecklistCategory.documents,
  ),
  ChecklistItem(
    id: 'prep.meeting',
    title: 'Family meeting point',
    detail: 'Choose a safe place outside home.',
    category: ChecklistCategory.tools,
  ),
];

/// Builds the personalised go-bag list.
///
/// Base list = 14 items. Children/seniors/disability/pets add items before the
/// contact list, which mirrors the Figma flow (5 people + children = 15 items).
List<ChecklistItem> buildPackChecklist(HouseholdProfile? profile) {
  final memberCount = profile?.memberCount ?? 1;
  final people = peopleLabel(memberCount);

  final items = <ChecklistItem>[
    ChecklistItem(
      id: 'pack.water',
      title: 'Drinking water',
      detail: '3 days for $people • about ${memberCount * 3} L.',
      category: ChecklistCategory.water,
    ),
    const ChecklistItem(
      id: 'pack.food',
      title: 'Ready-to-eat food',
      detail: 'Family portions for 3 days.',
      category: ChecklistCategory.food,
    ),
    const ChecklistItem(
      id: 'pack.medicines',
      title: 'Daily medicines',
      detail: 'Prescriptions and a medicine list.',
      category: ChecklistCategory.medical,
    ),
    const ChecklistItem(
      id: 'pack.firstAid',
      title: 'First-aid kit',
      detail: 'Dressings, antiseptic and supplies.',
      category: ChecklistCategory.medical,
    ),
    const ChecklistItem(
      id: 'pack.flashlight',
      title: 'Flashlight',
      detail: 'Keep it easy to reach.',
      category: ChecklistCategory.tools,
    ),
    const ChecklistItem(
      id: 'pack.powerBank',
      title: 'Power bank & cables',
      detail: 'Charge before a storm.',
      category: ChecklistCategory.tools,
    ),
    const ChecklistItem(
      id: 'pack.documents',
      title: 'Important documents',
      detail: 'Waterproof copies of IDs and records.',
      category: ChecklistCategory.documents,
    ),
    const ChecklistItem(
      id: 'pack.radio',
      title: 'Battery radio',
      detail: 'For local advisories.',
      category: ChecklistCategory.tools,
    ),
    const ChecklistItem(
      id: 'pack.batteries',
      title: 'Spare batteries',
      detail: 'Match your radio and flashlight.',
      category: ChecklistCategory.tools,
    ),
    const ChecklistItem(
      id: 'pack.clothes',
      title: 'Clothes & rainwear',
      detail: 'One set per family member.',
      category: ChecklistCategory.clothing,
    ),
    const ChecklistItem(
      id: 'pack.hygiene',
      title: 'Hygiene supplies',
      detail: 'Soap, sanitary items and masks.',
      category: ChecklistCategory.medical,
    ),
    const ChecklistItem(
      id: 'pack.cash',
      title: 'Cash & spare keys',
      detail: 'Small bills in a waterproof pouch.',
      category: ChecklistCategory.documents,
    ),
    const ChecklistItem(
      id: 'pack.whistle',
      title: 'Whistle',
      detail: 'One for each family member.',
      category: ChecklistCategory.tools,
    ),
    if (profile?.hasChildren == true)
      const ChecklistItem(
        id: 'pack.children',
        title: 'Children’s supplies',
        detail: 'Snacks, comfort item and spare clothes.',
        category: ChecklistCategory.children,
        isPersonalised: true,
      ),
    if (profile?.hasSeniors == true)
      const ChecklistItem(
        id: 'pack.seniors',
        title: 'Senior supplies',
        detail: 'Glasses, hearing-aid batteries and easy food.',
        category: ChecklistCategory.seniors,
        isPersonalised: true,
      ),
    if (profile?.hasDisability == true)
      const ChecklistItem(
        id: 'pack.disability',
        title: 'Disability support supplies',
        detail: 'Mobility aid, extra medicine and support plan.',
        category: ChecklistCategory.disability,
        isPersonalised: true,
      ),
    if (profile?.hasPets == true) ...const [
      ChecklistItem(
        id: 'pack.petFood',
        title: 'Pet food & water',
        detail: 'Three days of food and a travel bowl.',
        category: ChecklistCategory.pets,
        isPersonalised: true,
      ),
      ChecklistItem(
        id: 'pack.petCarrier',
        title: 'Pet carrier & leash',
        detail: 'Keep pets secure and calm during travel.',
        category: ChecklistCategory.pets,
        isPersonalised: true,
      ),
    ],
    const ChecklistItem(
      id: 'pack.contacts',
      title: 'Emergency contact list',
      detail: 'Paper copy for every family member.',
      category: ChecklistCategory.contacts,
    ),
  ];

  return List.unmodifiable(items);
}
