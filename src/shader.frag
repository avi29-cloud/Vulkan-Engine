#version 450

layout(location =0) in vec3 fragColor;
layout (location = 1) in vec2 fragTexCoord; //recieving UVs from vertex shader

// new texture sampling (binding is at 1)
layout (binding =1 ) uniform sampler2D texSampler;
layout(location =0) out vec4 outColor;// final color that gets pushed to the screen

void main(){
     
     //outColor = vec4(fragColor, 1.0); old code
     //texture() grabs the specific pixel at given UV coordinate
     outColor = texture(texSampler, fragTexCoord);

}