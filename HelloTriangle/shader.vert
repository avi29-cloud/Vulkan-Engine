#version 450
// 3 corners of traingle
vec2 position[3] = vec2[](
 vec2(0.0,-0.5),// top middle
 vec2(0.5,0.5),//bottom right
 vec2(-0.5,0.5) //Bottom left
);

//color for each corner( Red, green, blue)
vec3 colors[3] = vec3[](
    vec3(1.0,0.0,0.0),
    vec3(0.0,1.0,0.0),
    vec3(0.0,0.0,1.0)
);

layout(location = 0) out vec3 fragColor; //output variable that will be sent to fragment shader

void main(){
    // gl_VertexIndex is a built in variable(0, then 1, then 2)
    //gl_Position is a built in variable that vulkan uses to place the dot
   gl_Position = vec4(position[gl_VertexIndex],0.0,1.0);

   fragColor = colors[gl_VertexIndex];// pass the matching color down the assembly line
}