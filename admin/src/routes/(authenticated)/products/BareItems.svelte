<script lang="ts">
  import { flip } from "svelte/animate";
  import { dragHandle, type DndEvent, dndzone } from "svelte-dnd-action";
  import { Button, TableBodyCell, TableHead, TableHeadCell } from "flowbite-svelte";
  import { BarsOutline } from "flowbite-svelte-icons";
  import { parseISODatestring } from "$lib/dates/parseISODatestring";

  export let itemsContainer: { items: Items };
  export let setUnsavedChanges: () => {};

  function handleDndConsider(event: DndItemEvent) {
    setUnsavedChanges();
    itemsContainer.items = event.detail.items;
  }
  function handleDndFinalize(event: DndItemEvent) {
    setUnsavedChanges();
    itemsContainer.items = event.detail.items;
  }

  const flipDurationMs = 300;
</script>

<div>
  <TableHeadCell></TableHeadCell>
  <TableHeadCell>Nazwa</TableHeadCell>
  <TableHeadCell>Jednostka</TableHeadCell>
  <TableHeadCell>Data utworzenia</TableHeadCell>
  <TableHeadCell>Step</TableHeadCell>
  <TableHeadCell />
  <tbody
    use:dndzone={{ items: itemsContainer.items, flipDurationMs }}
    on:consider={handleDndConsider}
    on:finalize={handleDndFinalize}
  >
    {#each itemsContainer.items as item (item.id)}
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
          <Button class="hover:underline" href={`/items/${item.id}`}>Edytuj</Button>
          <Button class="hover:underline" href={`/items/${item.id}/price`}>Wykres ceny</Button>
        </TableBodyCell>
      </tr>
    {:else}
      <div>...</div>
    {/each}
  </tbody>
</div>
