//
//  TextureManager.m
//  Test
//
//  Created by Artheyn on 31/08/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TextureManager.h"


static TextureManager* sharedTextureManager;

@implementation TextureManager


+(TextureManager*) sharedInstance
{
	if(!sharedTextureManager)
	{
		sharedTextureManager = [[TextureManager alloc] init];
		sharedTextureManager->currentTexture = 0;
		sharedTextureManager->loadedTextures = [[NSMutableSet alloc] init];
	}
	
	return sharedTextureManager;
}


-(void)	initTextureEnvironment
{
	//Enable point sprites
	glEnable(GL_POINT_SPRITE_OES);
	//Enable point sprites texture coordinates generation
	glTexEnvx(GL_POINT_SPRITE_OES, GL_COORD_REPLACE_OES, GL_TRUE);
	
	// Set the texture parameters to use a minifying filter and a linear filer (weighted average)
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
	// Enable use of the texture
	glEnable(GL_TEXTURE_2D);
	// Set a blending function to use
	glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
	// Enable blending
	glEnable(GL_BLEND);
	// Enable transparency
	glEnable(GL_ALPHA_TEST);
}

-(void) loadFontTextureContext
{
	glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glEnable(GL_TEXTURE_2D);
	
}

-(GLuint) loadTexture:(NSString*) path
{
	CGImageRef texImage;
	CGContextRef texContext;
	GLubyte* texData;
	size_t	width, height;
	
	GLuint generatedTextureName;
	BOOL wasAlreadyGenerated = NO;
	GLuint foundTexture;
	
	// Creates a Core Graphics image from an image file
	texImage = [UIImage imageNamed:path].CGImage;
	// Get the width and height of the image
	width = CGImageGetWidth(texImage);
	height = CGImageGetHeight(texImage);
	// Texture dimensions must be a power of 2. If you write an application that allows users to supply an image,
	// you'll want to add code that checks the dimensions and takes appropriate action if they are not a power of 2.

	for(TextureSet* ts in loadedTextures)
	{
		if([ts isTexturePathEqual:path])
		{
			wasAlreadyGenerated = YES;
			foundTexture = [ts textureOpenGLName];
		}
	}
	
	// If the texture is already generated
	if(wasAlreadyGenerated)
	{
		[self initTextureEnvironment];
		glBindTexture(GL_TEXTURE_2D, foundTexture);
		return foundTexture;
	}
	// Else we create the texture
	else
	{
		if(texImage) 
		{
			// Allocated memory needed for the bitmap context
			texData = (GLubyte *) malloc(width * height * 4);
			// Uses the bitmatp creation function provided by the Core Graphics framework. 
			texContext = CGBitmapContextCreate(texData, width, height, 8, width * 4, CGImageGetColorSpace(texImage), kCGImageAlphaPremultipliedLast);
			// After you create the context, you can draw the sprite image to the context.
			CGContextDrawImage(texContext, CGRectMake(0.0, 0.0, (CGFloat)width, (CGFloat)height), texImage);
			// You don't need the context at this point, so you need to release it to avoid memory leaks.
			CGContextRelease(texContext);
			
			generatedTextureName = currentTexture++;
			// Bind the texture name. 
			glBindTexture(GL_TEXTURE_2D, generatedTextureName);
			// Speidfy a 2D texture image, provideing the a pointer to the image data in memory
			glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, texData);
			// Release the image data
			free(texData);
		}
		
		[self initTextureEnvironment];
		
		[loadedTextures addObject:[[TextureSet alloc] initWithImageName:path AndOGLName:generatedTextureName]];
	}
	
	return generatedTextureName;
}

@end
