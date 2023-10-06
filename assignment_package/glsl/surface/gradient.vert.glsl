#version 150

uniform mat4 u_Model;
uniform mat3 u_ModelInvTr;
uniform mat4 u_View;
uniform mat4 u_Proj;

in vec4 vs_Pos;
in vec4 vs_Nor;

out vec3 fs_Nor;

//**added
out vec3 fs_LightVec;
out vec4 fs_Pos;
out vec4 fs_CameraPos;
uniform vec3 u_CameraPos;




void main()
{
    // TODO Homework 4
    fs_Nor = normalize(u_ModelInvTr * vec3(vs_Nor));

    vec4 modelposition = u_Model * vs_Pos;

    gl_Position = u_Proj * u_View * modelposition;

    fs_CameraPos = vec4(u_CameraPos, 1);
    fs_LightVec = vec3(fs_CameraPos - modelposition);
    fs_Pos = modelposition;
}
