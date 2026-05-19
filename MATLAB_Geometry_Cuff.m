import com.comsol.model.*

import com.comsol.model.util.*

model = ModelUtil.create('Vagus_Nerve');

comp1 = model.component.create('comp1', true);
geom1 = comp1.geom.create('geom1', 3);
geom1.lengthUnit('mm');


wp1 = geom1.feature.create('wp1', 'WorkPlane');

epi = wp1.geom.feature.create('epi', 'Ellipse');
epi.set('a', 1.5);
epi.set('b', 1.1);

% matrix : [X_pos, Y_pos, a_semiaxis, b_semiaxis, degree_rotation]
fascicles_data = [
    0.8,  0.2,  0.30, 0.20,  15;  
   -0.6,  0.5,  0.30, 0.20, -20;  
   -0.7, -0.4,  0.30, 0.20,   0;  
    0.5, -0.6,  0.35, 0.15,  45;  
    0.0,  0.0,  0.20, 0.20,   0   
];
for i = 1:size(fascicles_data, 1)
    fasc_name = ['fasc', num2str(i)];
    fasc = wp1.geom.feature.create(fasc_name, 'Ellipse');
    fasc.set('pos', [fascicles_data(i,1), fascicles_data(i,2)]);
    fasc.set('a', fascicles_data(i,3));
    fasc.set('b', fascicles_data(i,4));
    fasc.set('rot', fascicles_data(i,5));
end

ext = geom1.feature.create('ext1', 'Extrude');
ext.selection('input').set({'wp1'});
ext.set('distance', [10]); % nerve segment length (10mm)

saline = geom1.feature.create('saline', 'Cylinder');
saline.set('r', 35);
saline.set('h', 10);
saline.set('pos', [0, 0, 0]);

geom1.run;

% materials definition
saline_mat = model.component('comp1').material.create('saline_mat');
saline_mat.selection.all
saline_mat.propertyGroup('def').set('electricalconductivity', {'2'});

epi_mat = model.component('comp1').material.create('epi_mat');
epi_mat.propertyGroup('def').set('electricconductivity', {'0.083'});

% anisotropic material, needs a conductivity matrix (0.083 [S/m] radial,
% 0.571 [S/m] longitudinal)
endo_mat = model.component('comp1').material.create('endo_mat');
endo_mat.propertyGroup('def').set('electricconductivity', {'0.083', '0', '0', '0', '0.083', '0', '0', '0', '0.0571'})

% cuff electrode definition

sil_wp = geom1.feature.create('sil_wp', 'WorkPlane');

ext_cuff = sil_wp.geom.feature.create('ext_cuff', 'Ellipse');
ext_cuff.set('a', 1.7);
ext_cuff.set('b', 1.3);

int_cuff = sil_wp.geom.feature.create('int_cuff', 'Ellipse');
int_cuff.set('a', 1.5);
int_cuff.set('b', 1.1);

sil_dif = sil_wp.geom.feature.create('dif_sil', 'Difference');
sil_dif.selection('input').set({'ext_cuff'});
sil_dif.selection('input2').set({'int_cuff'});

sil_ext = geom1.feature.create('sil_ext', 'Extrude');
sil_ext.selection('input').set({'sil_wp'});
sil_ext.set('distance', 4); 

% movement of cuff at the centre of the nerve
sil_mov = geom1.feature.create('sil_mov', 'Move');
sil_mov.selection('input').set({'sil_ext'});
sil_mov.set('displz', 3);

% active electric contacts

cont_wp = geom1.feature.create('cont_wp', 'WorkPlane');

angles = linspace(0, 315, 8);
for i = 1:8
    theta = deg2rad(angles(i));

    px = (1.5 + 0.025) * cos(theta);
    py = (1.1 + 0.025) * sin(theta);

    c_name = ['contact', num2str(i)];
    rect = cont_wp.geom.feature.create(c_name, 'Rectangle');

    rect.set('base', 'center');
    rect.set('size', [0.05, 0.5]);
    rect.set('rot', angles(i));
    rect.set('pos', [px, py]);
end

% contacts extrusion
cont_ext = geom1.feature.create('cont_ext', 'Extrude');
cont_ext.selection('input').set({'cont_wp'});
cont_ext.set('distance', 0.5);

% contacts movement to the centre
cont_mov = geom1.feature.create('cont_mov', 'Move');
cont_mov.selection('input').set({'cont_ext'});
cont_mov.set('displz', 4.75);

geom1.run;
mphgeom(model, 'geom1', 'facealpha', 0.4);

mphsave(model, 'Project_Cuff.mph');