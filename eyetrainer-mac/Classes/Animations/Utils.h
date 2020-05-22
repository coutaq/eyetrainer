/*!
 *	@file			Utils.h
 *
 *	@title			Utils
 *
 *	@author			Created by Diney Bomfim on 15/2/11.
 *	
 *	@copyright		© 2011 DB-Interactive. All rights reserved.
 *
 *	@discussion		This project is an integrant part of the serie of tutorials "All about OpenGL ES 2.x"
 *					created on http://db-in.com/blog/
 *
 *					<ul>
 *						<li>1th - http://db-in.com/blog/2011/01/all-about-opengl-es-2-x-part-13/</li>
 *						<li>2nd - http://db-in.com/blog/2011/02/all-about-opengl-es-2-x-part-23/</li>
 *						<li>3rd - http://db-in.com/blog/2011/05/all-about-opengl-es-2-x-part-33/</li>
 *					</ul>
 *
 *					This tutorial contains a platform specific part for the iPhone iOS 3.2
 *					and may need modifications before you can run it.
 */

#import <Foundation/Foundation.h>
#import "glUtil.h"

#pragma mark -
#pragma mark Global Properties
//**********************************************************************************************************
//
//  Global Properties
//
//**********************************************************************************************************

#define kPI		 3.141592	// PI
#define kPI180	 0.017453	// PI / 180
#define k180PI	57.295780	// 180 / PI

#pragma mark -
#pragma mark Global Functions
//**********************************************************************************************************
//
//  Global Functions
//
//**********************************************************************************************************

// Convert degrees to radians and vice versa.
#define degreesToRadians(x) (x * kPI180)
#define radiansToDegrees(x) (x * k180PI)

#pragma mark -
#pragma mark Definitions

typedef float mat4[16];
typedef float vec4[4];

#pragma mark -
#pragma mark Functions

void matrixOrtho(mat4 m);

void matrixIdentity(mat4 m);

void matrixCopy(mat4 original, mat4 result);

void matrixTranslate(float x, float y, float z, mat4 matrix);

void matrixScale(float x, float y, float z, mat4 matrix);

void matrixRotateX(float degrees, mat4 matrix);

void matrixRotateY(float degrees, mat4 matrix);

void matrixRotateZ(float degrees, mat4 matrix);

void matrixMultiply(mat4 m1, mat4 m2, mat4 result);

void matrixPerspective(float right, float left, float top, float bottom, float near, float far, mat4 matrix);

GLuint newTexture(NSString* filename);

GLuint newProgram(GLuint vertexShader, GLuint fragmentShader);

GLuint newShader(GLenum type, const char **source);

void colorMultiply(GLfloat *color, float multiplier, GLfloat *result);

void colorMix(GLfloat *colorA, GLfloat *colorB, float proportion, GLfloat *result);

/*!
 *	@function		getDeclensionForNumber
 *
 *	@abstract		Returns right declension for number
 *
 *
 *	@param			number
 *					given number
 *
 *	@param			single
 *                  declension for number ending with 1
 *
 *	@param			few
 *                  declension for numbers ending with 2-4
 *                  this is different from "lots" in cyrillic languages
 *                  for others use same as "lots"
 *
 *	@param			lots
 *                  declension for numbers ending with 0, 5-9 ,
 *
 *					shader at once, this array should be an array with one element only.
 */
NSString *getDeclensionForNumber(long number, NSString *single, NSString *few, NSString *lots);
