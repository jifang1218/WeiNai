//
//  EMASICloudFilesObject.m
//
//  Created by Michael Mayo on 1/7/10.
//

#import "ASICloudFilesObject.h"


@implementation EMASICloudFilesObject

@synthesize name, hash, bytes, contentType, lastModified, data, metadata;

+ (id)object {
	EMASICloudFilesObject *object = [[[self alloc] init] autorelease];
	return object;
}

- (void)dealloc {
	[name release];
	[hash release];
	[contentType release];
	[lastModified release];
	[data release];
	[metadata release];
	[super dealloc];
}

@end
