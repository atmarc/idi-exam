#version 330 core

in vec3 fcolor;
out vec4 FragColor;

uniform int X;

void main()
{
    vec4 blanc = vec4(0,0,0,0);
	vec4 negre = vec4(1,1,1,0);
	
	int altura = int(gl_FragCoord.y);
	if (X == 1) {
        if (altura%20 > 10) FragColor = blanc;
        else FragColor = negre;
	}
	else
        FragColor = vec4(fcolor,1);	
}
