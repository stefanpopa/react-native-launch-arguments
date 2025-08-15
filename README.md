# @adeptus_artifex/react-native-launch-arguments

Access launch arguments and command-line parameters in React Native iOS and Android apps.
This package is a rewrite of this: https://github.com/iamolegga/react-native-launch-arguments all credits to the original author.

## Installation

```sh
npm install @adeptus_artifex/react-native-launch-arguments
cd ios && pod install  # iOS only
```

## Usage

```js
import { LaunchArguments } from '@adeptus_artifex/react-native-launch-arguments';

const args = LaunchArguments.value();
console.log('Launch args:', args);
```

## Examples

Launch your app with arguments:
```bash
# iOS
xcrun simctl launch booted com.yourapp --env=staging --debug

# Android
adb shell am start -n com.yourapp/.MainActivity --es env staging --ez debug true

Your app receives:
```js
{
  env: "staging",
  debug: "true"
}
```

## Supported Formats

- `--flag` → `{flag: true}`
- `--flag=value` → `{flag: "value"}`
- `--flag value` → `{flag: "value"}`
- `-flag value` → `{flag: "value"}`
- `bareword` → `{bareword: true}`

## Use Cases

- Environment switching (dev/staging/prod)
- Feature toggles and debug mode
- Testing automation with Maestro
- Runtime configuration

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for details.

## License

MIT
