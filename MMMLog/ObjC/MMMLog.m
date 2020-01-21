//
// MMMTemple.
// Copyright (C) 2019 MediaMonks. All rights reserved.
//

#import "MMMLog.h"

NSString *MMMLogFormat(MMMLogLevel level, NSString *context, NSString *message) {

	NSMutableString *r = [[NSMutableString alloc] initWithCapacity:3 + context.length + 2 + message.length];

	switch (level) {
	case MMMLogLevelTrace:
		[r appendString:@"   "];
		break;
	case MMMLogLevelInfo:
		[r appendString:@" - "];
		break;
	case MMMLogLevelError:
		[r appendString:@" ! "];
		break;
	}

	[r appendString:context];

	// Two spaces better separate the message from its source.
	[r appendString:@"  "];

	[r appendString:message];

	return [r copy];
}

static MMMLogOutputBlock logOutputBlock = nil;

extern void MMMLog(MMMLogLevel level, NSString *context, NSString *message) {
	if (logOutputBlock) {
		logOutputBlock(level, context, message);
	} else {
		NSLog(@"%@", MMMLogFormat(level, context, message));
	}
}

extern void MMMLogOverrideOutputWithBlock(MMMLogOutputBlock block) {

	if (logOutputBlock != nil && block != nil) {
		NSCAssert(NO, @"The output of MMMLog() is already overriden");
		return;
	}

	logOutputBlock = block;
}

/// Name of the class without the "module" part for Swift ones.
/// TODO: this works only for non-mangled names, need to do basic demangle instead.
static NSString *MMMPlainClassName(Class cls) {
	NSString *name = NSStringFromClass(cls);
	NSRange dotRange = [name rangeOfString:@"." options:NSBackwardsSearch];
	if (dotRange.location == NSNotFound) {
		return name;
	} else {
		return [name substringFromIndex:dotRange.location + 1];
	}
}

extern NSString *MMMLogContextFromObject(NSObject *obj) {
	NSString *instanceName = [obj mmm_instanceNameForLogging];
	if ([instanceName length] > 0)
		return [NSString stringWithFormat:@"%@#%@", MMMPlainClassName(obj.class), instanceName];
	else
		return MMMPlainClassName(obj.class);
}

//
//
//
@implementation NSObject (MMMUtilLogging)

static NSString *MMMLastFewDigitsOfAddresss(id obj) {
	uint32_t partialAddress = (uint32_t)(__bridge void *)obj;
	return [NSString stringWithFormat:@"%x", (int)(partialAddress & 0xFFF)];
}

- (NSString *)mmm_instanceNameForLogging {
	return MMMLastFewDigitsOfAddresss(self);
}

+ (NSString *)mmm_instanceNameForLogging {
	return MMMLastFewDigitsOfAddresss(self);
}

@end

NSString *_MMMSensitiveInfo(NSString *value, NSInteger maxChars) {

	// Nils are covered this way, too.
	if (![value isKindOfClass:[NSString class]])
		return @"<?>";

	NSInteger actualCount = MIN([value length], ABS(maxChars));

	NSMutableString *filler = [[NSMutableString alloc] init];
	for (NSInteger i = MIN(16, value.length - actualCount); i > 0; i--)
		[filler appendString:@"*"];

	if (maxChars > 0) {
		return [[value substringToIndex:actualCount] stringByAppendingString:filler];
	} else {
		return [filler stringByAppendingString:[value substringFromIndex:[value length] - actualCount]];
	}
}
