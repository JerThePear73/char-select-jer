Lights1 jb_pet_puddles_Puddles_lights = gdSPDefLights1(
	0x7F, 0x7F, 0x7F,
	0xFF, 0xFF, 0xFF, 0x28, 0x28, 0x28);

Lights1 jb_pet_puddles_pet_basic_lights = gdSPDefLights1(
	0x72, 0x72, 0x72,
	0xE5, 0xE5, 0xE5, 0x28, 0x28, 0x28);

Gfx jb_pet_puddles_puddles_ci8_aligner[] = {gsSPEndDisplayList()};
u8 jb_pet_puddles_puddles_ci8[] = {
	#include "actors/jb_pet_puddles/puddles.ci8.inc.c"
};

Gfx jb_pet_puddles_puddles_pal_rgba16_aligner[] = {gsSPEndDisplayList()};
u8 jb_pet_puddles_puddles_pal_rgba16[] = {
	#include "actors/jb_pet_puddles/puddles.rgba16.pal"
};

Gfx jb_pet_puddles_pet_basic_ia8_aligner[] = {gsSPEndDisplayList()};
u8 jb_pet_puddles_pet_basic_ia8[] = {
	#include "actors/jb_pet_puddles/pet_basic.ia8.inc.c"
};

Vtx jb_pet_puddles_Body_mesh_layer_1_vtx_0[64] = {
	{{ {23, -1, -1}, 0, {1091, 1462}, {116, 205, 254, 255} }},
	{{ {17, 4, 20}, 0, {1265, 1959}, {71, 209, 94, 255} }},
	{{ {20, 0, 19}, 0, {1144, 1910}, {100, 214, 65, 255} }},
	{{ {21, 3, -1}, 0, {1239, 1462}, {125, 236, 0, 255} }},
	{{ {20, 0, -21}, 0, {1144, 1013}, {101, 212, 193, 255} }},
	{{ {17, 4, -22}, 0, {1265, 964}, {73, 228, 156, 255} }},
	{{ {25, 7, -1}, 0, {1386, 1462}, {127, 248, 0, 255} }},
	{{ {20, 7, -23}, 0, {1386, 915}, {95, 246, 172, 255} }},
	{{ {14, 21, -1}, 0, {1682, 1462}, {75, 103, 0, 255} }},
	{{ {11, 19, -19}, 0, {1628, 1013}, {66, 93, 200, 255} }},
	{{ {11, 19, 17}, 0, {1628, 1910}, {67, 93, 55, 255} }},
	{{ {20, 7, 21}, 0, {1386, 2008}, {100, 248, 78, 255} }},
	{{ {0, -7, 21}, 0, {-1, 1990}, {0, 149, 68, 255} }},
	{{ {20, 0, 19}, 0, {523, 1947}, {100, 214, 65, 255} }},
	{{ {17, 4, 20}, 0, {565, 1848}, {71, 209, 94, 255} }},
	{{ {0, 10, 29}, 0, {-1, 1749}, {0, 12, 126, 255} }},
	{{ {20, 7, 21}, 0, {607, 1749}, {100, 248, 78, 255} }},
	{{ {0, 21, 21}, 0, {-1, 1507}, {0, 103, 74, 255} }},
	{{ {11, 19, 17}, 0, {523, 1550}, {67, 93, 55, 255} }},
	{{ {-20, 7, 21}, 0, {607, 1749}, {156, 248, 78, 255} }},
	{{ {-17, 4, 20}, 0, {565, 1848}, {185, 209, 94, 255} }},
	{{ {-20, 0, 19}, 0, {523, 1947}, {156, 214, 65, 255} }},
	{{ {-11, 19, 17}, 0, {523, 1550}, {189, 93, 55, 255} }},
	{{ {14, 21, -1}, 0, {1547, 1724}, {75, 103, 0, 255} }},
	{{ {0, 21, 21}, 0, {2003, 2270}, {0, 103, 74, 255} }},
	{{ {11, 19, 17}, 0, {1610, 2187}, {67, 93, 55, 255} }},
	{{ {0, 27, -1}, 0, {2003, 1724}, {0, 127, 0, 255} }},
	{{ {11, 19, -19}, 0, {1610, 1041}, {66, 93, 200, 255} }},
	{{ {0, 21, -23}, 0, {2003, 958}, {0, 102, 181, 255} }},
	{{ {-11, 19, -19}, 0, {1610, 1041}, {190, 93, 200, 255} }},
	{{ {-14, 21, -1}, 0, {1547, 1724}, {181, 103, 0, 255} }},
	{{ {-11, 19, 17}, 0, {1610, 2187}, {189, 93, 55, 255} }},
	{{ {0, -5, -24}, 0, {676, 2032}, {0, 160, 173, 255} }},
	{{ {20, 0, -21}, 0, {814, 2006}, {101, 212, 193, 255} }},
	{{ {23, -1, -1}, 0, {790, 1817}, {116, 205, 254, 255} }},
	{{ {0, -7, -1}, 0, {231, 1817}, {0, 129, 253, 255} }},
	{{ {20, 0, 19}, 0, {366, 1603}, {100, 214, 65, 255} }},
	{{ {0, -7, 21}, 0, {178, 1597}, {0, 149, 68, 255} }},
	{{ {-20, 0, 19}, 0, {366, 1603}, {156, 214, 65, 255} }},
	{{ {-23, -1, -1}, 0, {790, 1817}, {140, 205, 254, 255} }},
	{{ {-20, 0, -21}, 0, {814, 2006}, {155, 212, 193, 255} }},
	{{ {-23, -1, -1}, 0, {1091, 1462}, {140, 205, 254, 255} }},
	{{ {-20, 0, 19}, 0, {1144, 1910}, {156, 214, 65, 255} }},
	{{ {-17, 4, 20}, 0, {1265, 1959}, {185, 209, 94, 255} }},
	{{ {-21, 3, -1}, 0, {1239, 1462}, {131, 236, 0, 255} }},
	{{ {-20, 7, 21}, 0, {1386, 2008}, {156, 248, 78, 255} }},
	{{ {-25, 7, -1}, 0, {1386, 1462}, {129, 248, 0, 255} }},
	{{ {-11, 19, 17}, 0, {1628, 1910}, {189, 93, 55, 255} }},
	{{ {-14, 21, -1}, 0, {1682, 1462}, {181, 103, 0, 255} }},
	{{ {-20, 7, -23}, 0, {1386, 915}, {161, 246, 172, 255} }},
	{{ {-11, 19, -19}, 0, {1628, 1013}, {190, 93, 200, 255} }},
	{{ {-17, 4, -22}, 0, {1265, 964}, {183, 228, 156, 255} }},
	{{ {-20, 0, -21}, 0, {1144, 1013}, {155, 212, 193, 255} }},
	{{ {0, 14, -28}, 0, {2007, 779}, {0, 31, 133, 255} }},
	{{ {17, 4, -22}, 0, {1585, 1000}, {73, 228, 156, 255} }},
	{{ {20, 0, -21}, 0, {1616, 1042}, {101, 212, 193, 255} }},
	{{ {20, 7, -23}, 0, {1553, 957}, {95, 246, 172, 255} }},
	{{ {11, 19, -19}, 0, {1616, 1042}, {66, 93, 200, 255} }},
	{{ {0, 21, -23}, 0, {2007, 957}, {0, 102, 181, 255} }},
	{{ {-11, 19, -19}, 0, {1616, 1042}, {190, 93, 200, 255} }},
	{{ {-20, 7, -23}, 0, {1553, 957}, {161, 246, 172, 255} }},
	{{ {-17, 4, -22}, 0, {1585, 1000}, {183, 228, 156, 255} }},
	{{ {-20, 0, -21}, 0, {1616, 1042}, {155, 212, 193, 255} }},
	{{ {0, -5, -24}, 0, {2007, 910}, {0, 160, 173, 255} }},
};

Gfx jb_pet_puddles_Body_mesh_layer_1_tri_0[] = {
	gsSPVertex(jb_pet_puddles_Body_mesh_layer_1_vtx_0 + 0, 32, 0),
	gsSP2Triangles(0, 1, 2, 0, 0, 3, 1, 0),
	gsSP2Triangles(4, 3, 0, 0, 4, 5, 3, 0),
	gsSP2Triangles(5, 6, 3, 0, 5, 7, 6, 0),
	gsSP2Triangles(7, 8, 6, 0, 7, 9, 8, 0),
	gsSP2Triangles(6, 8, 10, 0, 6, 10, 11, 0),
	gsSP2Triangles(3, 6, 11, 0, 3, 11, 1, 0),
	gsSP2Triangles(12, 13, 14, 0, 14, 15, 12, 0),
	gsSP2Triangles(14, 16, 15, 0, 16, 17, 15, 0),
	gsSP2Triangles(16, 18, 17, 0, 19, 15, 17, 0),
	gsSP2Triangles(20, 15, 19, 0, 20, 12, 15, 0),
	gsSP2Triangles(12, 20, 21, 0, 19, 17, 22, 0),
	gsSP2Triangles(23, 24, 25, 0, 23, 26, 24, 0),
	gsSP2Triangles(27, 26, 23, 0, 27, 28, 26, 0),
	gsSP2Triangles(29, 26, 28, 0, 29, 30, 26, 0),
	gsSP2Triangles(30, 24, 26, 0, 30, 31, 24, 0),
	gsSPVertex(jb_pet_puddles_Body_mesh_layer_1_vtx_0 + 32, 32, 0),
	gsSP2Triangles(0, 1, 2, 0, 0, 2, 3, 0),
	gsSP2Triangles(3, 2, 4, 0, 3, 4, 5, 0),
	gsSP2Triangles(3, 5, 6, 0, 3, 6, 7, 0),
	gsSP2Triangles(0, 3, 7, 0, 0, 7, 8, 0),
	gsSP2Triangles(9, 10, 11, 0, 9, 11, 12, 0),
	gsSP2Triangles(12, 11, 13, 0, 12, 13, 14, 0),
	gsSP2Triangles(14, 13, 15, 0, 14, 15, 16, 0),
	gsSP2Triangles(17, 14, 16, 0, 17, 16, 18, 0),
	gsSP2Triangles(19, 14, 17, 0, 19, 12, 14, 0),
	gsSP2Triangles(20, 12, 19, 0, 20, 9, 12, 0),
	gsSP2Triangles(21, 22, 23, 0, 21, 24, 22, 0),
	gsSP2Triangles(21, 25, 24, 0, 21, 26, 25, 0),
	gsSP2Triangles(21, 27, 26, 0, 21, 28, 27, 0),
	gsSP2Triangles(21, 29, 28, 0, 21, 30, 29, 0),
	gsSP2Triangles(30, 21, 31, 0, 23, 31, 21, 0),
	gsSPEndDisplayList(),
};

Vtx jb_pet_puddles_Head_mesh_layer_1_vtx_0[81] = {
	{{ {0, 22, 18}, 0, {965, 855}, {0, 19, 126, 255} }},
	{{ {14, 16, 15}, 0, {1699, 850}, {94, 26, 82, 255} }},
	{{ {15, 31, 17}, 0, {1553, 300}, {17, 236, 124, 255} }},
	{{ {16, 5, 18}, 0, {746, 1212}, {74, 240, 102, 255} }},
	{{ {19, 5, 11}, 0, {890, 1212}, {86, 171, 39, 255} }},
	{{ {23, 8, 9}, 0, {1024, 1046}, {98, 10, 176, 255} }},
	{{ {19, 5, 11}, 0, {890, 1212}, {109, 43, 49, 255} }},
	{{ {22, -2, 9}, 0, {978, 1343}, {90, 201, 186, 255} }},
	{{ {-15, 31, 17}, 0, {1553, 300}, {239, 236, 124, 255} }},
	{{ {-14, 16, 15}, 0, {1699, 850}, {162, 26, 82, 255} }},
	{{ {-16, 5, 18}, 0, {746, 1212}, {182, 240, 102, 255} }},
	{{ {-23, 8, 9}, 0, {1024, 1046}, {158, 10, 176, 255} }},
	{{ {-19, 5, 11}, 0, {890, 1212}, {170, 171, 39, 255} }},
	{{ {-19, 5, 11}, 0, {890, 1212}, {147, 43, 49, 255} }},
	{{ {-22, -2, 9}, 0, {978, 1343}, {166, 201, 186, 255} }},
	{{ {0, -2, -11}, 0, {26, 2008}, {0, 155, 179, 255} }},
	{{ {7, -4, 16}, 0, {257, 1611}, {37, 143, 45, 255} }},
	{{ {0, -4, 21}, 0, {23, 1551}, {0, 155, 77, 255} }},
	{{ {-7, -4, 16}, 0, {257, 1611}, {219, 143, 45, 255} }},
	{{ {7, -4, 16}, 0, {1015, 1287}, {37, 143, 45, 255} }},
	{{ {19, 5, 11}, 0, {1277, 1291}, {68, 231, 152, 255} }},
	{{ {22, -2, 9}, 0, {1184, 1275}, {90, 201, 186, 255} }},
	{{ {15, -2, -8}, 0, {1372, 1808}, {73, 171, 196, 255} }},
	{{ {0, -2, -11}, 0, {1411, 1877}, {0, 155, 179, 255} }},
	{{ {16, 5, -9}, 0, {1543, 1755}, {93, 1, 170, 255} }},
	{{ {15, 21, 5}, 0, {1675, 1269}, {95, 81, 231, 255} }},
	{{ {11, 18, -7}, 0, {1765, 1555}, {66, 75, 177, 255} }},
	{{ {14, 16, 15}, 0, {1427, 1088}, {94, 26, 82, 255} }},
	{{ {23, 8, 9}, 0, {1328, 1195}, {98, 10, 176, 255} }},
	{{ {16, 5, 18}, 0, {746, 1132}, {74, 240, 102, 255} }},
	{{ {7, -4, 16}, 0, {327, 1508}, {37, 143, 45, 255} }},
	{{ {22, -2, 9}, 0, {978, 1263}, {90, 201, 186, 255} }},
	{{ {0, 4, 25}, 0, {3, 1141}, {0, 245, 126, 255} }},
	{{ {7, -4, 16}, 0, {327, 1508}, {37, 143, 45, 255} }},
	{{ {16, 5, 18}, 0, {746, 1132}, {74, 240, 102, 255} }},
	{{ {14, 16, 15}, 0, {680, 533}, {94, 26, 82, 255} }},
	{{ {23, 8, 9}, 0, {1024, 966}, {98, 10, 176, 255} }},
	{{ {0, 22, 18}, 0, {3, 181}, {0, 19, 126, 255} }},
	{{ {-14, 16, 15}, 0, {680, 533}, {162, 26, 82, 255} }},
	{{ {-16, 5, 18}, 0, {746, 1132}, {182, 240, 102, 255} }},
	{{ {-23, 8, 9}, 0, {1024, 966}, {158, 10, 176, 255} }},
	{{ {-7, -4, 16}, 0, {327, 1508}, {219, 143, 45, 255} }},
	{{ {-22, -2, 9}, 0, {978, 1263}, {166, 201, 186, 255} }},
	{{ {0, -4, 21}, 0, {3, 1508}, {0, 155, 77, 255} }},
	{{ {14, 16, 15}, 0, {478, 122}, {94, 26, 82, 255} }},
	{{ {15, 21, 5}, 0, {370, 428}, {95, 81, 231, 255} }},
	{{ {15, 31, 17}, 0, {815, 360}, {23, 99, 179, 255} }},
	{{ {0, 22, 18}, 0, {750, 843}, {0, 125, 235, 255} }},
	{{ {16, 5, -9}, 0, {234, 531}, {93, 1, 170, 255} }},
	{{ {15, -2, -8}, 0, {15, 506}, {73, 171, 196, 255} }},
	{{ {0, -2, -11}, 0, {15, 9}, {0, 155, 179, 255} }},
	{{ {0, 5, -14}, 0, {234, 9}, {0, 244, 130, 255} }},
	{{ {-16, 5, -9}, 0, {234, 531}, {163, 1, 170, 255} }},
	{{ {-15, -2, -8}, 0, {15, 506}, {183, 171, 196, 255} }},
	{{ {-11, 18, -7}, 0, {601, 376}, {190, 75, 177, 255} }},
	{{ {0, 21, -9}, 0, {682, 9}, {0, 88, 164, 255} }},
	{{ {11, 18, -7}, 0, {601, 376}, {66, 75, 177, 255} }},
	{{ {0, -2, -11}, 0, {1411, 1877}, {0, 155, 179, 255} }},
	{{ {-7, -4, 16}, 0, {1015, 1287}, {219, 143, 45, 255} }},
	{{ {-15, -2, -8}, 0, {1372, 1808}, {183, 171, 196, 255} }},
	{{ {-19, 5, 11}, 0, {1277, 1291}, {188, 231, 152, 255} }},
	{{ {-22, -2, 9}, 0, {1184, 1275}, {166, 201, 186, 255} }},
	{{ {-16, 5, -9}, 0, {1543, 1755}, {163, 1, 170, 255} }},
	{{ {-15, 21, 5}, 0, {1675, 1269}, {161, 81, 231, 255} }},
	{{ {-19, 5, 11}, 0, {1277, 1291}, {188, 231, 152, 255} }},
	{{ {-14, 16, 15}, 0, {1427, 1088}, {162, 26, 82, 255} }},
	{{ {-15, 21, 5}, 0, {1675, 1269}, {161, 81, 231, 255} }},
	{{ {-23, 8, 9}, 0, {1328, 1195}, {158, 10, 176, 255} }},
	{{ {-11, 18, -7}, 0, {1765, 1555}, {190, 75, 177, 255} }},
	{{ {-16, 5, -9}, 0, {1543, 1755}, {163, 1, 170, 255} }},
	{{ {-15, 21, 5}, 0, {370, 428}, {161, 81, 231, 255} }},
	{{ {-15, 31, 17}, 0, {815, 360}, {233, 99, 179, 255} }},
	{{ {0, 22, 18}, 0, {750, 843}, {0, 125, 235, 255} }},
	{{ {-14, 16, 15}, 0, {478, 122}, {162, 26, 82, 255} }},
	{{ {11, 18, -7}, 0, {344, 128}, {66, 75, 177, 255} }},
	{{ {0, 26, 5}, 0, {6, 466}, {0, 127, 252, 255} }},
	{{ {15, 21, 5}, 0, {462, 466}, {95, 81, 231, 255} }},
	{{ {0, 21, -9}, 0, {6, 54}, {0, 88, 164, 255} }},
	{{ {-11, 18, -7}, 0, {344, 128}, {190, 75, 177, 255} }},
	{{ {-15, 21, 5}, 0, {462, 466}, {161, 81, 231, 255} }},
	{{ {0, 22, 18}, 0, {6, 878}, {0, 125, 235, 255} }},
};

Gfx jb_pet_puddles_Head_mesh_layer_1_tri_0[] = {
	gsSPVertex(jb_pet_puddles_Head_mesh_layer_1_vtx_0 + 0, 32, 0),
	gsSP2Triangles(0, 1, 2, 0, 3, 4, 5, 0),
	gsSP2Triangles(6, 3, 7, 0, 0, 8, 9, 0),
	gsSP2Triangles(10, 11, 12, 0, 13, 14, 10, 0),
	gsSP2Triangles(15, 16, 17, 0, 15, 17, 18, 0),
	gsSP2Triangles(19, 20, 21, 0, 20, 19, 22, 0),
	gsSP2Triangles(23, 22, 19, 0, 22, 24, 20, 0),
	gsSP2Triangles(25, 20, 24, 0, 25, 24, 26, 0),
	gsSP2Triangles(20, 25, 27, 0, 20, 27, 28, 0),
	gsSP1Triangle(29, 30, 31, 0),
	gsSPVertex(jb_pet_puddles_Head_mesh_layer_1_vtx_0 + 32, 32, 0),
	gsSP2Triangles(0, 1, 2, 0, 3, 0, 2, 0),
	gsSP2Triangles(3, 2, 4, 0, 3, 5, 0, 0),
	gsSP2Triangles(6, 0, 5, 0, 6, 7, 0, 0),
	gsSP2Triangles(6, 8, 7, 0, 0, 7, 9, 0),
	gsSP2Triangles(7, 10, 9, 0, 0, 9, 11, 0),
	gsSP2Triangles(0, 11, 1, 0, 12, 13, 14, 0),
	gsSP2Triangles(13, 15, 14, 0, 16, 17, 18, 0),
	gsSP2Triangles(16, 18, 19, 0, 20, 19, 18, 0),
	gsSP2Triangles(20, 18, 21, 0, 19, 20, 22, 0),
	gsSP2Triangles(19, 22, 23, 0, 19, 23, 24, 0),
	gsSP2Triangles(19, 24, 16, 0, 25, 26, 27, 0),
	gsSP2Triangles(28, 27, 26, 0, 26, 29, 28, 0),
	gsSP2Triangles(27, 28, 30, 0, 31, 30, 28, 0),
	gsSPVertex(jb_pet_puddles_Head_mesh_layer_1_vtx_0 + 64, 17, 0),
	gsSP2Triangles(0, 1, 2, 0, 0, 3, 1, 0),
	gsSP2Triangles(2, 4, 5, 0, 6, 7, 8, 0),
	gsSP2Triangles(9, 7, 6, 0, 10, 11, 12, 0),
	gsSP2Triangles(10, 13, 11, 0, 14, 11, 13, 0),
	gsSP2Triangles(14, 15, 11, 0, 16, 11, 15, 0),
	gsSP1Triangle(16, 12, 11, 0),
	gsSPEndDisplayList(),
};

Vtx jb_pet_puddles_LeftBackLeg_mesh_layer_1_vtx_0[19] = {
	{{ {-7, 4, -1}, 0, {1528, 279}, {139, 50, 0, 255} }},
	{{ {-2, 4, 7}, 0, {1528, 200}, {220, 49, 111, 255} }},
	{{ {1, 8, -1}, 0, {1528, 279}, {0, 127, 0, 255} }},
	{{ {-1, -16, 3}, 0, {2020, 218}, {217, 187, 99, 255} }},
	{{ {-4, -15, -1}, 0, {1950, 278}, {135, 216, 0, 255} }},
	{{ {-2, 4, -8}, 0, {1528, 200}, {220, 49, 145, 255} }},
	{{ {1, 8, -1}, 0, {1528, 200}, {0, 127, 0, 255} }},
	{{ {-1, -16, -5}, 0, {2020, 218}, {217, 187, 157, 255} }},
	{{ {7, 4, -5}, 0, {1528, 1}, {95, 48, 187, 255} }},
	{{ {1, 8, -1}, 0, {1528, 1}, {0, 127, 0, 255} }},
	{{ {7, 4, 4}, 0, {1528, 1}, {95, 48, 69, 255} }},
	{{ {3, -17, -3}, 0, {2020, 5}, {75, 172, 197, 255} }},
	{{ {3, -17, 2}, 0, {2020, 5}, {75, 172, 59, 255} }},
	{{ {-1, -16, 3}, 0, {1737, 641}, {217, 187, 99, 255} }},
	{{ {-4, -15, -1}, 0, {2029, 853}, {135, 216, 0, 255} }},
	{{ {-2, -17, -1}, 0, {2029, 707}, {195, 145, 0, 255} }},
	{{ {-1, -16, -5}, 0, {2321, 641}, {217, 187, 157, 255} }},
	{{ {3, -17, -3}, 0, {2209, 318}, {75, 172, 197, 255} }},
	{{ {3, -17, 2}, 0, {1848, 318}, {75, 172, 59, 255} }},
};

Gfx jb_pet_puddles_LeftBackLeg_mesh_layer_1_tri_0[] = {
	gsSPVertex(jb_pet_puddles_LeftBackLeg_mesh_layer_1_vtx_0 + 0, 19, 0),
	gsSP2Triangles(0, 1, 2, 0, 3, 1, 0, 0),
	gsSP2Triangles(3, 0, 4, 0, 4, 0, 5, 0),
	gsSP2Triangles(5, 0, 6, 0, 4, 5, 7, 0),
	gsSP2Triangles(7, 5, 8, 0, 8, 5, 9, 0),
	gsSP2Triangles(10, 8, 9, 0, 11, 8, 10, 0),
	gsSP2Triangles(11, 10, 12, 0, 12, 10, 1, 0),
	gsSP2Triangles(1, 10, 6, 0, 12, 1, 3, 0),
	gsSP2Triangles(7, 8, 11, 0, 13, 14, 15, 0),
	gsSP2Triangles(14, 16, 15, 0, 16, 17, 15, 0),
	gsSP2Triangles(17, 18, 15, 0, 18, 13, 15, 0),
	gsSPEndDisplayList(),
};

Vtx jb_pet_puddles_LeftFrontLeg_mesh_layer_1_vtx_0[19] = {
	{{ {-7, 4, -1}, 0, {1528, 279}, {139, 50, 0, 255} }},
	{{ {-1, 4, 7}, 0, {1528, 200}, {220, 49, 111, 255} }},
	{{ {1, 8, -1}, 0, {1528, 279}, {0, 127, 0, 255} }},
	{{ {-1, -16, 3}, 0, {2020, 218}, {217, 187, 99, 255} }},
	{{ {-4, -15, -1}, 0, {1950, 278}, {135, 216, 0, 255} }},
	{{ {-1, 4, -8}, 0, {1528, 200}, {220, 49, 145, 255} }},
	{{ {1, 8, -1}, 0, {1528, 200}, {0, 127, 0, 255} }},
	{{ {-1, -16, -5}, 0, {2020, 218}, {217, 187, 157, 255} }},
	{{ {7, 4, -5}, 0, {1528, 1}, {95, 48, 187, 255} }},
	{{ {1, 8, -1}, 0, {1528, 1}, {0, 127, 0, 255} }},
	{{ {7, 4, 4}, 0, {1528, 1}, {95, 48, 69, 255} }},
	{{ {4, -17, -3}, 0, {2020, 5}, {75, 172, 197, 255} }},
	{{ {4, -17, 2}, 0, {2020, 5}, {75, 172, 59, 255} }},
	{{ {-1, -16, 3}, 0, {1737, 641}, {217, 187, 99, 255} }},
	{{ {-4, -15, -1}, 0, {2029, 853}, {135, 216, 0, 255} }},
	{{ {-2, -17, -1}, 0, {2029, 707}, {195, 145, 0, 255} }},
	{{ {-1, -16, -5}, 0, {2321, 641}, {217, 187, 157, 255} }},
	{{ {4, -17, -3}, 0, {2209, 318}, {75, 172, 197, 255} }},
	{{ {4, -17, 2}, 0, {1848, 318}, {75, 172, 59, 255} }},
};

Gfx jb_pet_puddles_LeftFrontLeg_mesh_layer_1_tri_0[] = {
	gsSPVertex(jb_pet_puddles_LeftFrontLeg_mesh_layer_1_vtx_0 + 0, 19, 0),
	gsSP2Triangles(0, 1, 2, 0, 3, 1, 0, 0),
	gsSP2Triangles(3, 0, 4, 0, 4, 0, 5, 0),
	gsSP2Triangles(5, 0, 6, 0, 4, 5, 7, 0),
	gsSP2Triangles(7, 5, 8, 0, 8, 5, 9, 0),
	gsSP2Triangles(10, 8, 9, 0, 11, 8, 10, 0),
	gsSP2Triangles(11, 10, 12, 0, 12, 10, 1, 0),
	gsSP2Triangles(1, 10, 6, 0, 12, 1, 3, 0),
	gsSP2Triangles(7, 8, 11, 0, 13, 14, 15, 0),
	gsSP2Triangles(14, 16, 15, 0, 16, 17, 15, 0),
	gsSP2Triangles(17, 18, 15, 0, 18, 13, 15, 0),
	gsSPEndDisplayList(),
};

Vtx jb_pet_puddles_RightBackLeg_mesh_layer_1_vtx_0[19] = {
	{{ {7, 4, -1}, 0, {1528, 279}, {117, 50, 0, 255} }},
	{{ {-1, 8, -1}, 0, {1528, 279}, {0, 127, 0, 255} }},
	{{ {2, 4, 7}, 0, {1528, 200}, {36, 49, 111, 255} }},
	{{ {1, -16, 3}, 0, {2020, 218}, {39, 187, 99, 255} }},
	{{ {-3, -17, 2}, 0, {2020, 5}, {181, 172, 59, 255} }},
	{{ {-7, 4, 4}, 0, {1528, 1}, {161, 48, 69, 255} }},
	{{ {-1, 8, -1}, 0, {1528, 200}, {0, 127, 0, 255} }},
	{{ {-3, -17, -3}, 0, {2020, 5}, {181, 172, 197, 255} }},
	{{ {-7, 4, -5}, 0, {1528, 1}, {161, 48, 187, 255} }},
	{{ {-1, 8, -1}, 0, {1528, 1}, {0, 127, 0, 255} }},
	{{ {2, 4, -8}, 0, {1528, 200}, {36, 49, 145, 255} }},
	{{ {1, -16, -5}, 0, {2020, 218}, {39, 187, 157, 255} }},
	{{ {4, -15, -1}, 0, {1950, 278}, {121, 216, 0, 255} }},
	{{ {1, -16, 3}, 0, {1737, 641}, {39, 187, 99, 255} }},
	{{ {2, -17, -1}, 0, {2029, 707}, {61, 145, 0, 255} }},
	{{ {4, -15, -1}, 0, {2029, 853}, {121, 216, 0, 255} }},
	{{ {-3, -17, 2}, 0, {1848, 318}, {181, 172, 59, 255} }},
	{{ {-3, -17, -3}, 0, {2209, 318}, {181, 172, 197, 255} }},
	{{ {1, -16, -5}, 0, {2321, 641}, {39, 187, 157, 255} }},
};

Gfx jb_pet_puddles_RightBackLeg_mesh_layer_1_tri_0[] = {
	gsSPVertex(jb_pet_puddles_RightBackLeg_mesh_layer_1_vtx_0 + 0, 19, 0),
	gsSP2Triangles(0, 1, 2, 0, 3, 0, 2, 0),
	gsSP2Triangles(4, 3, 2, 0, 4, 2, 5, 0),
	gsSP2Triangles(2, 6, 5, 0, 7, 4, 5, 0),
	gsSP2Triangles(7, 5, 8, 0, 5, 9, 8, 0),
	gsSP2Triangles(8, 9, 10, 0, 11, 8, 10, 0),
	gsSP2Triangles(12, 11, 10, 0, 12, 10, 0, 0),
	gsSP2Triangles(10, 6, 0, 0, 3, 12, 0, 0),
	gsSP2Triangles(11, 7, 8, 0, 13, 14, 15, 0),
	gsSP2Triangles(16, 14, 13, 0, 17, 14, 16, 0),
	gsSP2Triangles(18, 14, 17, 0, 15, 14, 18, 0),
	gsSPEndDisplayList(),
};

Vtx jb_pet_puddles_RightFrontLeg_mesh_layer_1_vtx_0[19] = {
	{{ {7, 4, -1}, 0, {1528, 279}, {117, 50, 0, 255} }},
	{{ {-1, 8, -1}, 0, {1528, 279}, {0, 127, 0, 255} }},
	{{ {1, 4, 7}, 0, {1528, 200}, {36, 49, 111, 255} }},
	{{ {1, -16, 3}, 0, {2020, 218}, {39, 187, 99, 255} }},
	{{ {-4, -17, 2}, 0, {2020, 5}, {181, 172, 59, 255} }},
	{{ {-7, 4, 4}, 0, {1528, 1}, {161, 48, 69, 255} }},
	{{ {-1, 8, -1}, 0, {1528, 200}, {0, 127, 0, 255} }},
	{{ {-4, -17, -3}, 0, {2020, 5}, {181, 172, 197, 255} }},
	{{ {-7, 4, -5}, 0, {1528, 1}, {161, 48, 187, 255} }},
	{{ {-1, 8, -1}, 0, {1528, 1}, {0, 127, 0, 255} }},
	{{ {1, 4, -8}, 0, {1528, 200}, {36, 49, 145, 255} }},
	{{ {1, -16, -5}, 0, {2020, 218}, {39, 187, 157, 255} }},
	{{ {4, -15, -1}, 0, {1950, 278}, {121, 216, 0, 255} }},
	{{ {1, -16, 3}, 0, {1737, 641}, {39, 187, 99, 255} }},
	{{ {2, -17, -1}, 0, {2029, 707}, {61, 145, 0, 255} }},
	{{ {4, -15, -1}, 0, {2029, 853}, {121, 216, 0, 255} }},
	{{ {-4, -17, 2}, 0, {1848, 318}, {181, 172, 59, 255} }},
	{{ {-4, -17, -3}, 0, {2209, 318}, {181, 172, 197, 255} }},
	{{ {1, -16, -5}, 0, {2321, 641}, {39, 187, 157, 255} }},
};

Gfx jb_pet_puddles_RightFrontLeg_mesh_layer_1_tri_0[] = {
	gsSPVertex(jb_pet_puddles_RightFrontLeg_mesh_layer_1_vtx_0 + 0, 19, 0),
	gsSP2Triangles(0, 1, 2, 0, 3, 0, 2, 0),
	gsSP2Triangles(4, 3, 2, 0, 4, 2, 5, 0),
	gsSP2Triangles(2, 6, 5, 0, 7, 4, 5, 0),
	gsSP2Triangles(7, 5, 8, 0, 5, 9, 8, 0),
	gsSP2Triangles(8, 9, 10, 0, 11, 8, 10, 0),
	gsSP2Triangles(12, 11, 10, 0, 12, 10, 0, 0),
	gsSP2Triangles(10, 6, 0, 0, 3, 12, 0, 0),
	gsSP2Triangles(11, 7, 8, 0, 13, 14, 15, 0),
	gsSP2Triangles(16, 14, 13, 0, 17, 14, 16, 0),
	gsSP2Triangles(18, 14, 17, 0, 15, 14, 18, 0),
	gsSPEndDisplayList(),
};

Vtx jb_pet_puddles_Tail_mesh_layer_1_vtx_0[7] = {
	{{ {0, 9, -16}, 0, {1627, 1539}, {0, 117, 50, 255} }},
	{{ {0, 1, 8}, 0, {1568, 2380}, {0, 255, 127, 255} }},
	{{ {9, 1, -16}, 0, {1382, 1499}, {126, 242, 2, 255} }},
	{{ {-9, 1, -16}, 0, {1382, 1499}, {130, 242, 2, 255} }},
	{{ {0, 17, -33}, 0, {1575, 951}, {0, 95, 171, 255} }},
	{{ {0, -2, -28}, 0, {1196, 1181}, {0, 174, 159, 255} }},
	{{ {0, -6, -12}, 0, {1146, 1728}, {0, 130, 13, 255} }},
};

Gfx jb_pet_puddles_Tail_mesh_layer_1_tri_0[] = {
	gsSPVertex(jb_pet_puddles_Tail_mesh_layer_1_vtx_0 + 0, 7, 0),
	gsSP2Triangles(0, 1, 2, 0, 0, 3, 1, 0),
	gsSP2Triangles(0, 4, 3, 0, 0, 2, 4, 0),
	gsSP2Triangles(2, 5, 4, 0, 2, 6, 5, 0),
	gsSP2Triangles(2, 1, 6, 0, 3, 6, 1, 0),
	gsSP2Triangles(3, 5, 6, 0, 3, 4, 5, 0),
	gsSPEndDisplayList(),
};


Gfx mat_jb_pet_puddles_Puddles[] = {
	gsSPSetLights1(jb_pet_puddles_Puddles_lights),
	gsDPPipeSync(),
	gsDPSetCombineLERP(TEXEL0, 0, SHADE, 0, 0, 0, 0, ENVIRONMENT, TEXEL0, 0, SHADE, 0, 0, 0, 0, ENVIRONMENT),
	gsDPSetTextureLUT(G_TT_RGBA16),
	gsSPTexture(65535, 65535, 0, 0, 1),
	gsDPSetTextureImage(G_IM_FMT_RGBA, G_IM_SIZ_16b, 1, jb_pet_puddles_puddles_pal_rgba16),
	gsDPSetTile(0, 0, 0, 256, 5, 0, G_TX_WRAP | G_TX_NOMIRROR, 0, 0, G_TX_WRAP | G_TX_NOMIRROR, 0, 0),
	gsDPLoadTLUTCmd(5, 164),
	gsDPSetTextureImage(G_IM_FMT_CI, G_IM_SIZ_8b_LOAD_BLOCK, 1, jb_pet_puddles_puddles_ci8),
	gsDPSetTile(G_IM_FMT_CI, G_IM_SIZ_8b_LOAD_BLOCK, 0, 0, 7, 0, G_TX_WRAP | G_TX_NOMIRROR, 0, 0, G_TX_WRAP | G_TX_NOMIRROR, 0, 0),
	gsDPLoadBlock(7, 0, 0, 2047, 256),
	gsDPSetTile(G_IM_FMT_CI, G_IM_SIZ_8b, 8, 0, 0, 0, G_TX_WRAP | G_TX_MIRROR, 6, 0, G_TX_WRAP | G_TX_MIRROR, 6, 0),
	gsDPSetTileSize(0, 0, 0, 252, 252),
	gsSPEndDisplayList(),
};

Gfx mat_revert_jb_pet_puddles_Puddles[] = {
	gsDPPipeSync(),
	gsDPSetTextureLUT(G_TT_NONE),
	gsSPEndDisplayList(),
};

Gfx mat_jb_pet_puddles_pet_basic[] = {
	gsSPSetLights1(jb_pet_puddles_pet_basic_lights),
	gsDPPipeSync(),
	gsDPSetCombineLERP(TEXEL0, SHADE, TEXEL0_ALPHA, SHADE, 0, 0, 0, ENVIRONMENT, TEXEL0, SHADE, TEXEL0_ALPHA, SHADE, 0, 0, 0, ENVIRONMENT),
	gsSPTexture(65535, 65535, 0, 0, 1),
	gsDPSetTextureImage(G_IM_FMT_IA, G_IM_SIZ_8b_LOAD_BLOCK, 1, jb_pet_puddles_pet_basic_ia8),
	gsDPSetTile(G_IM_FMT_IA, G_IM_SIZ_8b_LOAD_BLOCK, 0, 0, 7, 0, G_TX_WRAP | G_TX_NOMIRROR, 0, 0, G_TX_WRAP | G_TX_NOMIRROR, 0, 0),
	gsDPLoadBlock(7, 0, 0, 127, 1024),
	gsDPSetTile(G_IM_FMT_IA, G_IM_SIZ_8b, 2, 0, 0, 0, G_TX_CLAMP | G_TX_NOMIRROR, 4, 0, G_TX_WRAP | G_TX_MIRROR, 4, 0),
	gsDPSetTileSize(0, 0, 0, 60, 60),
	gsSPEndDisplayList(),
};

Gfx jb_pet_puddles_Body_mesh_layer_1[] = {
	gsSPDisplayList(mat_jb_pet_puddles_Puddles),
	gsSPDisplayList(jb_pet_puddles_Body_mesh_layer_1_tri_0),
	gsSPDisplayList(mat_revert_jb_pet_puddles_Puddles),
	gsSPEndDisplayList(),
};

Gfx jb_pet_puddles_Body_mesh_layer_1_mat_override_pet_basic_0[] = {
	gsSPDisplayList(mat_jb_pet_puddles_Puddles),
	gsSPDisplayList(jb_pet_puddles_Body_mesh_layer_1_tri_0),
	gsSPDisplayList(mat_revert_jb_pet_puddles_Puddles),
	gsSPEndDisplayList(),
};

Gfx jb_pet_puddles_Head_mesh_layer_1[] = {
	gsSPDisplayList(mat_jb_pet_puddles_Puddles),
	gsSPDisplayList(jb_pet_puddles_Head_mesh_layer_1_tri_0),
	gsSPDisplayList(mat_revert_jb_pet_puddles_Puddles),
	gsSPEndDisplayList(),
};

Gfx jb_pet_puddles_Head_mesh_layer_1_mat_override_pet_basic_0[] = {
	gsSPDisplayList(mat_jb_pet_puddles_Puddles),
	gsSPDisplayList(jb_pet_puddles_Head_mesh_layer_1_tri_0),
	gsSPDisplayList(mat_revert_jb_pet_puddles_Puddles),
	gsSPEndDisplayList(),
};

Gfx jb_pet_puddles_LeftBackLeg_mesh_layer_1[] = {
	gsSPDisplayList(mat_jb_pet_puddles_Puddles),
	gsSPDisplayList(jb_pet_puddles_LeftBackLeg_mesh_layer_1_tri_0),
	gsSPDisplayList(mat_revert_jb_pet_puddles_Puddles),
	gsSPEndDisplayList(),
};

Gfx jb_pet_puddles_LeftBackLeg_mesh_layer_1_mat_override_pet_basic_0[] = {
	gsSPDisplayList(mat_jb_pet_puddles_Puddles),
	gsSPDisplayList(jb_pet_puddles_LeftBackLeg_mesh_layer_1_tri_0),
	gsSPDisplayList(mat_revert_jb_pet_puddles_Puddles),
	gsSPEndDisplayList(),
};

Gfx jb_pet_puddles_LeftFrontLeg_mesh_layer_1[] = {
	gsSPDisplayList(mat_jb_pet_puddles_Puddles),
	gsSPDisplayList(jb_pet_puddles_LeftFrontLeg_mesh_layer_1_tri_0),
	gsSPDisplayList(mat_revert_jb_pet_puddles_Puddles),
	gsSPEndDisplayList(),
};

Gfx jb_pet_puddles_LeftFrontLeg_mesh_layer_1_mat_override_pet_basic_0[] = {
	gsSPDisplayList(mat_jb_pet_puddles_Puddles),
	gsSPDisplayList(jb_pet_puddles_LeftFrontLeg_mesh_layer_1_tri_0),
	gsSPDisplayList(mat_revert_jb_pet_puddles_Puddles),
	gsSPEndDisplayList(),
};

Gfx jb_pet_puddles_RightBackLeg_mesh_layer_1[] = {
	gsSPDisplayList(mat_jb_pet_puddles_Puddles),
	gsSPDisplayList(jb_pet_puddles_RightBackLeg_mesh_layer_1_tri_0),
	gsSPDisplayList(mat_revert_jb_pet_puddles_Puddles),
	gsSPEndDisplayList(),
};

Gfx jb_pet_puddles_RightBackLeg_mesh_layer_1_mat_override_pet_basic_0[] = {
	gsSPDisplayList(mat_jb_pet_puddles_Puddles),
	gsSPDisplayList(jb_pet_puddles_RightBackLeg_mesh_layer_1_tri_0),
	gsSPDisplayList(mat_revert_jb_pet_puddles_Puddles),
	gsSPEndDisplayList(),
};

Gfx jb_pet_puddles_RightFrontLeg_mesh_layer_1[] = {
	gsSPDisplayList(mat_jb_pet_puddles_Puddles),
	gsSPDisplayList(jb_pet_puddles_RightFrontLeg_mesh_layer_1_tri_0),
	gsSPDisplayList(mat_revert_jb_pet_puddles_Puddles),
	gsSPEndDisplayList(),
};

Gfx jb_pet_puddles_RightFrontLeg_mesh_layer_1_mat_override_pet_basic_0[] = {
	gsSPDisplayList(mat_jb_pet_puddles_Puddles),
	gsSPDisplayList(jb_pet_puddles_RightFrontLeg_mesh_layer_1_tri_0),
	gsSPDisplayList(mat_revert_jb_pet_puddles_Puddles),
	gsSPEndDisplayList(),
};

Gfx jb_pet_puddles_Tail_mesh_layer_1[] = {
	gsSPDisplayList(mat_jb_pet_puddles_Puddles),
	gsSPDisplayList(jb_pet_puddles_Tail_mesh_layer_1_tri_0),
	gsSPDisplayList(mat_revert_jb_pet_puddles_Puddles),
	gsSPEndDisplayList(),
};

Gfx jb_pet_puddles_Tail_mesh_layer_1_mat_override_pet_basic_0[] = {
	gsSPDisplayList(mat_jb_pet_puddles_Puddles),
	gsSPDisplayList(jb_pet_puddles_Tail_mesh_layer_1_tri_0),
	gsSPDisplayList(mat_revert_jb_pet_puddles_Puddles),
	gsSPEndDisplayList(),
};

Gfx jb_pet_puddles_material_revert_render_settings[] = {
	gsDPPipeSync(),
	gsSPSetGeometryMode(G_LIGHTING),
	gsSPClearGeometryMode(G_TEXTURE_GEN),
	gsDPSetCombineLERP(0, 0, 0, SHADE, 0, 0, 0, ENVIRONMENT, 0, 0, 0, SHADE, 0, 0, 0, ENVIRONMENT),
	gsSPTexture(65535, 65535, 0, 0, 0),
	gsDPSetEnvColor(255, 255, 255, 255),
	gsDPSetAlphaCompare(G_AC_NONE),
	gsDPSetTextureImage(G_IM_FMT_RGBA, G_IM_SIZ_16b_LOAD_BLOCK, 1, 0),
	gsDPSetTile(G_IM_FMT_RGBA, G_IM_SIZ_16b_LOAD_BLOCK, 0, 0, 7, 0, G_TX_WRAP | G_TX_NOMIRROR, 0, 0, G_TX_WRAP  | G_TX_NOMIRROR, 0, 0),
	gsDPLoadBlock(7, 0, 0, 1023, 256),
	gsDPSetTile(G_IM_FMT_RGBA, G_IM_SIZ_16b, 8, 0, 0, 0, G_TX_CLAMP | G_TX_NOMIRROR, 5, 0, G_TX_CLAMP | G_TX_NOMIRROR, 5, 0),
	gsDPSetTileSize(0, 0, 0, 124, 124),
	gsDPSetTextureImage(G_IM_FMT_RGBA, G_IM_SIZ_16b_LOAD_BLOCK, 1, 0),
	gsDPSetTile(G_IM_FMT_RGBA, G_IM_SIZ_16b_LOAD_BLOCK, 0, 256, 6, 0, G_TX_WRAP | G_TX_NOMIRROR, 0, 0, G_TX_WRAP | G_TX_NOMIRROR, 0, 0),
	gsDPLoadBlock(6, 0, 0, 1023, 256),
	gsDPSetTile(G_IM_FMT_RGBA, G_IM_SIZ_16b, 8, 256, 1, 0, G_TX_CLAMP | G_TX_NOMIRROR, 5, 0, G_TX_CLAMP | G_TX_NOMIRROR, 5, 0),
	gsDPSetTileSize(1, 0, 0, 124, 124),
	gsSPEndDisplayList(),
};

