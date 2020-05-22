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

#import "Utils.h"
#import "GlobalInfo.h"
//#import "Constants.h"
#import "imageUtil.h"

#pragma mark -
#pragma mark Functions

void matrixPerspective(float right, float left, float top, float bottom, float near, float far, mat4 matrix)
{
    //mat4 matrix;
    //mat4 rotMatrix;
    
	// Unused values in perspective formula.
	matrix[1] = matrix[2] = matrix[3] = matrix[4] = 0;
	matrix[6] = matrix[7] = matrix[12] = matrix[13] = matrix[15] = 0;
	
	// Perspective formula.
	matrix[5] = 2 * near / (right - left);
	matrix[0] = 2 * near / (top - bottom);
	matrix[3] = (right + left) / (right - left);
	matrix[6] = (top + bottom) / (top - bottom);
	matrix[10] = -(far + near) / (far - near);
	matrix[11] = -1;
	matrix[14] = -(2 * far * near) / (far - near);
    
    //matrixRotateZ(90.0, rotMatrix);
    
    //matrixMultiply(matrix, rotMatrix, mat);
    
}

void matrixOrtho(mat4 m){
    
    //mat4 m;
    //mat4 rotMatrix;
    
    float ratio = [GlobalInfo ScreenWidth]/[GlobalInfo ScreenHeight];
    
    
    //matrixIdentity(rotMatrix);
    
    //matrixRotateZ(90.0, rotMatrix);
    
  
    m[0] = -(1/ratio);
    m[5] = 1;
   
    m[10] = m[15] = 1.0;
	m[1] = m[2] = m[3] = m[4] = 0.0;
	m[6] = m[7] = m[8] = m[9] = 0.0;
	m[11] = m[12] = m[13] = m[14] = 0.0;
    
    //matrixMultiply(m, rotMatrix, mat);

}

void matrixIdentity(mat4 m)
{
	m[0] = m[5] = m[10] = m[15] = 1.0;
	m[1] = m[2] = m[3] = m[4] = 0.0;
	m[6] = m[7] = m[8] = m[9] = 0.0;
	m[11] = m[12] = m[13] = m[14] = 0.0;
}

void matrixCopy(mat4 original, mat4 result)
{
	memcpy(result, original, sizeof(mat4));
}


void matrixTranslate(float x, float y, float z, mat4 matrix)
{
	// Translate slots.
	matrix[12] = x;
	matrix[13] = y;
	matrix[14] = z;   
}

void matrixScale(float x, float y, float z, mat4 matrix)
{
	matrix[1] = matrix[2] = matrix[3] = matrix[4] = 0.0;
	matrix[6] = matrix[7] = matrix[8] = matrix[9] = 0.0;
	matrix[11] = matrix[12] = matrix[13] = matrix[14] = 0.0;
	matrix[15] = 1.0;
	
	// Scale slots.
	matrix[0] = x;
	matrix[5] = y;
	matrix[10] = z;
}

void matrixRotateX(float degrees, mat4 matrix)
{
	float radians = degreesToRadians(degrees);
	
	matrix[1] = matrix[2] = matrix[3] = matrix[4] = matrix[7] = 0.0;
	matrix[8] = matrix[11] = matrix[12] = matrix[13] = matrix[14] = 0.0;
	matrix[0] = matrix[15] = 1.0;
	
	// Rotate X formula.
	matrix[5] = cosf(radians);
	matrix[6] = -sinf(radians);
	matrix[9] = -matrix[6];
	matrix[10] = matrix[5];
}

void matrixRotateY(float degrees, mat4 matrix)
{
	float radians = degreesToRadians(degrees);
	
	matrix[1] = matrix[3] = matrix[4] = matrix[6] = matrix[7] = 0.0;
	matrix[9] = matrix[11] = matrix[13] = matrix[12] = matrix[14] = 0.0;
	matrix[5] = matrix[15] = 1.0;
	
	// Rotate Y formula.
	matrix[0] = cosf(radians);
	matrix[2] = sinf(radians);
	matrix[8] = -matrix[2];
	matrix[10] = matrix[0];
}

void matrixRotateZ(float degrees, mat4 matrix)
{
	float radians = degreesToRadians(degrees);
	
	matrix[2] = matrix[3] = matrix[6] = matrix[7] = matrix[8] = 0.0;
	matrix[9] = matrix[11] = matrix[12] = matrix[13] = matrix[14] = 0.0;
	matrix[10] = matrix[15] = 1.0;
	
	// Rotate Z formula.
	matrix[0] = cosf(radians);
	matrix[1] = sinf(radians);
	matrix[4] = -matrix[1];
	matrix[5] = matrix[0];
}

void matrixMultiply(mat4 m1, mat4 m2, mat4 result)
{
	// Fisrt Column
	result[0] = m1[0] * m2[0] + m1[4] * m2[1] + m1[8] * m2[2] + m1[12] * m2[3];
	result[1] = m1[1] * m2[0] + m1[5] * m2[1] + m1[9] * m2[2] + m1[13] * m2[3];
	result[2] = m1[2] * m2[0] + m1[6] * m2[1] + m1[10] * m2[2] + m1[14] * m2[3];
	result[3] = m1[3] * m2[0] + m1[7] * m2[1] + m1[11] * m2[2] + m1[15] * m2[3];
	
	// Second Column
	result[4] = m1[0] * m2[4] + m1[4] * m2[5] + m1[8] * m2[6] + m1[12] * m2[7];
	result[5] = m1[1] * m2[4] + m1[5] * m2[5] + m1[9] * m2[6] + m1[13] * m2[7];
	result[6] = m1[2] * m2[4] + m1[6] * m2[5] + m1[10] * m2[6] + m1[14] * m2[7];
	result[7] = m1[3] * m2[4] + m1[7] * m2[5] + m1[11] * m2[6] + m1[15] * m2[7];
	
	// Third Column
	result[8] = m1[0] * m2[8] + m1[4] * m2[9] + m1[8] * m2[10] + m1[12] * m2[11];
	result[9] = m1[1] * m2[8] + m1[5] * m2[9] + m1[9] * m2[10] + m1[13] * m2[11];
	result[10] = m1[2] * m2[8] + m1[6] * m2[9] + m1[10] * m2[10] + m1[14] * m2[11];
	result[11] = m1[3] * m2[8] + m1[7] * m2[9] + m1[11] * m2[10] + m1[15] * m2[11];
	
	// Fourth Column
	result[12] = m1[0] * m2[12] + m1[4] * m2[13] + m1[8] * m2[14] + m1[12] * m2[15];
	result[13] = m1[1] * m2[12] + m1[5] * m2[13] + m1[9] * m2[14] + m1[13] * m2[15];
	result[14] = m1[2] * m2[12] + m1[6] * m2[13] + m1[10] * m2[14] + m1[14] * m2[15];
	result[15] = m1[3] * m2[12] + m1[7] * m2[13] + m1[11] * m2[14] + m1[15] * m2[15];
}

GLuint newTexture(NSString* filename)
{
    return loadTexture(filename);
}

GLuint newProgram(GLuint vertexShader, GLuint fragmentShader)
{
	GLuint name;
	
	// Creates the program name/index.
	name = glCreateProgram();
	
	// Will attach the fragment and vertex shaders to the program object.
	glAttachShader(name, vertexShader);
	glAttachShader(name, fragmentShader);
    

	// Will link the program into OpenGL core.
	glLinkProgram(name);
	
//#if defined(DEBUG)
	
	GLint logLength;
	
	// Instead use GL_INFO_LOG_LENGTH we could use COMPILE_STATUS.
	// I prefer to take the info log length, because it'll be 0 if the
	// shader was successful compiled. If we use COMPILE_STATUS
	// we will need to take info log length in case of a fail anyway.
	glGetProgramiv(name, GL_INFO_LOG_LENGTH, &logLength);
	
	if (logLength > 0)
	{
		// Allocates the necessary memory to retrieve the message.
		GLchar *log = (GLchar *)malloc(logLength);
		
		// Get the info log message.
		glGetProgramInfoLog(name, logLength, &logLength, log);
		
		// Shows the message in console.
		printf("Error in Program Creation:\n%s\n",log);
		
		// Frees the allocated memory.
		free(log);
	}
//#endif
	
	return name;
}

GLuint newShader(GLenum type, const char **source)
{
	GLuint name;
	
	// Creates a Shader Object and returns its name/id.
	name = glCreateShader(type);
	
	// Uploads the source to the Shader Object.
	glShaderSource(name, 1, source, NULL);
	
	// Compiles the Shader Object.
	glCompileShader(name);
	
	// If are running in debug mode, query for info log.
	// DEBUG is a pre-processing Macro defined to the compiler.
	// Some languages could not has a similar to it.
//#if defined(DEBUG)
	
	GLint logLength;
	
	// Instead use GL_INFO_LOG_LENGTH we could use COMPILE_STATUS.
	// I prefer to take the info log length, because it'll be 0 if the
	// shader was successful compiled. If we use COMPILE_STATUS
	// we will need to take info log length in case of a fail anyway.
	glGetShaderiv(name, GL_INFO_LOG_LENGTH, &logLength);
	
	if (logLength > 0)
	{
		// Allocates the necessary memory to retrieve the message.
		GLchar *log = (GLchar *)malloc(logLength);
		
		// Get the info log message.
		glGetShaderInfoLog(name, logLength, &logLength, log);
		
		// Shows the message in console.
		printf("Error in Shader Creation:\n%s\n",log);
		
		// Frees the allocated memory.
		free(log);
	}
//#endif
	
	return name;
}

void destroyProgram(GLuint prgName)
{
	
	if(0 == prgName)
	{
		return;
	}
	
	GLsizei shaderNum;
	GLsizei shaderCount;
	
	// Get the number of attached shaders
	glGetProgramiv(prgName, GL_ATTACHED_SHADERS, &shaderCount);
	
	GLuint* shaders = (GLuint*)malloc(shaderCount * sizeof(GLuint));
	
	// Get the names of the shaders attached to the program
	glGetAttachedShaders(prgName,
						 shaderCount,
						 &shaderCount,
						 shaders);
	
	// Delete the shaders attached to the program
	for(shaderNum = 0; shaderNum < shaderCount; shaderNum++)
	{
		glDeleteShader(shaders[shaderNum]);
	}
	
	free(shaders);
	
	// Delete the program
	glDeleteProgram(prgName);
	glUseProgram(0);
}

void colorMultiply(GLfloat *color, float multiplier, GLfloat *result){
    for(int i=0; i<3;i++)
    {
        result[i]=color[i]*multiplier;
    }
}

void colorMix(GLfloat *colorA, GLfloat *colorB, float proportion, GLfloat *result){
    for(int i=0;i<3;i++){
        result[i]=colorA[i]*(1.0-proportion)+colorB[i]*proportion;
    }
}


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
NSString *getDeclensionForNumber(long number, NSString *single, NSString *few, NSString *lots){
    
    NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSArray *langs = [NSArray arrayWithObjects:@"ru", nil];
    
    Boolean useDeclension=false;
    for(NSString *str in langs){
        if([str hasPrefix:language]){
            useDeclension=true;
            break;
        }
    }
    
    if(useDeclension){
        if(number>10 && number<20) //Exceptional endings
        {
            return lots;
        }else{
            char last = number % 10; //Get last digit
            
            if(last==1){
                return single;
            }else{
                if(last>=2 && last<=4){
                    return few;
                }else{
                    return lots; // 0, 5-9
                }
            }
        }
    }
    else{
        if(number==1){
            return single;
        }else{
            return lots;
        }
    }
}
