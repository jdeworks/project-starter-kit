import { useState } from "react";
import { StyleSheet, Text, View, Pressable } from "react-native";
import { createCounter, increment, getCount } from "../src/counter";

export default function HomeScreen() {
  const [counter, setCounter] = useState(createCounter());

  const handlePress = () => {
    const next = increment(counter);
    setCounter(next);
  };

  return (
    <View style={styles.container}>
      <Text style={styles.title}>Welcome to My App</Text>
      <Text style={styles.count}>Count: {getCount(counter)}</Text>
      <Pressable style={styles.button} onPress={handlePress}>
        <Text style={styles.buttonText}>Increment</Text>
      </Pressable>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: "center",
    justifyContent: "center",
    backgroundColor: "#fff",
  },
  title: {
    fontSize: 24,
    fontWeight: "bold",
    marginBottom: 24,
  },
  count: {
    fontSize: 48,
    fontWeight: "bold",
    marginBottom: 24,
  },
  button: {
    backgroundColor: "#6200ee",
    paddingHorizontal: 24,
    paddingVertical: 12,
    borderRadius: 8,
  },
  buttonText: {
    color: "#fff",
    fontSize: 18,
    fontWeight: "600",
  },
});
