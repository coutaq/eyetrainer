/*
     File: OpenGLRenderer.m
 Abstract: 
 The OpenGLRenderer class creates and draws objects.
 Most of the code is OS independent.
 
  Version: 1.6
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
 Inc. ("Apple") in consideration of your agreement to the following
 terms, and your use, installation, modification or redistribution of
 this Apple software constitutes acceptance of these terms.  If you do
 not agree with these terms, please do not use, install, modify or
 redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a personal, non-exclusive
 license, under Apple's copyrights in this original Apple software (the
 "Apple Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple.  Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2012 Apple Inc. All Rights Reserved.
 
 */

#import "OpenGLRenderer.h"
#import "matrixUtil.h"
#import "imageUtil.h"
#import "modelUtil.h"
#import "sourceUtil.h"
#import "GlobalInfo.h"
#import "SceneProvider.h"

#define GetGLError()									\
{														\
	GLenum err = glGetError();							\
	while (err != GL_NO_ERROR) {						\
		NSLog(@"GLError %s set in File:%s Line:%d\n",	\
				GetGLErrorString(err),					\
				__FILE__,								\
				__LINE__);								\
		err = glGetError();								\
	}													\
}

// Toggle this to disable vertex buffer objects
// (i.e. use client-side vertex array objects)
// This must be 1 if using the GL3 Core Profile on the Mac
#define USE_VERTEX_BUFFER_OBJECTS 0

// Toggle this to disable the rendering the reflection
// and setup of the GLSL progam, model and FBO used for 
// the reflection.
#define RENDER_REFLECTION 0


// Indicies to which we will set vertex array attibutes
// See buildVAO and buildProgram
enum {
	POS_ATTRIB_IDX,
	NORMAL_ATTRIB_IDX,
	TEXCOORD_ATTRIB_IDX
};

#define BUFFER_OFFSET(i) ((char *)NULL + (i))


@implementation OpenGLRenderer

@synthesize animationFinished=_animationFinished;

GLuint m_characterPrgName;
GLint m_characterMvpUniformIdx;
GLuint m_characterVAOName;
GLuint m_characterTexName;
demoModel* m_characterModel;
GLenum m_characterPrimType;
GLenum m_characterElementType;
GLuint m_characterNumElements;
GLfloat m_characterAngle;


GLuint m_viewWidth;
GLuint m_viewHeight;


GLboolean m_useVBOs;

- (void) resizeWithWidth:(GLuint)width AndHeight:(GLuint)height
{
	glViewport(0, 0, width, height);
	
	m_viewWidth = width;
	m_viewHeight = height;
	
}

- (void) render
{
	
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    [self drawOrSwitchScene];

}

static GLsizei GetGLTypeSize(GLenum type)
{
	switch (type) {
		case GL_BYTE:
			return sizeof(GLbyte);
		case GL_UNSIGNED_BYTE:
			return sizeof(GLubyte);
		case GL_SHORT:
			return sizeof(GLshort);
		case GL_UNSIGNED_SHORT:
			return sizeof(GLushort);
		case GL_INT:
			return sizeof(GLint);
		case GL_UNSIGNED_INT:
			return sizeof(GLuint);
		case GL_FLOAT:
			return sizeof(GLfloat);
	}
	return 0;
}

- (GLuint) buildVAO:(demoModel*)model
{	
	
	GLuint vaoName;
	
	// Create a vertex array object (VAO) to cache model parameters
	glGenVertexArrays(1, &vaoName);
	glBindVertexArray(vaoName);
	
	
	{
		
		// Enable the position attribute for this VAO
		glEnableVertexAttribArray(POS_ATTRIB_IDX);
		
		// Get the size of the position type so we can set the stride properly
		GLsizei posTypeSize = GetGLTypeSize(model->positionType);
		
		// Set up parmeters for position attribute in the VAO including,
		//  size, type, stride, and offset in the currenly bound VAO
		// This also attaches the position array in memory to the VAO
		glVertexAttribPointer(POS_ATTRIB_IDX,  // What attibute index will this array feed in the vertex shader? (also see buildProgram)
							  model->positionSize,  // How many elements are there per position?
							  model->positionType,  // What is the type of this data
							  GL_FALSE,				// Do we want to normalize this data (0-1 range for fixed-pont types)
							  model->positionSize*posTypeSize, // What is the stride (i.e. bytes between positions)?
							  model->positions);    // Where is the position data in memory?
		
		if(model->normals)
		{			
			// Enable the normal attribute for this VAO
			glEnableVertexAttribArray(NORMAL_ATTRIB_IDX);
			
			// Get the size of the normal type so we can set the stride properly
			GLsizei normalTypeSize = GetGLTypeSize(model->normalType);
			
			// Set up parmeters for position attribute in the VAO including, 
			//   size, type, stride, and offset in the currenly bound VAO
			// This also attaches the position VBO to the VAO
			glVertexAttribPointer(NORMAL_ATTRIB_IDX,	// What attibute index will this array feed in the vertex shader (see buildProgram)
								  model->normalSize,	// How many elements are there per normal?
								  model->normalType,	// What is the type of this data?
								  GL_FALSE,				// Do we want to normalize this data (0-1 range for fixed-pont types)
								  model->normalSize*normalTypeSize, // What is the stride (i.e. bytes between normals)?
								  model->normals);	    // Where is normal data in memory?
		}
		
		if(model->texcoords)
		{
			// Enable the texcoord attribute for this VAO
			glEnableVertexAttribArray(TEXCOORD_ATTRIB_IDX);
			
			// Get the size of the texcoord type so we can set the stride properly
			GLsizei texcoordTypeSize = GetGLTypeSize(model->texcoordType);
			
			// Set up parmeters for texcoord attribute in the VAO including, 
			//   size, type, stride, and offset in the currenly bound VAO
			// This also attaches the texcoord array in memory to the VAO	
			glVertexAttribPointer(TEXCOORD_ATTRIB_IDX,	// What attibute index will this array feed in the vertex shader (see buildProgram)
								  model->texcoordSize,	// How many elements are there per texture coord?
								  model->texcoordType,	// What is the type of this data in the array?
								  GL_FALSE,				// Do we want to normalize this data (0-1 range for fixed-point types)
								  model->texcoordSize*texcoordTypeSize,  // What is the stride (i.e. bytes between texcoords)?
								  model->texcoords);	// Where is the texcood data in memory?
		}
	}
	
	GetGLError();
	
	return vaoName;
}

-(void)destroyVAO:(GLuint) vaoName
{
	GLuint index;
	GLuint bufName;
	
	// Bind the VAO so we can get data from it
	glBindVertexArray(vaoName);
	
	// For every possible attribute set in the VAO
	for(index = 0; index < 16; index++)
	{
		// Get the VBO set for that attibute
		glGetVertexAttribiv(index , GL_VERTEX_ATTRIB_ARRAY_BUFFER_BINDING, (GLint*)&bufName);
		
		// If there was a VBO set...
		if(bufName)
		{
			//...delete the VBO
			glDeleteBuffers(1, &bufName);
		}
	}
	
	// Get any element array VBO set in the VAO
	glGetIntegerv(GL_ELEMENT_ARRAY_BUFFER_BINDING, (GLint*)&bufName);
	
	// If there was a element array VBO set in the VAO
	if(bufName)
	{
		//...delete the VBO
		glDeleteBuffers(1, &bufName);
	}
	
	// Finally, delete the VAO
	glDeleteVertexArrays(1, &vaoName);
	
	GetGLError();
}

-(void) deleteFBOAttachment:(GLenum) attachment
{    
    GLint param;
    GLuint objName;
	
    glGetFramebufferAttachmentParameteriv(GL_FRAMEBUFFER, attachment,
                                          GL_FRAMEBUFFER_ATTACHMENT_OBJECT_TYPE,
                                          &param);
	
    if(GL_RENDERBUFFER == param)
    {
        glGetFramebufferAttachmentParameteriv(GL_FRAMEBUFFER, attachment,
                                              GL_FRAMEBUFFER_ATTACHMENT_OBJECT_NAME,
                                              &param);
		
        objName = ((GLuint*)(&param))[0];
        glDeleteRenderbuffers(1, &objName);
    }
    else if(GL_TEXTURE == param)
    {
        
        glGetFramebufferAttachmentParameteriv(GL_FRAMEBUFFER, attachment,
                                              GL_FRAMEBUFFER_ATTACHMENT_OBJECT_NAME,
                                              &param);
		
        objName = ((GLuint*)(&param))[0];
        glDeleteTextures(1, &objName);
    }
    
}

-(void) destroyFBO:(GLuint) fboName
{ 
	if(0 == fboName)
	{
		return;
	}
    
    glBindFramebuffer(GL_FRAMEBUFFER, fboName);
	
	
    GLint maxColorAttachments = 1;
	
	
	// OpenGL ES on iOS 4 has only 1 attachment. 
	// There are many possible attachments on OpenGL 
	// on MacOSX so we query how many below
	#if !ESSENTIAL_GL_PRACTICES_IOS
	glGetIntegerv(GL_MAX_COLOR_ATTACHMENTS, &maxColorAttachments);
	#endif
	
	GLint colorAttachment;
	
	// For every color buffer attached
    for(colorAttachment = 0; colorAttachment < maxColorAttachments; colorAttachment++)
    {
		// Delete the attachment
		[self deleteFBOAttachment:(GL_COLOR_ATTACHMENT0+colorAttachment)];
	}
	
	// Delete any depth or stencil buffer attached
    [self deleteFBOAttachment:GL_DEPTH_ATTACHMENT];
	
    [self deleteFBOAttachment:GL_STENCIL_ATTACHMENT];
	
    glDeleteFramebuffers(1,&fboName);
}



-(GLuint) buildFBOWithWidth:(GLuint)width andHeight:(GLuint) height
{
	GLuint fboName;
	
	GLuint colorTexture;
	
	// Create a texture object to apply to model
	glGenTextures(1, &colorTexture);
	glBindTexture(GL_TEXTURE_2D, colorTexture);
	
	// Set up filter and wrap modes for this texture object
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR);
	
	// Allocate a texture image with which we can render to
	// Pass NULL for the data parameter since we don't need to load image data.
	//     We will be generating the image by rendering to this texture
	glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, 
				 width, height, 0,
				 GL_RGBA, GL_UNSIGNED_BYTE, NULL);
	
	GLuint depthRenderbuffer;
	glGenRenderbuffers(1, &depthRenderbuffer);
	glBindRenderbuffer(GL_RENDERBUFFER, depthRenderbuffer);
	glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, width, height);
	
	glGenFramebuffers(1, &fboName);
	glBindFramebuffer(GL_FRAMEBUFFER, fboName);	
	glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, colorTexture, 0);
	glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, depthRenderbuffer);
	
	if(glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE)
	{
		NSLog(@"failed to make complete framebuffer object %x", glCheckFramebufferStatus(GL_FRAMEBUFFER));
		[self destroyFBO:fboName];
		return 0;
	}
	
	GetGLError();
	
	return fboName;
}

- (id) initWithDefaultFBO: (GLuint) defaultFBOName:(int) width: (int) height
{
	if((self = [super init]))
	{
        [GlobalInfo initialize:width :height :2.0];
        
		NSLog(@"%s %s", glGetString(GL_RENDERER), glGetString(GL_VERSION));
		
		m_defaultFBOName = defaultFBOName;
        
        _scenes = [[SceneProvider getScenes] retain];
        _currentSceneIndex=0;
        _currentScene = [_scenes objectAtIndex:_currentSceneIndex];
		
		m_useVBOs = USE_VERTEX_BUFFER_OBJECTS;
        
        [_currentScene prepare];
		
		// Depth test will always be enabled
		glEnable(GL_DEPTH_TEST);
		
		// Always use this clear color
		glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
		
		// Draw our scene once without presenting the rendered image.
		//   This is done in order to pre-warm OpenGL
		// We don't need to present the buffer since we don't actually want the 
		//   user to see this, we're only drawing as a pre-warm stage
		[self render];
		
        // Stop animation immediately, wait for a signal to begin
        [self stop];
        
		// Check for errors to make sure all of our setup went ok
		GetGLError();
	}
	
	return self;
}

-(void) drawOrSwitchScene
{
    if(_currentSceneIndex >= [_scenes count]) {
        // Skip if all scenes have been drawn.
        return;
    } else if (!_currentScene.animationFinished) {
        [_currentScene draw];
    } else {
        _currentSceneIndex++;
        [_currentScene releaseOpenglResources];
        
        if(_currentSceneIndex < [_scenes count]) {
            _currentScene = (Drawable*) [_scenes objectAtIndex:_currentSceneIndex];
            [_currentScene prepare];
            [_currentScene draw];
        } else {
            _animationFinished = true;
        }
    }
}

-(void) stop
{
    [_currentScene pause];
}

-(void) resume
{
    [_currentScene resume];
}

- (void) dealloc
{
	
	// Cleanup all OpenGL objects and
		
	[self destroyVAO:m_characterVAOName];
	
	mdlDestroyModel(m_characterModel);
	
    [_scenes release];
    
	[super dealloc];	
}

@end
