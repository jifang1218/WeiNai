//
//  EMASIS3BucketRequest.m
//  Part of EMASIHTTPRequest -> http://allseeing-i.com/EMASIHTTPRequest
//
//  Created by Ben Copsey on 16/03/2010.
//  Copyright 2010 All-Seeing Interactive. All rights reserved.
//

#import "ASIS3BucketRequest.h"
#import "ASIS3BucketObject.h"


// Private stuff
@interface EMASIS3BucketRequest ()
@property (retain, nonatomic) EMASIS3BucketObject *currentObject;
@property (retain) NSMutableArray *objects;
@property (retain) NSMutableArray *commonPrefixes;
@property (assign) BOOL isTruncated;
@end

@implementation EMASIS3BucketRequest

- (id)initWithURL:(NSURL *)newURL
{
	self = [super initWithURL:newURL];
	[self setObjects:[[[NSMutableArray alloc] init] autorelease]];
	[self setCommonPrefixes:[[[NSMutableArray alloc] init] autorelease]];
	return self;
}

+ (id)requestWithBucket:(NSString *)theBucket
{
	EMASIS3BucketRequest *request = [[[self alloc] initWithURL:nil] autorelease];
	[request setBucket:theBucket];
	return request;
}

+ (id)requestWithBucket:(NSString *)theBucket subResource:(NSString *)theSubResource
{
	EMASIS3BucketRequest *request = [[[self alloc] initWithURL:nil] autorelease];
	[request setBucket:theBucket];
	[request setSubResource:theSubResource];
	return request;
}

+ (id)PUTRequestWithBucket:(NSString *)theBucket
{
	EMASIS3BucketRequest *request = [self requestWithBucket:theBucket];
	[request setRequestMethod:@"PUT"];
	return request;
}


+ (id)DELETERequestWithBucket:(NSString *)theBucket
{
	EMASIS3BucketRequest *request = [self requestWithBucket:theBucket];
	[request setRequestMethod:@"DELETE"];
	return request;
}

- (void)dealloc
{
	[currentObject release];
	[objects release];
	[commonPrefixes release];
	[prefix release];
	[marker release];
	[delimiter release];
	[subResource release];
	[bucket release];
	[super dealloc];
}

- (NSString *)canonicalizedResource
{
	if ([self subResource]) {
		return [NSString stringWithFormat:@"/%@/?%@",[self bucket],[self subResource]];
	} 
	return [NSString stringWithFormat:@"/%@/",[self bucket]];
}

- (void)buildURL
{
	NSString *baseURL;
	if ([self subResource]) {
		baseURL = [NSString stringWithFormat:@"%@://%@.%@/?%@",[self requestScheme],[self bucket],[[self class] S3Host],[self subResource]];
	} else {
		baseURL = [NSString stringWithFormat:@"%@://%@.%@",[self requestScheme],[self bucket],[[self class] S3Host]];
	}
	NSMutableArray *queryParts = [[[NSMutableArray alloc] init] autorelease];
	if ([self prefix]) {
		[queryParts addObject:[NSString stringWithFormat:@"prefix=%@",[[self prefix] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
	}
	if ([self marker]) {
		[queryParts addObject:[NSString stringWithFormat:@"marker=%@",[[self marker] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
	}
	if ([self delimiter]) {
		[queryParts addObject:[NSString stringWithFormat:@"delimiter=%@",[[self delimiter] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
	}
	if ([self maxResultCount] > 0) {
		[queryParts addObject:[NSString stringWithFormat:@"max-keys=%i",[self maxResultCount]]];
	}
	if ([queryParts count]) {
		NSString* template = @"%@?%@";
		if ([[self subResource] length] > 0) {
			template = @"%@&%@";
		}
		[self setURL:[NSURL URLWithString:[NSString stringWithFormat:template,baseURL,[queryParts componentsJoinedByString:@"&"]]]];
	} else {
		[self setURL:[NSURL URLWithString:baseURL]];

	}
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
	if ([elementName isEqualToString:@"Contents"]) {
		[self setCurrentObject:[EMASIS3BucketObject objectWithBucket:[self bucket]]];
	}
	[super parser:parser didStartElement:elementName namespaceURI:namespaceURI qualifiedName:qName attributes:attributeDict];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	if ([elementName isEqualToString:@"Contents"]) {
		[objects addObject:currentObject];
		[self setCurrentObject:nil];
	} else if ([elementName isEqualToString:@"Key"]) {
		[[self currentObject] setKey:[self currentXMLElementContent]];
	} else if ([elementName isEqualToString:@"LastModified"]) {
		[[self currentObject] setLastModified:[[EMASIS3Request S3ResponseDateFormatter] dateFromString:[self currentXMLElementContent]]];
	} else if ([elementName isEqualToString:@"ETag"]) {
		[[self currentObject] setETag:[self currentXMLElementContent]];
	} else if ([elementName isEqualToString:@"Size"]) {
		[[self currentObject] setSize:(unsigned long long)[[self currentXMLElementContent] longLongValue]];
	} else if ([elementName isEqualToString:@"ID"]) {
		[[self currentObject] setOwnerID:[self currentXMLElementContent]];
	} else if ([elementName isEqualToString:@"DisplayName"]) {
		[[self currentObject] setOwnerName:[self currentXMLElementContent]];
	} else if ([elementName isEqualToString:@"Prefix"] && [[self currentXMLElementStack] count] > 2 && [[[self currentXMLElementStack] objectAtIndex:[[self currentXMLElementStack] count]-2] isEqualToString:@"CommonPrefixes"]) {
		[[self commonPrefixes] addObject:[self currentXMLElementContent]];
	} else if ([elementName isEqualToString:@"IsTruncated"]) {
		[self setIsTruncated:[[self currentXMLElementContent] isEqualToString:@"true"]];
	} else {
		// Let EMASIS3Request look for error messages
		[super parser:parser didEndElement:elementName namespaceURI:namespaceURI qualifiedName:qName];
	}
}

#pragma mark NSCopying

- (id)copyWithZone:(NSZone *)zone
{
	EMASIS3BucketRequest *newRequest = [super copyWithZone:zone];
	[newRequest setBucket:[self bucket]];
	[newRequest setSubResource:[self subResource]];
	[newRequest setPrefix:[self prefix]];
	[newRequest setMarker:[self marker]];
	[newRequest setMaxResultCount:[self maxResultCount]];
	[newRequest setDelimiter:[self delimiter]];
	return newRequest;
}

@synthesize bucket;
@synthesize subResource;
@synthesize currentObject;
@synthesize objects;
@synthesize commonPrefixes;
@synthesize prefix;
@synthesize marker;
@synthesize maxResultCount;
@synthesize delimiter;
@synthesize isTruncated;

@end
