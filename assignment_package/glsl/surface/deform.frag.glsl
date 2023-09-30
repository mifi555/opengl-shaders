#version 330

uniform sampler2D u_Texture; // The texture to be read from by this shader
uniform int u_Time;

in vec3 fs_Pos;
in vec3 fs_Nor;

layout(location = 0) out vec3 out_Col;

void main()
{
    // TODO Homework 4
    out_Col = vec3(0, 0, 0);
}
