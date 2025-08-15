import type { TurboModule } from 'react-native';
import { TurboModuleRegistry } from 'react-native';

export interface Spec extends TurboModule {
  readonly getConstants: () => {
    VALUE: Object;
  };
}

export default TurboModuleRegistry.getEnforcing<Spec>('ReactNativeLaunchArguments');
