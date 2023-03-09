## Present working directory, this is the root working directory
$pwd
/home/muga/Desktop/NEHU_genomes/Genome_10_DBT_lignocellulose_project

### The statistics of the Bionivid provided assembly
$seqkit stats scaffolds/GB_3_scaffolds.fasta

file                  format  type  num_seqs    sum_len  min_len    avg_len    max_len
GB_3_scaffolds.fasta  FASTA   DNA         26  6,373,175      210  245,122.1  1,746,241

## The contigs provided by Bionivid are scaffolded using medusa, meaning presence of stretches of N between ordered contigs

for i in $(ls scaffolds/*.fasta); do echo $i; seqtk comp $i | awk '{x+=$9}END{print x}'; done 

scaffolds/GB3_scaffolds.fasta
900
scaffolds/LP10_scaffolds.fasta
2400
scaffolds/LP47_scaffolds.fasta
6100
scaffolds/MB417_scaffolds.fasta
5000
scaffolds/MB420_scaffolds.fasta
500
scaffolds/MM43_scaffolds.fasta
2100
scaffolds/MS29_scaffolds.fasta
1500
scaffolds/SB13_scaffolds.fasta
300
scaffolds/SB19_scaffolds.fasta
100
scaffolds/SB6_scaffolds.fasta
600

## Check the classification of the contigs provided by bionivid using kraken2 database, generate report and output, keep only classified contigs

$kraken2 --db databases --threads 20 --classified-out kraken2/GB3_classified.fasta --unclassified-out kraken2/GB3_unclassified.fasta --report kraken2/GB3_k2_report.txt --report-minimizer-data --output kraken2/GB3_k2_output.txt scaffolds/GB3_scaffolds.fasta

### Lets take a look at the kraken2 report
$cat kraken2/GB3_k2_report.txt


  3.85  1       1       0       0       U       0       unclassified
 96.15  25      0       1292154 1262038 R       1       root
 96.15  25      0       1292050 1262038 R1      131567    cellular organisms
 96.15  25      0       1291687 1261525 D       2           Bacteria
 96.15  25      0       1284451 1257718 D1      1783272       Terrabacteria group
 96.15  25      0       1283298 1257590 P       1239            Firmicutes
 96.15  25      0       1281921 1255488 C       91061             Bacilli
 96.15  25      0       1280895 1254285 O       1385                Bacillales
 96.15  25      0       1270521 1248048 F       186822                Paenibacillaceae
 96.15  25      0       1261393 1235042 G       55080                   Brevibacillus
 96.15  25      2       465687  465687  S       1393                      Brevibacillus brevis
 84.62  22      22      84027   83219   S1      1200792                     Brevibacillus brevis X23
  3.85  1       1       5824    5824    S1      358681                      Brevibacillus brevis NBRC 100599


## Lets see the contigs that are classified and unclassified

$seqkit fx2tab --length --name --header-line kraken2/GB3_classified.fasta ## look at the taxid of all the classified contigs

#name   length
GB_3_Scaffold_1 kraken:taxid|1200792    393755
GB_3_Scaffold_2 kraken:taxid|1200792    1007516
GB_3_Scaffold_3 kraken:taxid|1200792    131967
GB_3_Scaffold_4 kraken:taxid|1200792    42857
GB_3_Scaffold_5 kraken:taxid|1200792    163819
GB_3_Scaffold_6 kraken:taxid|1200792    1746241
GB_3_Scaffold_7 kraken:taxid|1200792    703299
GB_3_Scaffold_8 kraken:taxid|1200792    539480
GB_3_Scaffold_9 kraken:taxid|1200792    527986
GB_3_Scaffold_10 kraken:taxid|1200792   404625
GB_3_Scaffold_11 kraken:taxid|1200792   365260
GB_3_Scaffold_12 kraken:taxid|1200792   185571
GB_3_Scaffold_13 kraken:taxid|1200792   72001
GB_3_Scaffold_14 kraken:taxid|1200792   65321
GB_3_Scaffold_15 kraken:taxid|1200792   9819
GB_3_Scaffold_16 kraken:taxid|1200792   8354
GB_3_Scaffold_17 kraken:taxid|1200792   1435
GB_3_Scaffold_18 kraken:taxid|1200792   1260
GB_3_Scaffold_19 kraken:taxid|358681    483
GB_3_Scaffold_21 kraken:taxid|1393      376
GB_3_Scaffold_22 kraken:taxid|1200792   313
GB_3_Scaffold_23 kraken:taxid|1200792   290
GB_3_Scaffold_24 kraken:taxid|1393      258
GB_3_Scaffold_25 kraken:taxid|1200792   238
GB_3_Scaffold_26 kraken:taxid|1200792   210

$seqkit fx2tab --length --name --header-line kraken2/GB3_unclassified.fasta

#name   length
GB_3_Scaffold_20        441

### Let us redo the assembly with the fastq files provided by the seqencing company
## Before that we will correct the reads for errors with the Bayerhammer tool provided in spades 
$spades.py -1 fastq/GB3_R1.fastq.gz -2 fastq/GB3_R2.fastq.gz -o spades_error_corrected_fastq -t 20 --only-error-correction

## Lets start assembly with spades with the error corrected reads

$spades.py -1 spades_error_corrected_fastq/corrected/GB3_R1.fastq.00.0_0.cor.fastq.gz -2 spades_error_corrected_fastq/corrected/GB3_R2.fastq.00.0_0.cor.fastq.gz -s spades_error_corrected_fastq/corrected/GB3_R_unpaired.00.0_0.cor.fastq.gz -t 20 --only-assembler --cov-cutoff auto -k auto -o spades/GB3_assembly

### Statistics of our assembled genome

$seqkit stats spades/GB3_assembly/scaffolds.fasta

file                                                                 format  type  num_seqs    sum_len  min_len  avg_len    max_len
spades_error_corrected_fastq/corrected/GB3_assembly/scaffolds.fasta  FASTA   DNA        439  6,404,149       78   14,588  1,096,957

### Inspect the spades output for your genome for the number of the contigs 

$seqkit fx2tab --length --name --header-line spades/GB3_assembly/scaffolds.fasta  ## we got 439 contigs

#name   length
NODE_1_length_1096957_cov_232.845078    1096957
NODE_2_length_954570_cov_189.129124     954570
NODE_3_length_870544_cov_266.585575     870544
NODE_4_length_682884_cov_179.590556     682884
NODE_5_length_527980_cov_227.488434     527980
NODE_6_length_404597_cov_274.760373     404597
NODE_7_length_363491_cov_203.441326     363491
NODE_8_length_354766_cov_338.799374     354766
NODE_9_length_242886_cov_301.761220     242886
NODE_10_length_185543_cov_311.624691    185543
NODE_11_length_155943_cov_296.151810    155943
NODE_12_length_130701_cov_350.935540    130701
NODE_13_length_108289_cov_194.144161    108289
NODE_14_length_72173_cov_318.018836     72173
NODE_15_length_67062_cov_316.686378     67062
NODE_16_length_65293_cov_335.010366     65293
NODE_17_length_41984_cov_336.515212     41984
NODE_18_length_9263_cov_322.075550      9263
NODE_19_length_8326_cov_370.677779      8326
NODE_20_length_6077_cov_322.093167      6077
NODE_21_length_4190_cov_310.371748      4190
NODE_22_length_1435_cov_891.186303      1435
NODE_23_length_1377_cov_4238.552308     1377
NODE_24_length_1270_cov_4086.636211     1270
NODE_25_length_972_cov_361.831285       972
NODE_26_length_725_cov_3975.049383      725
NODE_27_length_624_cov_3386.634369      624
NODE_28_length_461_cov_1625.309896      461
NODE_29_length_412_cov_620.104478       412
NODE_30_length_380_cov_363.590759       380
NODE_31_length_338_cov_313.321839       338
NODE_32_length_320_cov_348.609053       320
NODE_33_length_306_cov_4561.847162      306
NODE_34_length_299_cov_307.887387       299
NODE_35_length_279_cov_3634.668317      279
NODE_36_length_277_cov_240.315000       277
NODE_37_length_263_cov_792.983871       263
NODE_38_length_262_cov_1989.664865      262
NODE_39_length_261_cov_295.021739       261
NODE_40_length_252_cov_226.120000       252
NODE_41_length_247_cov_492.047059       247
NODE_42_length_243_cov_294.837349       243
NODE_43_length_235_cov_329.386076       235
NODE_44_length_233_cov_1311.410256      233
NODE_45_length_231_cov_264.311688       231
NODE_46_length_230_cov_341.405229       230
NODE_47_length_230_cov_280.986928       230
NODE_48_length_227_cov_311.720000       227
NODE_49_length_224_cov_589.959184       224
NODE_50_length_218_cov_783.773050       218
NODE_51_length_218_cov_84.687943        218
NODE_52_length_216_cov_429.395683       216
NODE_53_length_215_cov_76.210145        215
NODE_54_length_214_cov_166.043796       214
NODE_55_length_210_cov_213.473684       210
NODE_56_length_208_cov_1353.068702      208
NODE_57_length_198_cov_368.107438       198
NODE_58_length_194_cov_3590.111111      194
NODE_59_length_187_cov_605.509091       187
NODE_60_length_187_cov_281.527273       187
NODE_61_length_182_cov_340.619048       182
NODE_62_length_179_cov_431.421569       179
NODE_63_length_175_cov_355.510204       175
NODE_64_length_173_cov_256.166667       173
NODE_65_length_172_cov_365.936842       172
NODE_66_length_171_cov_248.776596       171
NODE_67_length_170_cov_307.408602       170
NODE_68_length_169_cov_195.728261       169
NODE_69_length_168_cov_1135.670330      168
NODE_70_length_168_cov_320.758242       168
NODE_71_length_167_cov_635.511111       167
NODE_72_length_166_cov_190.000000       166
NODE_73_length_165_cov_319.500000       165
NODE_74_length_164_cov_843.977011       164
NODE_75_length_163_cov_2108.069767      163
NODE_76_length_163_cov_395.848837       163
NODE_77_length_162_cov_347.988235       162
NODE_78_length_161_cov_293.011905       161
NODE_79_length_161_cov_255.952381       161
NODE_80_length_160_cov_298.855422       160
NODE_81_length_158_cov_190.604938       158
NODE_82_length_157_cov_357.187500       157
NODE_83_length_157_cov_210.900000       157
NODE_84_length_156_cov_265.632911       156
NODE_85_length_155_cov_2533.320513      155
NODE_86_length_155_cov_1311.666667      155
NODE_87_length_155_cov_601.179487       155
NODE_88_length_155_cov_348.205128       155
NODE_89_length_155_cov_270.205128       155
NODE_90_length_155_cov_242.474359       155
NODE_91_length_154_cov_262.181818       154
NODE_92_length_154_cov_84.623377        154
NODE_93_length_152_cov_596.693333       152
NODE_94_length_152_cov_284.493333       152
NODE_95_length_152_cov_244.133333       152
NODE_96_length_152_cov_223.880000       152
NODE_97_length_152_cov_111.666667       152
NODE_98_length_151_cov_638.716216       151
NODE_99_length_151_cov_277.878378       151
NODE_100_length_151_cov_199.527027      151
NODE_101_length_151_cov_173.783784      151
NODE_102_length_150_cov_296.616438      150
NODE_103_length_149_cov_108.097222      149
NODE_104_length_149_cov_103.013889      149
NODE_105_length_149_cov_83.666667       149
NODE_106_length_148_cov_247.126761      148
NODE_107_length_148_cov_238.873239      148
NODE_108_length_148_cov_132.704225      148
NODE_109_length_148_cov_63.183099       148
NODE_110_length_147_cov_1982.114286     147
NODE_111_length_147_cov_356.285714      147
NODE_112_length_147_cov_152.242857      147
NODE_113_length_145_cov_536.691176      145
NODE_114_length_144_cov_1479.641791     144
NODE_115_length_144_cov_606.656716      144
NODE_116_length_144_cov_78.014925       144
NODE_117_length_144_cov_63.164179       144
NODE_118_length_143_cov_340.212121      143
NODE_119_length_142_cov_175.030769      142
NODE_120_length_142_cov_152.584615      142
NODE_121_length_142_cov_88.692308       142
NODE_122_length_141_cov_11386.218750    141
NODE_123_length_141_cov_1885.312500     141
NODE_124_length_141_cov_1056.218750     141
NODE_125_length_141_cov_701.750000      141
NODE_126_length_141_cov_91.234375       141
NODE_127_length_138_cov_1448.868852     138
NODE_128_length_136_cov_584.508475      136
NODE_129_length_136_cov_146.830508      136
NODE_130_length_134_cov_1330.561404     134
NODE_131_length_134_cov_167.649123      134
NODE_132_length_133_cov_2896.464286     133
NODE_133_length_130_cov_363.037736      130
NODE_134_length_130_cov_168.566038      130
NODE_135_length_128_cov_824.274510      128
NODE_136_length_124_cov_271.468085      124
NODE_137_length_123_cov_1811.282609     123
NODE_138_length_123_cov_591.978261      123
NODE_139_length_123_cov_536.130435      123
NODE_140_length_108_cov_1164.290323     108
NODE_141_length_108_cov_1127.838710     108
NODE_142_length_108_cov_173.451613      108
NODE_143_length_106_cov_2144.724138     106
NODE_144_length_104_cov_1580.370370     104
NODE_145_length_103_cov_463.461538      103
NODE_146_length_102_cov_1007.400000     102
NODE_147_length_98_cov_2584.238095      98
NODE_148_length_98_cov_746.904762       98
NODE_149_length_96_cov_912.157895       96
NODE_150_length_91_cov_1142.642857      91
NODE_151_length_89_cov_193.833333       89
NODE_152_length_86_cov_955.000000       86
NODE_153_length_86_cov_71.666667        86
NODE_154_length_85_cov_854.750000       85
NODE_155_length_84_cov_372.000000       84
NODE_156_length_84_cov_241.000000       84
NODE_157_length_84_cov_236.857143       84
NODE_158_length_84_cov_151.000000       84
NODE_159_length_84_cov_68.000000        84
NODE_160_length_83_cov_346.166667       83
NODE_161_length_83_cov_184.833333       83
NODE_162_length_83_cov_119.166667       83
NODE_163_length_83_cov_108.166667       83
NODE_164_length_83_cov_38.666667        83
NODE_165_length_82_cov_564.800000       82
NODE_166_length_82_cov_159.400000       82
NODE_167_length_82_cov_45.400000        82
NODE_168_length_81_cov_8093.250000      81
NODE_169_length_81_cov_684.250000       81
NODE_170_length_81_cov_296.500000       81
NODE_171_length_81_cov_204.500000       81
NODE_172_length_81_cov_101.250000       81
NODE_173_length_81_cov_93.500000        81
NODE_174_length_81_cov_93.250000        81
NODE_175_length_81_cov_86.250000        81
NODE_176_length_81_cov_60.750000        81
NODE_177_length_80_cov_1393.333333      80
NODE_178_length_80_cov_1072.333333      80
NODE_179_length_80_cov_817.666667       80
NODE_180_length_80_cov_661.333333       80
NODE_181_length_80_cov_619.666667       80
NODE_182_length_80_cov_430.333333       80
NODE_183_length_80_cov_212.666667       80
NODE_184_length_80_cov_168.333333       80
NODE_185_length_80_cov_157.333333       80
NODE_186_length_80_cov_142.666667       80
NODE_187_length_80_cov_123.666667       80
NODE_188_length_80_cov_76.333333        80
NODE_189_length_80_cov_42.000000        80
NODE_190_length_79_cov_1055.000000      79
NODE_191_length_79_cov_952.000000       79
NODE_192_length_79_cov_904.000000       79
NODE_193_length_79_cov_816.500000       79
NODE_194_length_79_cov_512.500000       79
NODE_195_length_79_cov_508.000000       79
NODE_196_length_79_cov_476.500000       79
NODE_197_length_79_cov_161.000000       79
NODE_198_length_79_cov_153.000000       79
NODE_199_length_79_cov_138.000000       79
NODE_200_length_79_cov_123.500000       79
NODE_201_length_79_cov_119.000000       79
NODE_202_length_79_cov_117.000000       79
NODE_203_length_79_cov_116.500000       79
NODE_204_length_79_cov_116.500000       79
NODE_205_length_79_cov_110.000000       79
NODE_206_length_79_cov_107.000000       79
NODE_207_length_79_cov_104.500000       79
NODE_208_length_79_cov_103.000000       79
NODE_209_length_79_cov_96.500000        79
NODE_210_length_79_cov_91.000000        79
NODE_211_length_79_cov_91.000000        79
NODE_212_length_79_cov_91.000000        79
NODE_213_length_79_cov_88.500000        79
NODE_214_length_79_cov_84.500000        79
NODE_215_length_79_cov_82.500000        79
NODE_216_length_79_cov_72.500000        79
NODE_217_length_79_cov_71.500000        79
NODE_218_length_78_cov_161162.000000    78
NODE_219_length_78_cov_14728.000000     78
NODE_220_length_78_cov_13255.000000     78
NODE_221_length_78_cov_12048.000000     78
NODE_222_length_78_cov_9163.000000      78
NODE_223_length_78_cov_5814.000000      78
NODE_224_length_78_cov_3898.000000      78
NODE_225_length_78_cov_3839.000000      78
NODE_226_length_78_cov_3770.000000      78
NODE_227_length_78_cov_3752.000000      78
NODE_228_length_78_cov_3651.000000      78
NODE_229_length_78_cov_3398.000000      78
NODE_230_length_78_cov_3116.000000      78
NODE_231_length_78_cov_3072.000000      78
NODE_232_length_78_cov_3033.000000      78
NODE_233_length_78_cov_2952.000000      78
NODE_234_length_78_cov_2937.000000      78
NODE_235_length_78_cov_2878.000000      78
NODE_236_length_78_cov_2832.000000      78
NODE_237_length_78_cov_2784.000000      78
NODE_238_length_78_cov_2746.000000      78
NODE_239_length_78_cov_2589.000000      78
NODE_240_length_78_cov_2583.000000      78
NODE_241_length_78_cov_2543.000000      78
NODE_242_length_78_cov_2412.000000      78
NODE_243_length_78_cov_2396.000000      78
NODE_244_length_78_cov_2315.000000      78
NODE_245_length_78_cov_2310.000000      78
NODE_246_length_78_cov_2273.000000      78
NODE_247_length_78_cov_2258.000000      78
NODE_248_length_78_cov_2217.000000      78
NODE_249_length_78_cov_2199.000000      78
NODE_250_length_78_cov_2173.000000      78
NODE_251_length_78_cov_2163.000000      78
NODE_252_length_78_cov_2157.000000      78
NODE_253_length_78_cov_2140.000000      78
NODE_254_length_78_cov_2125.000000      78
NODE_255_length_78_cov_2124.000000      78
NODE_256_length_78_cov_2095.000000      78
NODE_257_length_78_cov_2075.000000      78
NODE_258_length_78_cov_2072.000000      78
NODE_259_length_78_cov_2071.000000      78
NODE_260_length_78_cov_2069.000000      78
NODE_261_length_78_cov_2013.000000      78
NODE_262_length_78_cov_1954.000000      78
NODE_263_length_78_cov_1934.000000      78
NODE_264_length_78_cov_1924.000000      78
NODE_265_length_78_cov_1915.000000      78
NODE_266_length_78_cov_1870.000000      78
NODE_267_length_78_cov_1865.000000      78
NODE_268_length_78_cov_1860.000000      78
NODE_269_length_78_cov_1858.000000      78
NODE_270_length_78_cov_1833.000000      78
NODE_271_length_78_cov_1819.000000      78
NODE_272_length_78_cov_1811.000000      78
NODE_273_length_78_cov_1731.000000      78
NODE_274_length_78_cov_1728.000000      78
NODE_275_length_78_cov_1713.000000      78
NODE_276_length_78_cov_1711.000000      78
NODE_277_length_78_cov_1681.000000      78
NODE_278_length_78_cov_1657.000000      78
NODE_279_length_78_cov_1640.000000      78
NODE_280_length_78_cov_1628.000000      78
NODE_281_length_78_cov_1578.000000      78
NODE_282_length_78_cov_1557.000000      78
NODE_283_length_78_cov_1548.000000      78
NODE_284_length_78_cov_1546.000000      78
NODE_285_length_78_cov_1497.000000      78
NODE_286_length_78_cov_1490.000000      78
NODE_287_length_78_cov_1481.000000      78
NODE_288_length_78_cov_1472.000000      78
NODE_289_length_78_cov_1469.000000      78
NODE_290_length_78_cov_1427.000000      78
NODE_291_length_78_cov_1415.000000      78
NODE_292_length_78_cov_1392.000000      78
NODE_293_length_78_cov_1385.000000      78
NODE_294_length_78_cov_1370.000000      78
NODE_295_length_78_cov_1349.000000      78
NODE_296_length_78_cov_1337.000000      78
NODE_297_length_78_cov_1334.000000      78
NODE_298_length_78_cov_1328.000000      78
NODE_299_length_78_cov_1314.000000      78
NODE_300_length_78_cov_1304.000000      78
NODE_301_length_78_cov_1291.000000      78
NODE_302_length_78_cov_1248.000000      78
NODE_303_length_78_cov_1185.000000      78
NODE_304_length_78_cov_1185.000000      78
NODE_305_length_78_cov_1179.000000      78
NODE_306_length_78_cov_1154.000000      78
NODE_307_length_78_cov_1136.000000      78
NODE_308_length_78_cov_1125.000000      78
NODE_309_length_78_cov_1114.000000      78
NODE_310_length_78_cov_1113.000000      78
NODE_311_length_78_cov_997.000000       78
NODE_312_length_78_cov_986.000000       78
NODE_313_length_78_cov_984.000000       78
NODE_314_length_78_cov_976.000000       78
NODE_315_length_78_cov_964.000000       78
NODE_316_length_78_cov_951.000000       78
NODE_317_length_78_cov_922.000000       78
NODE_318_length_78_cov_866.000000       78
NODE_319_length_78_cov_850.000000       78
NODE_320_length_78_cov_839.000000       78
NODE_321_length_78_cov_833.000000       78
NODE_322_length_78_cov_818.000000       78
NODE_323_length_78_cov_798.000000       78
NODE_324_length_78_cov_795.000000       78
NODE_325_length_78_cov_781.000000       78
NODE_326_length_78_cov_771.000000       78
NODE_327_length_78_cov_757.000000       78
NODE_328_length_78_cov_751.000000       78
NODE_329_length_78_cov_745.000000       78
NODE_330_length_78_cov_743.000000       78
NODE_331_length_78_cov_738.000000       78
NODE_332_length_78_cov_708.000000       78
NODE_333_length_78_cov_706.000000       78
NODE_334_length_78_cov_648.000000       78
NODE_335_length_78_cov_638.000000       78
NODE_336_length_78_cov_630.000000       78
NODE_337_length_78_cov_629.000000       78
NODE_338_length_78_cov_617.000000       78
NODE_339_length_78_cov_614.000000       78
NODE_340_length_78_cov_608.000000       78
NODE_341_length_78_cov_591.000000       78
NODE_342_length_78_cov_577.000000       78
NODE_343_length_78_cov_574.000000       78
NODE_344_length_78_cov_561.000000       78
NODE_345_length_78_cov_548.000000       78
NODE_346_length_78_cov_543.000000       78
NODE_347_length_78_cov_507.000000       78
NODE_348_length_78_cov_498.000000       78
NODE_349_length_78_cov_482.000000       78
NODE_350_length_78_cov_481.000000       78
NODE_351_length_78_cov_473.000000       78
NODE_352_length_78_cov_471.000000       78
NODE_353_length_78_cov_450.000000       78
NODE_354_length_78_cov_398.000000       78
NODE_355_length_78_cov_380.000000       78
NODE_356_length_78_cov_379.000000       78
NODE_357_length_78_cov_362.000000       78
NODE_358_length_78_cov_336.000000       78
NODE_359_length_78_cov_326.000000       78
NODE_360_length_78_cov_315.000000       78
NODE_361_length_78_cov_314.000000       78
NODE_362_length_78_cov_312.000000       78
NODE_363_length_78_cov_307.000000       78
NODE_364_length_78_cov_285.000000       78
NODE_365_length_78_cov_276.000000       78
NODE_366_length_78_cov_269.000000       78
NODE_367_length_78_cov_265.000000       78
NODE_368_length_78_cov_250.000000       78
NODE_369_length_78_cov_245.000000       78
NODE_370_length_78_cov_242.000000       78
NODE_371_length_78_cov_241.000000       78
NODE_372_length_78_cov_228.000000       78
NODE_373_length_78_cov_228.000000       78
NODE_374_length_78_cov_225.000000       78
NODE_375_length_78_cov_222.000000       78
NODE_376_length_78_cov_214.000000       78
NODE_377_length_78_cov_204.000000       78
NODE_378_length_78_cov_204.000000       78
NODE_379_length_78_cov_191.000000       78
NODE_380_length_78_cov_184.000000       78
NODE_381_length_78_cov_183.000000       78
NODE_382_length_78_cov_182.000000       78
NODE_383_length_78_cov_172.000000       78
NODE_384_length_78_cov_168.000000       78
NODE_385_length_78_cov_158.000000       78
NODE_386_length_78_cov_156.000000       78
NODE_387_length_78_cov_155.000000       78
NODE_388_length_78_cov_154.000000       78
NODE_389_length_78_cov_147.000000       78
NODE_390_length_78_cov_145.000000       78
NODE_391_length_78_cov_140.000000       78
NODE_392_length_78_cov_135.000000       78
NODE_393_length_78_cov_135.000000       78
NODE_394_length_78_cov_135.000000       78
NODE_395_length_78_cov_134.000000       78
NODE_396_length_78_cov_126.000000       78
NODE_397_length_78_cov_126.000000       78
NODE_398_length_78_cov_125.000000       78
NODE_399_length_78_cov_123.000000       78
NODE_400_length_78_cov_123.000000       78
NODE_401_length_78_cov_122.000000       78
NODE_402_length_78_cov_121.000000       78
NODE_403_length_78_cov_116.000000       78
NODE_404_length_78_cov_115.000000       78
NODE_405_length_78_cov_115.000000       78
NODE_406_length_78_cov_114.000000       78
NODE_407_length_78_cov_111.000000       78
NODE_408_length_78_cov_106.000000       78
NODE_409_length_78_cov_106.000000       78
NODE_410_length_78_cov_102.000000       78
NODE_411_length_78_cov_101.000000       78
NODE_412_length_78_cov_100.000000       78
NODE_413_length_78_cov_98.000000        78
NODE_414_length_78_cov_98.000000        78
NODE_415_length_78_cov_98.000000        78
NODE_416_length_78_cov_92.000000        78
NODE_417_length_78_cov_91.000000        78
NODE_418_length_78_cov_90.000000        78
NODE_419_length_78_cov_86.000000        78
NODE_420_length_78_cov_85.000000        78
NODE_421_length_78_cov_82.000000        78
NODE_422_length_78_cov_81.000000        78
NODE_423_length_78_cov_79.000000        78
NODE_424_length_78_cov_78.000000        78
NODE_425_length_78_cov_77.000000        78
NODE_426_length_78_cov_77.000000        78
NODE_427_length_78_cov_75.000000        78
NODE_428_length_78_cov_75.000000        78
NODE_429_length_78_cov_74.000000        78
NODE_430_length_78_cov_74.000000        78
NODE_431_length_78_cov_74.000000        78
NODE_432_length_78_cov_73.000000        78
NODE_433_length_78_cov_73.000000        78
NODE_434_length_78_cov_72.000000        78
NODE_435_length_78_cov_72.000000        78
NODE_436_length_78_cov_72.000000        78
NODE_437_length_78_cov_72.000000        78
NODE_438_length_78_cov_70.000000        78
NODE_439_length_78_cov_39.000000        78
## Trim your contigs file to keep only fragment with minimum length of 200 and above

$seqkit seq -m 200 -g spades/GB3_assembly/scaffolds.fasta > spades/GB3_assembly/scaffolds_min200.fasta ## after trimming only 56 contigs remained

## Statistics after length trimming

$seqkit stats spades/GB3_assembly/scaffolds_min200.fasta

file                                                                        format  type  num_seqs    sum_len  min_len    avg_len    max_len
spades/GB3_assembly/scaffolds_min200.fasta  FASTA   DNA         56  6,367,631      208  113,707.7  1,096,957

## Inspect the scaffolds file for the contig length and name

seqkit fx2tab --length --name --header-line spades/GB3_assembly/scaffolds_min200.fasta

#name   length
NODE_1_length_1096957_cov_232.845078    1096957
NODE_2_length_954570_cov_189.129124     954570
NODE_3_length_870544_cov_266.585575     870544
NODE_4_length_682884_cov_179.590556     682884
NODE_5_length_527980_cov_227.488434     527980
NODE_6_length_404597_cov_274.760373     404597
NODE_7_length_363491_cov_203.441326     363491
NODE_8_length_354766_cov_338.799374     354766
NODE_9_length_242886_cov_301.761220     242886
NODE_10_length_185543_cov_311.624691    185543
NODE_11_length_155943_cov_296.151810    155943
NODE_12_length_130701_cov_350.935540    130701
NODE_13_length_108289_cov_194.144161    108289
NODE_14_length_72173_cov_318.018836     72173
NODE_15_length_67062_cov_316.686378     67062
NODE_16_length_65293_cov_335.010366     65293
NODE_17_length_41984_cov_336.515212     41984
NODE_18_length_9263_cov_322.075550      9263
NODE_19_length_8326_cov_370.677779      8326
NODE_20_length_6077_cov_322.093167      6077
NODE_21_length_4190_cov_310.371748      4190
NODE_22_length_1435_cov_891.186303      1435
NODE_23_length_1377_cov_4238.552308     1377
NODE_24_length_1270_cov_4086.636211     1270
NODE_25_length_972_cov_361.831285       972
NODE_26_length_725_cov_3975.049383      725
NODE_27_length_624_cov_3386.634369      624
NODE_28_length_461_cov_1625.309896      461
NODE_29_length_412_cov_620.104478       412
NODE_30_length_380_cov_363.590759       380
NODE_31_length_338_cov_313.321839       338
NODE_32_length_320_cov_348.609053       320
NODE_33_length_306_cov_4561.847162      306
NODE_34_length_299_cov_307.887387       299
NODE_35_length_279_cov_3634.668317      279
NODE_36_length_277_cov_240.315000       277
NODE_37_length_263_cov_792.983871       263
NODE_38_length_262_cov_1989.664865      262
NODE_39_length_261_cov_295.021739       261
NODE_40_length_252_cov_226.120000       252
NODE_41_length_247_cov_492.047059       247
NODE_42_length_243_cov_294.837349       243
NODE_43_length_235_cov_329.386076       235
NODE_44_length_233_cov_1311.410256      233
NODE_45_length_231_cov_264.311688       231
NODE_46_length_230_cov_341.405229       230
NODE_47_length_230_cov_280.986928       230
NODE_48_length_227_cov_311.720000       227
NODE_49_length_224_cov_589.959184       224
NODE_50_length_218_cov_783.773050       218
NODE_51_length_218_cov_84.687943        218
NODE_52_length_216_cov_429.395683       216
NODE_53_length_215_cov_76.210145        215
NODE_54_length_214_cov_166.043796       214
NODE_55_length_210_cov_213.473684       210
NODE_56_length_208_cov_1353.068702      208

## Lets rerun kraken2 on my spades assembled genome

kraken2 --db databases --threads 20 --classified-out kraken2/GB3_spades_classified.fasta --unclassified-out kraken2/GB3_spades_unclassified.fasta --report kraken2/GB3_k2_spades_report.txt --report-minimizer-data --output kraken2/GB3_k2_spades_output.txt spades/GB3_assembly/scaffolds_min200.fasta

### Lets take a look at the kraken2 report
$cat kraken2/GB3_k2_spades_report.txt

100.00  56      0       1290488 1262038 R       1       root
 98.21  55      0       1290402 1262038 R1      131567    cellular organisms
 98.21  55      0       1290041 1261525 D       2           Bacteria
 98.21  55      0       1283097 1257718 D1      1783272       Terrabacteria group
 98.21  55      0       1281993 1257590 P       1239            Firmicutes
 98.21  55      0       1280659 1255488 C       91061             Bacilli
 98.21  55      1       1279652 1254285 O       1385                Bacillales
 96.43  54      0       1269470 1248048 F       186822                Paenibacillaceae
 96.43  54      9       1260387 1235042 G       55080                   Brevibacillus
 76.79  43      12      465534  465534  S       1393                      Brevibacillus brevis
 48.21  27      27      84006   83166   S1      1200792                     Brevibacillus brevis X23
  7.14  4       4       5811    5811    S1      358681                      Brevibacillus brevis NBRC 100599
  3.57  2       2       11539   11485   S       54913                     Brevibacillus formosus
  1.79  1       0       5       3       R1      2787854   other entries
  1.79  1       1       5       3       R2      28384       other sequences

### Lets look at the contigs taxid classfication from kraken2 report

$seqkit fx2tab --length --name --header-line kraken2/GB3_spades_classified.fasta

#name   length
NODE_1_length_1096957_cov_232.845078 kraken:taxid|1200792       1096957
NODE_2_length_954570_cov_189.129124 kraken:taxid|1200792        954570
NODE_3_length_870544_cov_266.585575 kraken:taxid|1200792        870544
NODE_4_length_682884_cov_179.590556 kraken:taxid|1200792        682884
NODE_5_length_527980_cov_227.488434 kraken:taxid|1200792        527980
NODE_6_length_404597_cov_274.760373 kraken:taxid|1200792        404597
NODE_7_length_363491_cov_203.441326 kraken:taxid|1200792        363491
NODE_8_length_354766_cov_338.799374 kraken:taxid|1200792        354766
NODE_9_length_242886_cov_301.761220 kraken:taxid|1200792        242886
NODE_10_length_185543_cov_311.624691 kraken:taxid|1200792       185543
NODE_11_length_155943_cov_296.151810 kraken:taxid|1200792       155943
NODE_12_length_130701_cov_350.935540 kraken:taxid|1200792       130701
NODE_13_length_108289_cov_194.144161 kraken:taxid|1200792       108289
NODE_14_length_72173_cov_318.018836 kraken:taxid|1200792        72173
NODE_15_length_67062_cov_316.686378 kraken:taxid|1200792        67062
NODE_16_length_65293_cov_335.010366 kraken:taxid|1200792        65293
NODE_17_length_41984_cov_336.515212 kraken:taxid|1200792        41984
NODE_18_length_9263_cov_322.075550 kraken:taxid|1200792 9263
NODE_19_length_8326_cov_370.677779 kraken:taxid|1200792 8326
NODE_20_length_6077_cov_322.093167 kraken:taxid|1200792 6077
NODE_21_length_4190_cov_310.371748 kraken:taxid|358681  4190
NODE_22_length_1435_cov_891.186303 kraken:taxid|1200792 1435
NODE_23_length_1377_cov_4238.552308 kraken:taxid|55080  1377
NODE_24_length_1270_cov_4086.636211 kraken:taxid|55080  1270
NODE_25_length_972_cov_361.831285 kraken:taxid|358681   972
NODE_26_length_725_cov_3975.049383 kraken:taxid|55080   725
NODE_27_length_624_cov_3386.634369 kraken:taxid|55080   624
NODE_28_length_461_cov_1625.309896 kraken:taxid|1200792 461
*NODE_29_length_412_cov_620.104478 kraken:taxid|54913    412
NODE_30_length_380_cov_363.590759 kraken:taxid|1200792  380
NODE_31_length_338_cov_313.321839 kraken:taxid|1393     338
NODE_32_length_320_cov_348.609053 kraken:taxid|1393     320
NODE_33_length_306_cov_4561.847162 kraken:taxid|55080   306
NODE_34_length_299_cov_307.887387 kraken:taxid|1393     299
NODE_35_length_279_cov_3634.668317 kraken:taxid|55080   279
NODE_36_length_277_cov_240.315000 kraken:taxid|1393     277
NODE_37_length_263_cov_792.983871 kraken:taxid|1200792  263
NODE_38_length_262_cov_1989.664865 kraken:taxid|1200792 262
NODE_39_length_261_cov_295.021739 kraken:taxid|55080    261
NODE_40_length_252_cov_226.120000 kraken:taxid|1393     252
NODE_41_length_247_cov_492.047059 kraken:taxid|55080    247
NODE_42_length_243_cov_294.837349 kraken:taxid|1393     243
*NODE_43_length_235_cov_329.386076 kraken:taxid|28384    235
NODE_44_length_233_cov_1311.410256 kraken:taxid|1200792 233
NODE_45_length_231_cov_264.311688 kraken:taxid|1393     231
NODE_46_length_230_cov_341.405229 kraken:taxid|1393     230
NODE_47_length_230_cov_280.986928 kraken:taxid|1393     230
NODE_48_length_227_cov_311.720000 kraken:taxid|1393     227
NODE_49_length_224_cov_589.959184 kraken:taxid|1200792  224
NODE_50_length_218_cov_783.773050 kraken:taxid|55080    218
*NODE_51_length_218_cov_84.687943 kraken:taxid|54913     218
NODE_52_length_216_cov_429.395683 kraken:taxid|1393     216
NODE_53_length_215_cov_76.210145 kraken:taxid|1385      215
NODE_54_length_214_cov_166.043796 kraken:taxid|358681   214
NODE_55_length_210_cov_213.473684 kraken:taxid|1393     210
NODE_56_length_208_cov_1353.068702 kraken:taxid|358681  208

### now that we have analyzed the kraken2 report we can remove few contigs assigned to taxid 54913,28384
## for this we will use KrakenTools

$extract_kraken_reads.py -k kraken2/GB3_k2_spades_output.txt -s kraken2/GB3_spades_classified.fasta -o kraken2/GB3_k2_filtered_classified_spades_scaffold_min200.fasta -r kraken2/GB3_k2_spades_report.txt --exclude -t 54913 28384 

## Lets us go ahead with scaffolding using medusa, since we know our genome is Brevibacillus brevis, lets download few complete reference genomes

$ncbi-acc-download -F fasta -m nucleotide CP042161.1 CP030117.1 CP041767.1 CP023474.1 AP008955.1

### Now run medusa, note medusa is a java jar file and needs to be run from its location in ~/software/medusa
medusa -f ~/Desktop/NEHU_genomes/Genome_10_DBT_lignocellulose_project/medusa_scaffolding/GB3_reference/ -i ~/Desktop/NEHU_genomes/Genome_10_DBT_lignocellulose_project/kraken2/GB3_k2_filtered_classified_spades_scaffold_min200.fasta -v

## Lets see the scaffold output
$seqkit fx2tab --length --name --header-line kraken2/GB3_k2_filtered_classified_spades_scaffold_min200.fastaScaffold.fasta

#name   length
Scaffold_1      1084202
Scaffold_2      5282053
Scaffold_3      1435
Scaffold_4      299
Scaffold_5      262
Scaffold_6      215

## Move the scaffolded fasta to medusa directory
mv kraken2/GB3_k2_filtered_classified_spades_scaffold_min200.fastaScaffold.fasta medusa


### Statistics of the final assembly
file                                                                                        format  type  num_seqs    sum_len  min_len    avg_len    max_len
medusa_scaffolding/GB3_medusascaffold_krakenfiltered_spadesassembled_readcorr_min200.fasta  FASTA   DNA          6  6,368,466      215  1,061,411  5,282,053

