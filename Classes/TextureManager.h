//
//  TextureManager.h
//  Test
//
//  Created by Artheyn on 31/08/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


#import <OpenGLES/ES1/gl.h>

#import "TextureSet.h"



@interface TextureManager : NSObject 
{
	GLuint currentTexture;
	
	NSMutableSet* loadedTextures;
}

+(TextureManager*) sharedInstance;

-(void)	initTextureEnvironment;
-(void) loadFontTextureContext;
-(GLuint) loadTexture:(NSString*) path;

@end
