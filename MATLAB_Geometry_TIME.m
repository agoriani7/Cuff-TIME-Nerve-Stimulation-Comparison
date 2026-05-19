clear all;
clc;

import com.comsol.model.*
import com.comsol.model.util.*

model = ModelUtil.create('Vagus_Nerve_TIME_Traversing');

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

%% TIME Polyimide Substrate
time = geom1.feature.create('time', 'Block');

time_L = 4.5;       % Long enough to traverse and exit the nerve on one side
time_T = 0.02;      % 20 um thickness
time_H = 0.28;      % 280 um height

time.set('size', [time_L, time_T, time_H]);
time.set('base', 'center');

% Shifted on X to stick out of the nerve on the right side
x_center_time = 0.5;
z_center = 5.0;
time.set('pos', [x_center_time, 0, z_center]);

%% Active Sites (Platinum Contacts)
n_per_side = 5;
pt_diam = 0.06;     % 60 um
pt_r    = pt_diam / 2;
pt_thick = 0.0003;  % 300 nm

% Keep contacts inside the nerve cross-section (-1 to 1 mm)
xpos = linspace(-1.0, 1.0, n_per_side); 

% Right side contacts (+Y face)
for i = 1:n_per_side
    p = geom1.feature.create(['pt_R', num2str(i)], 'Cylinder');
    p.set('r', pt_r);
    p.set('h', pt_thick);
    p.set('axis', [0 1 0]); 
    p.set('pos', [xpos(i), time_T/2, z_center]);
end

% Left side contacts (-Y face)
for i = 1:n_per_side
    p = geom1.feature.create(['pt_L', num2str(i)], 'Cylinder');
    p.set('r', pt_r);
    p.set('h', pt_thick);
    p.set('axis', [0 -1 0]); 
    p.set('pos', [xpos(i), -time_T/2, z_center]);
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
mphsave(model,'Project_TIME.mph');