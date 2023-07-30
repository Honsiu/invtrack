import DateTimePicker from "@react-native-community/datetimepicker";
import formatISO from "date-fns/formatISO";
import { StyleSheet, View } from "react-native";
import { useSafeAreaInsets } from "react-native-safe-area-context";
import { createStyles } from "../../../theme/useStyles";
import { Button } from "../../Button";
import { Typography } from "../../Typography";

// TODO Android styling
export const DatePickerBottomSheetContent = ({
  dateValue,
  setDateValue,
  closeBottomSheet,
}: {
  dateValue: Date;
  setDateValue: (value: string) => void;
  closeBottomSheet: () => void;
}) => {
  const insets = useSafeAreaInsets();
  const styles = useStyles();

  return (
    <View
      style={{
        paddingBottom: 16 + insets.bottom,
        paddingTop: 16,
        backgroundColor: "#fff",
      }}
    >
      <Typography
        style={{
          alignSelf: "center",
        }}
      >
        Wybierz datę
      </Typography>
      <DateTimePicker
        value={dateValue}
        mode={"date"}
        display="spinner"
        onChange={(e, d) => {
          if (e.type === "dismissed") {
            return;
          }
          setDateValue((d && formatISO(d)) ?? "");
        }}
        style={styles.input}
      />
      <DateTimePicker
        value={dateValue}
        mode={"time"}
        display="spinner"
        is24Hour={true}
        onChange={(e, d) => {
          if (e.type === "dismissed") {
            return;
          }
          setDateValue((d && formatISO(d)) ?? "");
        }}
        style={styles.input}
      />
      <Button
        type="primary"
        size="m"
        containerStyle={styles.button}
        onPress={closeBottomSheet}
      >
        <Typography color="darkBlue">Zapisz</Typography>
      </Button>
    </View>
  );
};

const useStyles = createStyles((theme) =>
  StyleSheet.create({
    input: {
      backgroundColor: theme.colors.white,
      alignSelf: "center",
    },
    button: {
      alignSelf: "center",
      width: "50%",
    },
  })
);