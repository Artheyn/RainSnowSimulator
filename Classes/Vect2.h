//
//  Vect2.h
//  Test
//
//  Created by Artheyn on 20/08/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES1/gl.h>


@interface Vect2 : NSObject 
{
@private
	float x;
	float y;
}

@property float x;
@property float y;



-(id)		initWithX:(float) xV andY:(float) yV;
-(GLfloat*) arrayValue;
-(void)		plusEqualVector:(Vect2*) aVector;
-(void)		plusEqualScalar:(float) aScalar;
-(void)		display;

+(Vect2*)	multScalar:(float) aScalar withVector:(Vect2*) aVector;
+(BOOL)		isVectorTo0:(Vect2*) aVector;

@end

