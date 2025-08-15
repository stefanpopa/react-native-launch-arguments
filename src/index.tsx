import ReactNativeLaunchArguments from './NativeReactNativeLaunchArguments';

type LaunchArgumentsType = {
  value<T extends object = Record<string, string | boolean>>(): T;
};

let parsed: Record<string, string | boolean> | null = null;

export const LaunchArguments: LaunchArgumentsType = {
  value<T>(): T {
    if (parsed) {
      return parsed as any as T;
    }

    parsed = {};

    const constants = ReactNativeLaunchArguments.getConstants();
    const raw = constants.VALUE as Record<string, any>;

    for (const k in raw) {
      const rawValue = raw[k];
      if (typeof rawValue === 'string') {
        try {
          parsed[k] = JSON.parse(rawValue);
        } catch {
          parsed[k] = rawValue;
        }
      } else {
        parsed[k] = rawValue;
      }
    }

    return parsed as any as T;
  },
};
