#version 330

uniform sampler2D u_Texture; // The texture to be read from by this shader

in vec3 fs_Nor;
in vec3 fs_LightVec;

layout(location = 0) out vec3 out_Col;

const float pi = 3.1415926535897932384626433832795;

void main()
{
    // TODO Homework 4
    float t = dot(fs_Nor, fs_LightVec);
    //t = clamp(t, 0.0, 1.0); // Ensure t is between 0 and 1

    //shifts the curve up/down along y-axis
    vec3 a = vec3(0.5f, 0.5f, 0.5f);
    //scales the amplitude
    vec3 b = vec3(0.5f, 0.5f, 0.5f);
    //scales the frequency
    vec3 c = vec3(1.0f, 1.0f, 1.0f);
    //shifts the entire curve along x axis
    vec3 d = vec3(0.00f, 0.33f, 0.67f);

    vec3 color = a + b * cos(2 * pi * (c * t + d));
    out_Col = color.rgb;




}
