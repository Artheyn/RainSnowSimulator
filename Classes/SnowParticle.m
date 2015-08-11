//
//  SnowParticle.m
//  Test
//
//  Created by Artheyn on 17/09/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SnowParticle.h"


@implementation SnowParticle

-(void) display
{
	glBindTexture(GL_TEXTURE_2D, OglTextureName);
	[super display];
}

-(void) loadTexture:(NSString*) textureImageName
{
	OglTextureName = [textureManager loadTexture:textureImageName];
}

@end
