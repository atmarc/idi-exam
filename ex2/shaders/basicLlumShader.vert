#version 330 core

in vec3 vertex;
in vec3 normal;

in vec3 matamb;
in vec3 matdiff;
in vec3 matspec;
in float matshin;

uniform mat4 proj;
uniform mat4 view;
uniform mat4 TG;

vec3 matamb1;
vec3 matdiff1;
vec3 matspec1;
float matshin1;

uniform int isCow;

// Valors per als components que necessitem dels focus de llum
vec3 colFocus = vec3(0.8, 0.8, 0.8);
vec3 llumAmbient = vec3(0.2, 0.2, 0.2);
vec3 posFocus = vec3(0, 0, 0); 


out vec3 fcolor;

vec3 Lambert (vec3 NormSCO, vec3 L) 
{
    // S'assumeix que els vectors que es reben com a paràmetres estan normalitzats

    // Inicialitzem color a component ambient
    vec3 colRes = llumAmbient * matamb1;

    // Afegim component difusa, si n'hi ha
    if (dot (L, NormSCO) > 0)
      colRes = colRes + colFocus * matdiff1 * dot (L, NormSCO);
    return (colRes);
}

vec3 Phong (vec3 NormSCO, vec3 L, vec4 vertSCO) 
{
    // Els vectors estan normalitzats

    // Inicialitzem color a Lambert
    vec3 colRes = Lambert (NormSCO, L);

    // Calculem R i V
    if (dot(NormSCO,L) < 0)
      return colRes;  // no hi ha component especular

    vec3 R = reflect(-L, NormSCO); // equival a: normalize (2.0*dot(NormSCO,L)*NormSCO - L);
    vec3 V = normalize(-vertSCO.xyz);

    if ((dot(R, V) < 0) || (matshin1 == 0))
      return colRes;  // no hi ha component especular
    
    // Afegim la component especular
    float shine = pow(max(0.0, dot(R, V)), matshin1);
    return (colRes + matspec1 * colFocus * shine); 
}

void cridaLambert(){
    vec4 vertSCO = view * TG * vec4 (vertex, 1.0);
    mat3 normalMatrix = inverse (transpose (mat3 (view * TG)));
    vec3 normalSCO = normalize (normalMatrix * normal);
    vec4 focusSCO = view * vec4 (posFocus, 1.0);
    vec3 L = normalize (focusSCO.xyz - vertSCO.xyz);
    fcolor = Lambert (normalSCO, L);
    gl_Position = proj * vertSCO;  
}

void cridaPhong () {
    vec4 vertSCO = view * TG * vec4 (vertex, 1.0);
    mat3 normalMatrix = inverse (transpose (mat3 (view * TG)));
    vec3 normalSCO = normalize (normalMatrix * normal);
    vec4 focusSCO = vec4 (posFocus, 1.0); // multipliquem pel view si volem que el focus sigui fixe
    vec3 L = normalize (focusSCO.xyz - vertSCO.xyz);
    fcolor = Phong(normalSCO, L, vertSCO);
    gl_Position = proj * vertSCO; 
}

void main()
{	
    
    if (isCow == 1) {
        matamb1 = vec3(0.3,0.3,0.3);
        matdiff1 = vec3(0.8,0.8,0.8);
        matspec1 = vec3(0.8,0.8,0.8);
        matshin1 = 100;
    }
    else {
        matamb1 = matamb;
        matdiff1 = matdiff;
        matspec1 = matspec;
        matshin1 = 0;
    }
    cridaPhong();

}
