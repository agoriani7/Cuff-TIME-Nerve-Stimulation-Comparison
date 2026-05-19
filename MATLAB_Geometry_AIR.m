clear all;
clc;

import com.comsol.model.*
import com.comsol.model.util.*

model = ModelUtil.create('AIR_Electrode');

comp1 = model.component.create('comp1', true);
geom1 = comp1.geom.create('geom1', 3);
geom1.lengthUnit('mm');

%% Nerve Anatomy
wp1 = geom1.feature.create('wp1', 'WorkPlane');

epi = wp1.geom.feature.create('epi', 'Ellipse');
epi.set('a', 1.5);
epi.set('b', 1.1);

% Fascicle data: [X, Y, a, b, rot]
fascicles_data = [
     0.8,  0.2,  0.30, 0.20,  15;
    -0.6,  0.5,  0.30, 0.20, -20;
    -0.7, -0.4,  0.30, 0.20,   0;
     0.5, -0.6,  0.35, 0.15,  45;
     0.0,  0.0,  0.20, 0.20,   0
];

for i = 1:size(fascicles_data,1)
    f = wp1.geom.feature.create(['fasc',num2str(i)], 'Ellipse');
    f.set('pos', [fascicles_data(i,1), fascicles_data(i,2)]);
    f.set('a', fascicles_data(i,3));
    f.set('b', fascicles_data(i,4));
    f.set('rot', fascicles_data(i,5));
end

ext = geom1.feature.create('ext1', 'Extrude');
ext.selection('input').set({'wp1'});
ext.set('distance', 10);

%% Surrounding Medium
saline = geom1.feature.create('saline', 'Cylinder');
saline.set('r', 35);
saline.set('h', 10);
saline.set('pos', [0 0 0]);

%% AIR Electrode Geometry Setup
z_center = 5.0;         
spike_L  = 0.6;         
spike_D  = 0.02;        
pitch    = 0.3;         

angles = [0, 90, 180, 270]; 

cuff_thick = 0.1;
cuff_width = 1.2;

for g = 1:length(angles)
    theta = deg2rad(angles(g));
    
    nx = cos(theta);
    ny = sin(theta);
    
    sx = 1.5 * cos(theta);
    sy = 1.1 * sin(theta);
    
    %% 1. Outer Insulating Cuff Heads
    cuff_head = geom1.feature.create(['cuff_head_', num2str(g)], 'Block');
    cuff_head.set('size', [cuff_width, cuff_thick, cuff_width]);
    cuff_head.set('base', 'center');
    cuff_head.set('pos', [sx + (cuff_thick/2)*nx, sy + (cuff_thick/2)*ny, z_center]);
    
    cuff_head.set('axistype', 'z'); 
    cuff_head.set('rot', num2str(angles(g) - 90));
    
%% 2. Radial Intrafascicular Needles
tx = -ny;  
ty =  nx;

for s = 1:2
    spike_idx = (g-1)*2 + s;
    spike = geom1.feature.create(['spike_', num2str(spike_idx)], 'Cylinder');
    spike.set('r', spike_D/2);
    spike.set('h', spike_L);
    
    spike.set('axis', [-nx, -ny, 0]);
    
    offset_sign = (s - 1.5) * 2;  % -1 o +1
    spike.set('pos', [
        sx + offset_sign * (pitch/2) * tx, ...
        sy + offset_sign * (pitch/2) * ty, ...
        z_center
    ]);
end
end

%% Build
geom1.run;

%% Materials
saline_mat = model.component('comp1').material.create('sal');
saline_mat.propertyGroup('def').set('electricconductivity', {'2'});

epi_mat = model.component('comp1').material.create('epi');
epi_mat.propertyGroup('def').set('electricconductivity', {'0.0826'});

endo_mat = model.component('comp1').material.create('endo');
endo_mat.propertyGroup('def').set('electricconductivity', ...
{'0.0826','0','0','0','0.0826','0','0','0','0.571'});

poly_mat = model.component('comp1').material.create('poly');
poly_mat.propertyGroup('def').set('electricconductivity', {'6.67e-14'});

pt_mat = model.component('comp1').material.create('pt');
pt_mat.propertyGroup('def').set('electricconductivity', {'8.9e6'});

%% Physics
ec = model.component('comp1').physics.create('ec','ConductiveMedia','geom1');

%% Mesh
mesh1 = model.component('comp1').mesh.create('mesh1');
mesh1.autoMeshSize(4); 

%% Plot and Save
figure;
mphgeom(model,'geom1','facealpha',0.4);
mphsave(model,'Project_AIR.mph');
