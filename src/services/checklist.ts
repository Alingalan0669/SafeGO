import template from '../data/default-checklists.json';
import type { ChecklistItem, HouseholdProfile } from '../types/models';

export interface ChecklistBundle {
  prepare: ChecklistItem[];
  pack: ChecklistItem[];
  prepareDone: number;
  packDone: number;
  readiness: number;
}

function withDone(items: ChecklistItem[], completedIds: string[]): ChecklistItem[] {
  return items.map((item) => ({ ...item, isDone: completedIds.includes(item.id) }));
}

/** Mirrors Flutter's ChecklistFactory: extras are driven by household answers. */
export function buildChecklists(
  profile: HouseholdProfile | null,
  completedIds: string[],
): ChecklistBundle {
  const pack: ChecklistItem[] = [...template.packBase];

  if (profile?.hasChildren) pack.push(...template.packExtras.children);
  if (profile?.hasSeniors) pack.push(...template.packExtras.seniors);
  if (profile?.hasDisability) pack.push(...template.packExtras.disability);
  if (profile?.hasPets) pack.push(...template.packExtras.pets);
  pack.push(...template.packExtras.contacts);

  const prepare = withDone(template.prepare, completedIds);
  const personalized = withDone(pack, completedIds);

  const prepareDone = prepare.filter((item) => item.isDone).length;
  const packDone = personalized.filter((item) => item.isDone).length;
  const total = prepare.length + personalized.length;

  return {
    prepare,
    pack: personalized,
    prepareDone,
    packDone,
    readiness: total === 0 ? 0 : Math.round(((prepareDone + packDone) / total) * 100),
  };
}

/** Replace {people} / {liters} placeholders used by the water item. */
export function formatDetail(detail: string, profile: HouseholdProfile | null): string {
  const people = profile?.memberCount ?? 1;
  return detail.replace('{people}', String(people)).replace('{liters}', String(people * 3));
}
