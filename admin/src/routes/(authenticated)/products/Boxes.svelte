<script lang="ts">
  import { flip } from "svelte/animate";
  import { dragHandleZone, dragHandle, dndzone } from "svelte-dnd-action";
  import { Button, TableBodyCell, TableHead, TableHeadCell } from "flowbite-svelte";
  import { BarsOutline } from "flowbite-svelte-icons";
  import { parseISODatestring } from "$lib/dates/parseISODatestring";
  import BareItems from "./BareItems.svelte";
  export let boxesContainer: { boxes: Boxes };
  export let itemsContainer: { items: Items };
  export let setUnsavedChanges: () => {};

  const flipDurationMs = 200;
  function handleDndConsiderboxes(e: DndBoxEvent) {
    setUnsavedChanges();
    boxesContainer.boxes = e.detail.items;
  }
  function handleDndFinalizeboxes(e: DndBoxEvent) {
    setUnsavedChanges();
    boxesContainer.boxes = e.detail.items;
  }
  function handleDndConsiderCards(cid: number, e: DndItemEvent) {
    setUnsavedChanges();
    const colIdx = boxesContainer.boxes.findIndex((c) => c.id === cid);
    boxesContainer.boxes[colIdx].items = e.detail.items;
    boxesContainer.boxes = [...boxesContainer.boxes];
  }
  function handleDndFinalizeCards(cid: number, e: DndItemEvent) {
    setUnsavedChanges();
    const colIdx = boxesContainer.boxes.findIndex((c) => c.id === cid);
    boxesContainer.boxes[colIdx].items = e.detail.items;
    boxesContainer.boxes = [...boxesContainer.boxes];
  }
</script>

<BareItems {itemsContainer} {setUnsavedChanges} />
<table
  use:dragHandleZone={{ items: boxesContainer.boxes, flipDurationMs, type: "boxes" }}
  on:consider={handleDndConsiderboxes}
  on:finalize={handleDndFinalizeboxes}
>
  {#each boxesContainer.boxes as box (box.id)}
    <div>
      <thead use:dragHandle aria-label={box.name}>
        <th>
          <BarsOutline class="mr-1 h-3 w-3" />
        </th>
        <TableHeadCell>Nazwa</TableHeadCell>
        <TableHeadCell>Jednostka</TableHeadCell>
        <TableHeadCell>Data utworzenia</TableHeadCell>
        <TableHeadCell>Step</TableHeadCell>
        <TableHeadCell />
      </thead>
      <tbody
        use:dragHandleZone={{ items: box.items, flipDurationMs, centreDraggedOnCursor: true }}
        on:consider={(e) => handleDndConsiderCards(box.id, e)}
        on:finalize={(e) => handleDndFinalizeCards(box.id, e)}
      >
        {#each box.items as item (item.name)}
          <tr animate:flip={{ duration: flipDurationMs }}>
            <td use:dragHandle aria-label={item.name}>
              <BarsOutline class="mr-1 h-2 w-2" />
            </td>
            <TableBodyCell>
              {item.name}
            </TableBodyCell>
            <TableBodyCell>
              {item.unit}
            </TableBodyCell>
            <TableBodyCell>
              {parseISODatestring(item.created_at)}
            </TableBodyCell>
            <TableBodyCell>
              {item.steps.map((step) => " " + step)}
            </TableBodyCell>
            <TableBodyCell>
              <Button class="hover:underline" href={`/products/${item.id}`}>Edytuj</Button>
              <Button class="hover:underline" href={`/products/${item.id}/price`}
                >Wykres ceny</Button
              >
            </TableBodyCell>
          </tr>
        {:else}
          <div>...</div>
        {/each}
      </tbody>
    </div>
  {/each}
</table>
