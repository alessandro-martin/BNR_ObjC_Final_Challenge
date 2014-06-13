//
//  NSData+Speakable.m
//  FinalChallenge
//
//  Created by Alessandro on 08/06/14.
//  Copyright (c) 2014 Alessandro. All rights reserved.
//

#import "NSData+Speakable.h"

NSArray *brands;

NSString *intToBrand(int n){
	if (n < 0 || n > [brands count] - 1) {
		return @"";
	} else {
		return brands[n];
	}
}

NSUInteger brandToInt(NSString *brand){
	return [brands indexOfObject:brand];
}

@implementation NSData (Speakable)

+ (void) initialize
{
	if (!brands) {
		brands = @[@"Camry", @"Nikon", @"Apple", @"Ford", @"Audi", @"Google", @"Nike", @"Amazon",
				   @"Honda", @"Mazda", @"Buick", @"Fiat", @"Jeep", @"Lexus", @"Volvo", @"Fuji",
				   @"Sony", @"Delta", @"Focus", @"Puma", @"Samsung", @"Tivo", @"Halo", @"Sting",
				   @"Shrek", @"Avatar", @"Shell", @"Visa", @"Vogue", @"Twitter", @"Lego", @"Pepsi"];

	}
}

- (NSString *)encodeAsSpeakableString
{
	NSMutableString *result = [NSMutableString string];
	const uint8_t *bytes = [self bytes];
	for (int i = 0; i < [self length]; i++) {
		uint8_t number = ((bytes[i] & 0xe0) >> 5) + 2;// Leftmost 3 bits shifted right 5 and added 2
		uint8_t brand =  (bytes[i] & 0x1f);// Rightmost 5 bits
		[result appendFormat:@"%d %@", number, intToBrand(brand)];
		if (i < [self length] - 1) {
			[result appendString:@" "];
		}
	}
	return result;
}



+ (NSData *)dataWithSpeakableString:(NSString *)s
							  error:(NSError **)e
{
	NSMutableData *result = [NSMutableData data];
	NSArray *tokens = [s componentsSeparatedByString:@" "];
	for (int i = 0; i < tokens.count; i++) {
		uint8_t digit = [tokens[i] intValue];
		digit = (digit - 2) << 5;
		i++; // Processing pairs of values, this may be a little unorthodox though...
		if (brandToInt(tokens[i]) != NSNotFound) {
		 	uint8_t brand = brandToInt(tokens[i]);
			digit += brand;
			[result appendBytes:&digit length:1];
		} else {
			if (e){
				NSDictionary *userInfo = @{NSLocalizedDescriptionKey: @"Unable to parse"};
				*e = [NSError errorWithDomain:@"SpeakableBytes"
										 code:1
									 userInfo:userInfo];
				return nil;
			}
		}
	}
	
	return result;
}


@end
