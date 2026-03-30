#version 450

layout(location =0) in vec3 fragColor;

layout(location =0) out vec4 outColor;// final color that gets pushed to the screen

void main(){
     
     outColor = vec4(fragColor, 1.0);

}