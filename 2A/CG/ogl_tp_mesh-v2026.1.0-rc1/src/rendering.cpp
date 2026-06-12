/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#include "rendering.hpp"
#include "geometry.hpp"

/**
 * Draw the wireframe of the model
 *
 * @param vertices The list of vertices
 * @param mesh The mesh as a list of faces, each face is a tripleIndex of vertex indices
 * @param params The rendering parameters
 */
void drawWireframe(const std::vector<point3d>& vertices,
                   const std::vector<face>& mesh,
                   const RenderingParameters& params)
{
    //**************************************************
    // we first need to disable the lighting in order to
    // draw colored segments
    //**************************************************
    glDisable(GL_LIGHTING);

    // if we are displaying the object with colored faces
    if ( params.solid )
    {
        // use black ticker lines
        glColor3f( .0f, .0f, .0f );
        glLineWidth( 2.f );
    }
    else
    {
        // otherwise use white thinner lines for wireframe only
        glColor3f( .8f, .8f, .8f );
        glLineWidth( .21f );
    }

    //**************************************************
    // for each face of the mesh...
    //**************************************************

    for (face f: mesh)
    {
        //**************************************************
        // draw the contour of the face as a  GL_LINE_LOOP
        //**************************************************
        float vertex1[3] = {vertices[f.v1].x,vertices[f.v1].y,vertices[f.v1].z};
        float vertex2[3] = {vertices[f.v2].x,vertices[f.v2].y,vertices[f.v2].z};
        float vertex3[3] = {vertices[f.v3].x,vertices[f.v3].y,vertices[f.v3].z};

        glBegin(GL_LINE_LOOP);
        glVertex3fv(vertex1);
        glVertex3fv(vertex2);
        glVertex3fv(vertex3);
        glEnd();
    }

    //**************************************************
    // re-enable the lighting
    //**************************************************
    glEnable( GL_LIGHTING );
}

/**
 * Draw the faces of the model according to the type of shading specified in the parameters
 * @param[in] vertices The list of vertices
 * @param[in] mesh The list of face, each face containing the indices of the vertices
 * @param[in] vertexNormals The list of normals associated to each vertex
 * @param[in] params If smooth is true, the model is drawn with smooth shading, otherwise with flat shading
 */
void drawFaces(const std::vector<point3d>& vertices,
                   const std::vector<face>& mesh,
                   const std::vector<vec3d>& vertexNormals,
                   const RenderingParameters& params)
{
    // shading model to use
    if(!params.smooth)
    {
        glShadeModel(GL_FLAT);

        //**************************************************
        // for each face
        //**************************************************
            glBegin(GL_TRIANGLES);
        for (face f: mesh)
        {
            //**************************************************
            // Compute the normal to the face and then draw the
            // faces as GL_TRIANGLES assigning the proper normal
            //**************************************************
            float vertex1[3] = {vertices[f.v1].x,vertices[f.v1].y,vertices[f.v1].z};
            float vertex2[3] = {vertices[f.v2].x,vertices[f.v2].y,vertices[f.v2].z};
            float vertex3[3] = {vertices[f.v3].x,vertices[f.v3].y,vertices[f.v3].z};

            vec3d fnormal = computeNormal(vertices[f.v1],vertices[f.v2],vertices[f.v3]);
            float face_array[3] ={fnormal.x,fnormal.y,fnormal.z}; 
            glNormal3fv(face_array);
            glVertex3fv(vertex1);
            glVertex3fv(vertex2);
            glVertex3fv(vertex3);
        }
            glEnd();

    }
    else
    {
        glShadeModel(GL_SMOOTH);
            glBegin(GL_TRIANGLES);
        for (face f: mesh)
        {
            //**************************************************
            // Compute the normal to the face and then draw the
            // faces as GL_TRIANGLES assigning the proper normal
            //**************************************************

            float vertex1[3] = {vertices[f.v1].x,vertices[f.v1].y,vertices[f.v1].z};
            float vertex2[3] = {vertices[f.v2].x,vertices[f.v2].y,vertices[f.v2].z};
            float vertex3[3] = {vertices[f.v3].x,vertices[f.v3].y,vertices[f.v3].z};
            float nvertex1[3] = {vertexNormals[f.v1].x,vertexNormals[f.v1].y,vertexNormals[f.v1].z};
            float nvertex2[3] = {vertexNormals[f.v2].x,vertexNormals[f.v2].y,vertexNormals[f.v2].z};
            float nvertex3[3] = {vertexNormals[f.v3].x,vertexNormals[f.v3].y,vertexNormals[f.v3].z};
            glNormal3fv(nvertex1);
            glVertex3fv(vertex1);
            glNormal3fv(nvertex2);
            glVertex3fv(vertex2);
            glNormal3fv(nvertex3);
            glVertex3fv(vertex3);
        }
            glEnd();
    }
}



/**
 * Draw the model using the vertex indices
 *
 * @param vertices The vertices
 * @param indices The list of the faces, each face containing the 3 indices of the vertices
 * @param vertexNormals The list of normals associated to each vertex
 */
void drawArrayFaces(const std::vector<point3d>& vertices,
                    const std::vector<face>& indices,
                    const std::vector<vec3d>& vertexNormals)
{

    glShadeModel(GL_SMOOTH);

    //****************************************
    // Enable vertex arrays
    //****************************************
    glEnableClientState(GL_VERTEX_ARRAY);

    //****************************************
    // Enable normal arrays
    //****************************************
    glEnableClientState(GL_NORMAL_ARRAY);


    //****************************************
    // Normal pointer to normal array
    //****************************************
    glNormalPointer(GL_FLOAT, 0, ((float*)&vertexNormals[0]));

    //****************************************
    // Vertex pointer to Vertex array
    //****************************************
    glVertexPointer(3, GL_FLOAT, 0, (float*)&vertices[0]);


    //****************************************
    // Draw the faces
    //****************************************
    glDrawElements(GL_TRIANGLES, indices.size()*3 , GL_UNSIGNED_INT, (unsigned int*)&indices[0]);


    //****************************************
    // Disable vertex arrays
    //****************************************
    glDisableClientState(GL_VERTEX_ARRAY);


    //****************************************
    // Disable normal arrays
    //****************************************
    glDisableClientState(GL_NORMAL_ARRAY);


}



//////////////////////////////////////// Nothing to do after this /////////////////////////////////

void drawNormals(const std::vector<point3d>& vertices, const std::vector<vec3d>& vertexNormals)
{
    glDisable(GL_LIGHTING);

    glColor3f(.8f, .0f, .0f);
    glLineWidth(2);

    for(std::size_t i = 0; i < vertices.size(); ++i)
    {
        glBegin(GL_LINES);

        const auto v = vertices[i];
        const auto n = vertexNormals[i];

        vec3d newP = v + 0.05f * n;
        glVertex3fv((float*)&v);

        glVertex3f(newP.x, newP.y, newP.z);

        glEnd();
    }
    glEnable(GL_LIGHTING);
}

void drawSolid(const std::vector<point3d>& vertices,
               const std::vector<face>& indices,
               const std::vector<vec3d>& vertexNormals,
               const RenderingParameters& params)
{
    if(params.useIndexRendering)
    {
        drawArrayFaces(vertices, indices, vertexNormals);
    }
    else
    {
        drawFaces(vertices, indices, vertexNormals, params);
    }
}

/**
 * Draw the model
 *
 * @param vertices list of vertices
 * @param indices list of faces
 * @param vertexNormals list of normals
 * @param params Rendering parameters
 */
void draw( const std::vector<point3d> &vertices, const std::vector<face> &indices, const std::vector<vec3d> &vertexNormals, const RenderingParameters &params )
{
    if ( params.solid )
    {
        drawSolid( vertices, indices, vertexNormals, params );
    }
    if ( params.wireframe )
    {
        ::drawWireframe( vertices, indices, params );
    }
}