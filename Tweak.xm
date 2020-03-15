
//Hooks are from https://github.com/opa334/Choicy/blob/master/ChoicySB/TweakSB.x

#import "PasteAndGo.h"

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)


%group iOS13Up

%hook SBIconView

-(NSArray *) applicationShortcutItems {
	
	NSArray* orig = %orig;

	NSString* bundleID;
	
	if ([self respondsToSelector:@selector(applicationBundleIdentifier)]){
		bundleID = [self applicationBundleIdentifier];
	} else if ([self respondsToSelector:@selector(applicationBundleIdentifierForShortcuts)]){
		bundleID = [self applicationBundleIdentifierForShortcuts];
	}

	if(!bundleID){
		return orig;
	}

	if([bundleID isEqualToString:@"com.apple.mobilesafari"]){
		
		UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard]; 
		NSString *pbStr = [pasteBoard string];
		
		if (pbStr){
			
			NSURL *url = [NSURL URLWithString:[pbStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
			
			if ([[UIApplication sharedApplication] canOpenURL:url]){
		
				SBSApplicationShortcutItem* pasteAndGoItem = [[%c(SBSApplicationShortcutItem) alloc] init];
				pasteAndGoItem.localizedTitle = @"Paste and Go";
				pasteAndGoItem.type = @"com.lint.pasteandgo.item";

				return [orig arrayByAddingObject:pasteAndGoItem];
			}
		}
	}

	return orig;
}

+(void) activateShortcut:(SBSApplicationShortcutItem*)item withBundleIdentifier:(NSString*)bundleID forIconView:(id)iconView{
	
	if ([[item type] isEqualToString:@"com.lint.pasteandgo.item"]){
		
		UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard]; 
		NSString *pbStr = [pasteBoard string];
		
		if (pbStr){
			
			NSURL *url = [NSURL URLWithString:[pbStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
			
			if ([[UIApplication sharedApplication] canOpenURL:url]){
				[[UIApplication sharedApplication] openURL:url];
			}
		}
	}

	%orig;
}

%end

%end


%group iOS12Down

%hook SBUIAppIconForceTouchControllerDataProvider

-(NSArray *) applicationShortcutItems {
	
	NSArray *orig = %orig;

	NSString *bundleID = [self applicationBundleIdentifier];

	if (!bundleID){
		return orig;
	}
	
	if ([bundleID isEqualToString:@"com.apple.mobilesafari"]){
		
		UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard]; 
		NSString *pbStr = [pasteBoard string];
		
		if (pbStr){
			
			NSURL *url = [NSURL URLWithString:[pbStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
			
			if ([[UIApplication sharedApplication] canOpenURL:url]){
				
				SBSApplicationShortcutItem* pasteAndGoItem = [[%c(SBSApplicationShortcutItem) alloc] init];
				pasteAndGoItem.localizedTitle = @"Paste and Go";
				pasteAndGoItem.type = @"com.lint.pasteandgo.item";

				if (!orig){
					return @[pasteAndGoItem];
				} else {
					return [orig arrayByAddingObject:pasteAndGoItem];
				}
			}
		}
	}

	return orig;
}

%end


%hook SBUIAppIconForceTouchController

-(void) appIconForceTouchShortcutViewController:(id)arg1 activateApplicationShortcutItem:(SBSApplicationShortcutItem*)item {
	
	if ([item.type isEqualToString:@"com.lint.pasteandgo.item"]){
		
		UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard]; 
		NSString *pbStr = [pasteBoard string];
		
		if (pbStr){
			
			NSURL *url = [NSURL URLWithString:[pbStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
			
			if ([[UIApplication sharedApplication] canOpenURL:url]){
				[[UIApplication sharedApplication] openURL:url];
			}
		}
	}

	%orig;
}

%end

%end

%ctor{
	
	if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"13.0")){
		%init(iOS13Up);
	} else {
		%init(iOS12Down);
	}
}

