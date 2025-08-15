#import "ReactNativeLaunchArguments.h"

// Constants
static NSString *const kTruthyValue = @"true";
static NSString *const kFlagPrefix = @"--";
static NSString *const kKeyPrefix = @"-";
static NSString *const kPairSeparator = @"=";

@interface ReactNativeLaunchArguments ()
- (NSDictionary *)parsedLaunchArguments;
- (BOOL)isFlagArgument:(NSString *)argument;
- (BOOL)isPairArgument:(NSString *)argument;
- (BOOL)isKeyArgument:(NSString *)argument;
- (NSString *)cleanArgument:(NSString *)argument;
- (void)processFlagArgument:(NSString *)argument
                 atIndex:(NSInteger)index
              arguments:(NSArray *)arguments
           intoDictionary:(NSMutableDictionary *)dictionary;
- (void)processKeyArgument:(NSString *)argument
                 atIndex:(NSInteger)index
              arguments:(NSArray *)arguments
           intoDictionary:(NSMutableDictionary *)dictionary;
- (void)processBareWordArgument:(NSString *)argument
                      atIndex:(NSInteger)index
                   arguments:(NSArray *)arguments
                 intoDictionary:(NSMutableDictionary *)dictionary;
@end

@implementation ReactNativeLaunchArguments
RCT_EXPORT_MODULE()

- (nonnull facebook::react::ModuleConstants<JS::NativeReactNativeLaunchArguments::Constants::Builder>)getConstants {
  NSDictionary *args = self.parsedLaunchArguments;
  
  return facebook::react::typedConstants<JS::NativeReactNativeLaunchArguments::Constants::Builder>(
    JS::NativeReactNativeLaunchArguments::Constants::Builder::Input{args}
  );
}

- (nonnull facebook::react::ModuleConstants<JS::NativeReactNativeLaunchArguments::Constants::Builder>)constantsToExport { 
  return [self getConstants];
}


- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
    (const facebook::react::ObjCTurboModule::InitParams &)params
{
    return std::make_shared<facebook::react::NativeReactNativeLaunchArgumentsSpecJSI>(params);
}

// MARK: - Argument Parsing

- (NSDictionary *)parsedLaunchArguments {
    NSArray<NSString *> *processArgs = NSProcessInfo.processInfo.arguments;
    NSMutableArray<NSString *> *arguments = [processArgs mutableCopy];
    [arguments removeObjectAtIndex:0]; // Remove entrypoint
    
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    
    for (NSInteger i = 0; i < arguments.count; i++) {
        NSString *current = arguments[i];
        
        if ([self isFlagArgument:current]) {
            [self processFlagArgument:current atIndex:i arguments:arguments intoDictionary:result];
        } else if ([self isKeyArgument:current]) {
            [self processKeyArgument:current atIndex:i arguments:arguments intoDictionary:result];
        } else {
            [self processBareWordArgument:current atIndex:i arguments:arguments intoDictionary:result];
        }
    }
    
    return [result copy];
}

// MARK: - Argument Processing Helpers

- (void)processFlagArgument:(NSString *)argument
                  atIndex:(NSInteger)index
               arguments:(NSArray *)arguments
           intoDictionary:(NSMutableDictionary *)dictionary {
    if ([self isPairArgument:argument]) {
        NSArray<NSString *> *pair = [argument componentsSeparatedByString:kPairSeparator];
        dictionary[[self cleanArgument:pair[0]]] = pair[1];
        return;
    }
    
    NSString *key = [self cleanArgument:argument];
    if (index + 1 < arguments.count) {
        NSString *next = arguments[index + 1];
        dictionary[key] = [self isKeyArgument:next] ? kTruthyValue : next;
    } else {
        dictionary[key] = kTruthyValue;
    }
}

- (void)processKeyArgument:(NSString *)argument
                 atIndex:(NSInteger)index
              arguments:(NSArray *)arguments
           intoDictionary:(NSMutableDictionary *)dictionary {
    if (index + 1 < arguments.count) {
        dictionary[[self cleanArgument:argument]] = arguments[index + 1];
    }
}

- (void)processBareWordArgument:(NSString *)argument
                      atIndex:(NSInteger)index
                   arguments:(NSArray *)arguments
                 intoDictionary:(NSMutableDictionary *)dictionary {
    NSString *next = (index + 1 < arguments.count) ? arguments[index + 1] : nil;
    dictionary[argument] = (!next || [self isKeyArgument:next]) ? kTruthyValue : next;
}

// MARK: - Argument Validation Helpers

- (BOOL)isFlagArgument:(NSString *)argument {
    return [argument hasPrefix:kFlagPrefix];
}

- (BOOL)isPairArgument:(NSString *)argument {
    return [argument rangeOfString:kPairSeparator].location != NSNotFound;
}

- (BOOL)isKeyArgument:(NSString *)argument {
    return [argument hasPrefix:kKeyPrefix];
}

- (NSString *)cleanArgument:(NSString *)argument {
    return [argument stringByReplacingOccurrencesOfString:kKeyPrefix withString:@""];
}

@end
