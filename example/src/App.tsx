import { Text, View, StyleSheet } from 'react-native';
import {LaunchArguments} from '@adeptus_artifex/react-native-launch-arguments';

const flags = LaunchArguments.value();

export default function App() {
  return (
    <View style={styles.container}>
      <Text>Arguments: {JSON.stringify(flags)}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
});
