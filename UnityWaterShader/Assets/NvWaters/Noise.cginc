float2 Hash2D( float2 x )
{
   float2 k = float2( 0.3183099, 0.3678794 );
   x = x*k + k.yx;
   return -1.0 + 2.0*frac( 16.0 * k*frac( x.x*x.y*(x.x+x.y)) );
}

// Between -1 and 1
float Noise2D(float2 p )
{
   float2 i = floor( p );
   float2 f = frac( p );

   float2 u = f*f*(3.0-2.0*f);

   return lerp( lerp( dot( Hash2D( i + float2(0.0,0.0) ), f - float2(0.0,0.0) ),
   dot( Hash2D( i + float2(1.0,0.0) ), f - float2(1.0,0.0) ), u.x),
   lerp( dot( Hash2D( i + float2(0.0,1.0) ), f - float2(0.0,1.0) ),
   dot( Hash2D( i + float2(1.0,1.0) ), f - float2(1.0,1.0) ), u.x), u.y);
}

float FBM2D(float2 uv)
{
   float f = 0.5000*Noise2D( uv ); uv *= 2.01;
   f += 0.2500*Noise2D( uv ); uv *= 1.96;
   f += 0.1250*Noise2D( uv );
   return f;
}

float3 Hash3D( float3 p )
{
   p = float3( dot(p,float3(127.1,311.7, 74.7)),
   dot(p,float3(269.5,183.3,246.1)),
   dot(p,float3(113.5,271.9,124.6)));

   return -1.0 + 2.0*frac(sin(p)*437.5453123);
}

float Noise3D( float3 p )
{
   float3 i = floor( p );
   float3 f = frac( p );

   float3 u = f*f*(3.0-2.0*f);

   return lerp( lerp( lerp( dot( Hash3D( i + float3(0.0,0.0,0.0) ), f - float3(0.0,0.0,0.0) ),
   dot( Hash3D( i + float3(1.0,0.0,0.0) ), f - float3(1.0,0.0,0.0) ), u.x),
   lerp( dot( Hash3D( i + float3(0.0,1.0,0.0) ), f - float3(0.0,1.0,0.0) ),
   dot( Hash3D( i + float3(1.0,1.0,0.0) ), f - float3(1.0,1.0,0.0) ), u.x), u.y),
   lerp( lerp( dot( Hash3D( i + float3(0.0,0.0,1.0) ), f - float3(0.0,0.0,1.0) ),
   dot( Hash3D( i + float3(1.0,0.0,1.0) ), f - float3(1.0,0.0,1.0) ), u.x),
   lerp( dot( Hash3D( i + float3(0.0,1.0,1.0) ), f - float3(0.0,1.0,1.0) ),
   dot( Hash3D( i + float3(1.0,1.0,1.0) ), f - float3(1.0,1.0,1.0) ), u.x), u.y), u.z );
}

float FBM3D(float3 uv)
{
   float f = 0.5000*Noise3D( uv ); uv *= 2.01;
   f += 0.2500*Noise3D( uv ); uv *= 1.96;
   f += 0.1250*Noise3D( uv );
   return f;
}
