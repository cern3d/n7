#include <cstdlib>
#include <cmath>
#include <algorithm>
#include <iostream>

// for mac osx
#ifdef __APPLE__
#include <GLUT/glut.h>
#include <OpenGL/gl.h>
#include <OpenGL/glu.h>
#else
// only for windows
#ifdef _WIN32
#include <windows.h>
#endif
// for windows and linux
#include <GL/freeglut.h>
#include <GL/gl.h>
#include <GL/glu.h>
#endif

#define PI 3.14159265358979323846f
#define SPEED 0.1f
#define ANG_SPEED 2.0f

float camX = 0.0f, camY = 0.0f, camZ = 5.0f;
float rotX = 0.0f, rotY = 0.0f;

void display()
{
    glClear(GL_COLOR_BUFFER_BIT);
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();

    
    float radX = rotX * PI / 180.0f;
    float radY = rotY * PI / 180.0f;

    float dirX = sinf(radY) * cosf(radX);
    float dirY = sinf(radX);
    float dirZ = -cosf(radY) * cosf(radX);

    gluLookAt(camX, camY, camZ,
              camX + dirX, camY + dirY, camZ + dirZ,
              0.0, 1.0, 0.0);

    // Draw scene (same as moreteapots)
    glPushMatrix();

        glPushMatrix();
            glTranslatef(0.0f, 0.0f, -3.0f);
            glColor3f(1,0,0);
            glutWireTeapot(1);

            glTranslatef(0.0f, 2.0f, 0.0f);
            glColor3f(0,1,0);
            glRotatef(90,1,0,0);
            glutWireTeapot(1);
        glPopMatrix();

        glTranslatef(0.0f, -2.0f, -1.0f);
        glColor3f(0,0,1);
        glutWireTeapot(1);

    glPopMatrix();

    glFlush();
}

void keyboard(unsigned char key, int, int)
{
    switch(key)
    {
        case 27: exit(EXIT_SUCCESS); break; // ESC

        case 'w': camZ -= SPEED; break;
        case 's': camZ += SPEED; break;
        case 'a': camX -= SPEED; break;
        case 'd': camX += SPEED; break;

        case 'q': camY += SPEED; break;
        case 'z': camY -= SPEED; break;
    }

    glutPostRedisplay();
}

void specialKeys(int key, int, int)
{
    switch(key)
    {
        case GLUT_KEY_LEFT:  rotY -= ANG_SPEED; break;
        case GLUT_KEY_RIGHT: rotY += ANG_SPEED; break;
        case GLUT_KEY_UP:    rotX += ANG_SPEED; break;
        case GLUT_KEY_DOWN:  rotX -= ANG_SPEED; break;
    }

    glutPostRedisplay();
}

void reshape(int width, int height)
{
    if (height == 0) height = 1;

    glViewport(0, 0, width, height);

    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    gluPerspective(60.0f, (float)width / (float)height, 1.0f, 100.0f);

    glMatrixMode(GL_MODELVIEW);
}


int main(int argc, char** argv)
{
    glutInit(&argc, argv);
    glutInitWindowSize(500,500);
    glutInitDisplayMode(GLUT_RGB);

    glutCreateWindow("Navigator");

    glutDisplayFunc(display);
    glutKeyboardFunc(keyboard);
    glutSpecialFunc(specialKeys);
    glutReshapeFunc(reshape);

    glutMainLoop();
    return 0;
}