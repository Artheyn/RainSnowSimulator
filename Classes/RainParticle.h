//
//  RainParticle.h
//  Test
//
//  Created by Artheyn on 17/09/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Particle.h"

@interface RainParticle : Particle 
{
	GLuint OglTextureName;
}

-(void) display;
-(void) loadTexture:(NSString*) textureImageName;

@end
