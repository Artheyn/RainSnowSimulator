//
//  TextureSet.h
//  Test
//
//  Created by Artheyn on 13/09/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES1/gl.h>


@interface TextureSet : NSObject 
{
@private
	NSString* textureImageName;
	GLuint textureOpenGLName;
}

@property(nonatomic, retain) NSString* textureImageName;
@property GLuint textureOpenGLName;

-(id) initWithImageName:(NSString*) path AndOGLName:(GLuint) name;
-(BOOL) isTexturePathEqual:(NSString*) txPath;

@end
