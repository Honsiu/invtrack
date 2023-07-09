import { Stack } from "expo-router";
import React from "react";

const StartLayout = () => {
  return (
    <Stack>
      <Stack.Screen name="start" />
      <Stack.Screen name="login" />
      <Stack.Screen name="register" />
    </Stack>
  );
};

export default StartLayout;