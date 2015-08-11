//
//  TextureSet.m
//  Test
//
//  Created by Artheyn on 13/09/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TextureSet.h"


@implementation TextureSet

@synthesize textureImageName;
@synthesize textureOpenGLName;

-(id) initWithImageName:(NSString*) path AndOGLName:(GLuint) name
{
	if( !(self = [super init]) )
	{
		return nil;
	}
	
	self->textureImageName = [[NSString alloc] initWithString:path];
	self->textureOpenGLName = name;
	
	return self;
}

-(BOOL) isTexturePathEqual:(NSString*) txPath
{
	return [self->textureImageName isEqualToString:txPath];
}

@end
