declare type DndEvent<ItemType = Item> = import("svelte-dnd-action").DndEvent<ItemType>;
declare namespace svelte.JSX {
  interface HTMLAttributes<T> {
    onconsider?: (event: CustomEvent<DndEvent<ItemType>> & { target: EventTarget & T }) => void;
    onfinalize?: (event: CustomEvent<DndEvent<ItemType>> & { target: EventTarget & T }) => void;
  }
}
declare type DndItemEvent = CustomEvent<DndEvent<Item>>;
declare type DndBoxEvent = CustomEvent<DndEvent<Box>>;
declare type Item = {
  category_id: number | null;
  company_id: number | null;
  created_at: string;
  deleted_at: string | null;
  display_order: number;
  id: number;
  name: string;
  notification_threshold: number;
  steps: number[];
  unit: string;
};
declare type Items = Item[];
declare type Box = { id: number; name: string; items: Items };
declare type Boxes = Box[];
