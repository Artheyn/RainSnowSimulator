//
//  Point2f.h
//  Test
//
//  Created by Artheyn on 21/08/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES1/gl.h>

#import "Vect2.h"


@interface Point2f : NSObject 
{
@private
	float x;
	float y;
}

@property float x;
@property float y;

-(id)			initWithX:(float) aX andY:(float) aY;
-(GLfloat*)		arrayValue;
-(void)			plusEqualScalar:(float) aScalar;
-(void)			plusEqualVector:(Vect2*) aVector;
-(void)			display;

+(float)		lengthBetweenA:(Point2f*) aPoint andB:(Point2f*) anotherPoint;


@end
