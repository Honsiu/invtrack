<script lang="ts">
  import {
    Accordion,
    AccordionItem,
    Button,
    Table,
    TableHead,
    TableHeadCell,
  } from "flowbite-svelte";
  import ScreenCard from "$lib/ScreenCard.svelte";
  import BareItems from "./BareItems.svelte";
  import Boxes from "./Boxes.svelte";

  export let data;

  let loading = false;
  let unsavedChanges = false;
  let company_id: number | null = null;

  let { categories, uncategorisedProducts } = data;

  let uncategorisedProductsContainer = { items: uncategorisedProducts || [] };
  let boxesContainer = { boxes: categories || [] };
  const flipDurationMs = 200;
  const setUnsavedChanges = () => (unsavedChanges = true);
</script>

<ScreenCard header="Produkty">
  {#if categories}
    <BareItems itemsContainer={uncategorisedProductsContainer} {setUnsavedChanges} />
    <Boxes {boxesContainer} {setUnsavedChanges}></Boxes>
  {/if}
  <div class="mt-2 flex flex-wrap justify-center gap-4 md:justify-start">
    <Button class="hover:underline" href={`/products/add`}>Dodaj produkt</Button>
    <Button class="hover:underline" href={`/products/add-category`}>Dodaj kategorię</Button>
    <Button class="hover:underline" href={`/products/reorder`}>Zmień kolejność</Button>
  </div>
</ScreenCard>
