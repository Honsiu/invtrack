import { useQuery } from "@tanstack/react-query";

import { supabase } from "../supabase";
import { InventoryTable } from "../types";
import { useSession } from "./sessionContext";

const getInventoryName = async (inventoryId: number | undefined | null) => {
  const res = await supabase
    .from<"inventory", InventoryTable>("inventory")
    .select("name")
    .eq("id", inventoryId);
  return {
    ...res,
    data: res.data?.[0].name,
  };
};

export const useGetInventoryName = (inventoryId: number | undefined | null) => {
  const { session } = useSession();

  const query = useQuery(
    ["inventoryName", inventoryId],
    () => session && getInventoryName(inventoryId)
  );
  return { ...query, data: query.data?.data };
};