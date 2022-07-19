
We still don't know the species level taxonomy of the Acinetobacter genome that we have sequenced. To do that we will use `ANI calculation` with all other Acinetobacter genomes available in NCBI database. Traditionally we can do that using 16S sequencing or mlst data also. But since we have the entire genome it will be more definitive than trying to infer from one (16S) or a handful of genes (mlst)

#### First lets download all the Acinetobacter complete genomes from NCBI assembly database

Lets locate our current working directory or project root directory
```
$pwd
```

```
/Users/rajaldebnath/Documents/Github/Debnath_Acinetobacter_Novosphingobium_XXXX
```

Our project root directory has the following structure  
`$tree -L 2`

```
.
├── LICENSE.md
├── README.md
├── code
│   ├── README.md
│   └── genome_analysis_pipeline.md
├── data
│   ├── README.md
│   ├── processed
│   └── raw
├── exploratory
│   └── README.md
└── submission
    └── README.md
```

We will download all the genomes from NCBI for Acinetobacter using the following tools  

```
$ncbi-genome-download bacteria --formats fasta --assembly-levels complete --genera Acinetobacter --parallel 4
```

### Lets unarchive all the fna.gz files in to fasta files

```
$cd refseq/bacteria/
```

```
$for file in $(ls -1 -d GCF_*); do echo $file; cd $file; gunzip *.fna.gz; cd ../; done
```

```
$mkdir ../../allgenomes
```

```
$for file in $(ls -1 -d GCF_*); do echo $file; cd $file; cp *.fna ../../allgenomes; cd ../; done
```
```
cd ../../ && rm -r refseq/ && cd allgenomes
```

```
$grep "^>" GCF_* > Acinetobacter_complete_genomes_header.txt
```

```
$grep "^>" GCF_* | grep -v "plasmid" | cut -d":" -f2 | cut -d" " -f1 > Acinetobacter_complete_genomes_onlychromosome.txt
```
```
$sed -i '' 's/>//g' Acinetobacter_complete_genomes_onlychromosome.txt
```

```
for i in $(cat Acinetobacter_complete_genomes_onlychromosome.txt); do echo $i; seqkit grep -p $i All_genomes_acinetobacter.fna > $i.fna; done
```

#### We will use spades assembler for the genome assembly of Acinetobacter Hiseq generated fastq files 2x 150 bp
By checking the files with fastqc the files seemed already filtered and adapter trimmed.  


```
$cd /Users/rajaldebnath/Software/Trimmomatic/
```  

```
$java -jar trimmomatic-0.39.jar PE H2_S4_R1.fastq.gz H2_S4_R2.fastq.gz H2_trimmed_paired_R1.fastq.gz H2_trimmed_upaired_R1.fastq.gz H2_trimmed_paired_R2.fastq.gz H2_trimmed_unpaired.R2.fastq.gz ILLUMINACLIP:adapters/TruSeq3-PE.fa:2:30:10 SLIDINGWINDOW:5:20 MINLEN:100
```  

**OR**

```
fastp -i ../../raw/P5_S5_R1.fastq.gz -o ../../raw/P5_S5_R1_fastp.fastq.gz -I ../../raw/P5_S5_R2.fastq.gz -O ../../raw/P5_S5_R2_fastp.fastq.gz --detect_adapter_for_pe --cut_front --cut_tail --cut_window_size=4 --cut_mean_quality=20 --qualified_quality_phred=20 --unqualified_percent_limit=30 --n_base_limit=5 --length_required=50 --low_complexity_filter --complexity_threshold=30 --overrepresentation_analysis --json=fastp/P5_S5_fastp.json --html=fastp/P5_S5_fastp.html --report_title=P5_S5 --thread=8
```

```
$cd /Users/rajaldebnath/Software/kmergenie
```  

```
$./kmergenie genomefiles.txt -l 21 -k 121 -s 2 -o out_file.txt -t 6
```
## best k identified as 101  

Lets first move into the project root directory  
Then run spades with the below command -  

```
$cd /Users/rajaldebnath/Documents/Github/Debnath_Acinetobacter_Novosphingobium_XXXX
$mkdir data/processed/mappings && cd data/processed/mappings
$bwa index GCF_000191145.1_Acinetobacter_ref.fna
$bwa mem GCF_000191145.1_Acinetobacter_ref.fna ../trimmomatic/H2_trimmed_paired_R1.fastq ../trimmomatic/H2_trimmed_paired_R2.fastq > aligned-pe.sam
$samtools sort -n -O sam aligned-pe.sam -o aligned-pe-sorted.bam
$samtools fixmate -m -O bam aligned-pe-sorted.bam aligned-pe-sorted-fixmate.bam
$samtools sort -O bam -o aligned-pe-sorted-fixmate-sorted.bam aligned-pe-sorted-fixmate.bam
$samtools markdup -r -S aligned-pe-sorted-fixmate-sorted.bam aligned-pe-sorted-fixmate-sorted-dedup.bam
$samtools sort -n -O bam -o aligned-pe-sorted-fixmate-sorted-dedup-sorted.bam aligned-pe-sorted-fixmate-sorted-dedup.bam
$bedtools bamtofastq -i aligned-pe-sorted-fixmate-sorted-dedup-sorted.bam -fq H2_trimmed_mapped_R1.fastq -fq2 H2_trimmed_mapped_R2.fastq
```


```
$spades.py -1 data/raw/H2_S4_R1.fastq.gz -2 data/raw/H2_S4_R2.fastq.gz -t 6 --careful -o data/processed/Acinetobacter_spades_genomeassembly
```


#### Lets check the statistics of the generated contigs files after spades assembly

```
$seqkit stats data/processed/Acinetobacter_spades_genomeassembly/contigs.fasta
```

```
file                                                              format  type  num_seqs    sum_len  min_len  avg_len  max_len
data/processed/Acinetobacter_spades_genomeassembly/contigs.fasta  FASTA   DNA        126  2,939,579    3,531   23,330  104,389
```

#### Lets check the statistics of the generated scaffolds files after spades assembly

```
$seqkit stats data/processed/Acinetobacter_spades_genomeassembly/scaffolds.fasta
```


```
file                                                                format  type  num_seqs    sum_len  min_len   avg_len  max_len
data/processed/Acinetobacter_spades_genomeassembly/scaffolds.fasta  FASTA   DNA        124  2,939,599    3,531  23,706.4  104,389
```

#### There are total of 124 contigs generated by the assembler with total genome size of 2939599 bp with the size of the smallest contig being 3531 bp and largest one being 104,389 bp

#### Lets see the sizes of each individual contigs within the scaffold multifasta file

```
seqkit fx2tab --length --name --header-line  data/processed/Acinetobacter_spades_genomeassembly/scaffolds.fasta
```

```
#name	length
NODE_1_length_665784_cov_73.290891	665784
NODE_2_length_622929_cov_69.879079	622929
NODE_3_length_440999_cov_74.942929	440999
NODE_4_length_366085_cov_74.389366	366085
NODE_5_length_303354_cov_73.385918	303354
NODE_6_length_287360_cov_72.851505	287360
NODE_7_length_273780_cov_74.519757	273780
NODE_8_length_201045_cov_71.804048	201045
NODE_9_length_151851_cov_70.179036	151851
NODE_10_length_111327_cov_76.231982	111327
NODE_11_length_90281_cov_7.516751	90281
NODE_12_length_88831_cov_76.055378	88831
NODE_13_length_78622_cov_6.964759	78622
NODE_14_length_73272_cov_5.437366	73272
NODE_15_length_64983_cov_4.969987	64983
NODE_16_length_61305_cov_5.228474	61305
NODE_17_length_59089_cov_74.581305	59089
NODE_18_length_57622_cov_72.303953	57622
NODE_19_length_51215_cov_78.088838	51215
NODE_20_length_50945_cov_4.067941	50945
NODE_21_length_50660_cov_3.778997	50660
NODE_22_length_48638_cov_4.343053	48638
NODE_23_length_47895_cov_77.812665	47895
NODE_24_length_46658_cov_5.006440	46658
NODE_25_length_45949_cov_5.132238	45949
NODE_26_length_43033_cov_4.858343	43033
NODE_27_length_42180_cov_71.065859	42180
NODE_28_length_40033_cov_5.356968	40033
NODE_29_length_39681_cov_4.043076	39681
NODE_30_length_39498_cov_4.652723	39498
NODE_31_length_39249_cov_4.907817	39249
NODE_32_length_38728_cov_4.710978	38728
NODE_33_length_37293_cov_3.820185	37293
NODE_34_length_36236_cov_4.333333	36236
NODE_35_length_35287_cov_4.132746	35287
NODE_36_length_34490_cov_4.457531	34490
NODE_37_length_34140_cov_4.261897	34140
NODE_38_length_34038_cov_4.104473	34038
NODE_39_length_33935_cov_3.374978	33935
NODE_40_length_33904_cov_4.245218	33904
NODE_41_length_33219_cov_4.236588	33219
NODE_42_length_31944_cov_4.710516	31944
NODE_43_length_31033_cov_4.699574	31033
NODE_44_length_30299_cov_4.581629	30299
NODE_45_length_30256_cov_3.976838	30256
NODE_46_length_30073_cov_3.742332	30073
NODE_47_length_29413_cov_75.150430	29413
NODE_48_length_27316_cov_4.409780	27316
NODE_49_length_27297_cov_3.263703	27297
NODE_50_length_27110_cov_3.870196	27110
NODE_51_length_27066_cov_4.598800	27066
NODE_52_length_27019_cov_4.086371	27019
NODE_53_length_27004_cov_4.660378	27004
NODE_54_length_26648_cov_4.197509	26648
NODE_55_length_26141_cov_5.142687	26141
NODE_56_length_26050_cov_4.155739	26050
NODE_57_length_25615_cov_3.652400	25615
NODE_58_length_25567_cov_3.899490	25567
NODE_59_length_25417_cov_4.831689	25417
NODE_60_length_24453_cov_3.695110	24453
NODE_61_length_24416_cov_3.524015	24416
NODE_62_length_23930_cov_4.183750	23930
NODE_63_length_22860_cov_5.443884	22860
NODE_64_length_22728_cov_4.189925	22728
NODE_65_length_22524_cov_3.900922	22524
NODE_66_length_22281_cov_4.185147	22281
NODE_67_length_22206_cov_3.957883	22206
NODE_68_length_21668_cov_3.802325	21668
NODE_69_length_21604_cov_3.707205	21604
NODE_70_length_21318_cov_4.331152	21318
NODE_71_length_21227_cov_3.871631	21227
NODE_72_length_20985_cov_5.072986	20985
NODE_73_length_20980_cov_4.312013	20980
NODE_74_length_20828_cov_5.031227	20828
NODE_75_length_20642_cov_3.590907	20642
NODE_76_length_20574_cov_5.041762	20574
NODE_77_length_20491_cov_3.678064	20491
NODE_78_length_20467_cov_4.797401	20467
NODE_79_length_20203_cov_5.034483	20203
NODE_80_length_20165_cov_4.196286	20165
NODE_81_length_19981_cov_4.224076	19981
NODE_82_length_19977_cov_77.000804	19977
NODE_83_length_19746_cov_3.513803	19746
NODE_84_length_19354_cov_4.097837	19354
NODE_85_length_18946_cov_5.089512	18946
NODE_86_length_18613_cov_4.440224	18613
NODE_87_length_18380_cov_4.902694	18380
NODE_88_length_18378_cov_3.751270	18378
NODE_89_length_17929_cov_3.551479	17929
NODE_90_length_17475_cov_5.652604	17475
NODE_91_length_17461_cov_3.922630	17461
NODE_92_length_16972_cov_4.271441	16972
NODE_93_length_16934_cov_4.223053	16934
NODE_94_length_16884_cov_4.695603	16884
NODE_95_length_16750_cov_4.332274	16750
NODE_96_length_16731_cov_3.882671	16731
NODE_97_length_16625_cov_3.895335	16625
NODE_98_length_16443_cov_4.359587	16443
NODE_99_length_15794_cov_4.325698	15794
NODE_100_length_15792_cov_3.944575	15792
NODE_101_length_15770_cov_3.885809	15770
NODE_102_length_15662_cov_3.424062	15662
NODE_103_length_15556_cov_3.555591	15556
NODE_104_length_15300_cov_4.170794	15300
NODE_105_length_15014_cov_3.469104	15014
NODE_106_length_14951_cov_4.242571	14951
NODE_107_length_14786_cov_3.431165	14786
NODE_108_length_14416_cov_3.882000	14416
NODE_109_length_14276_cov_3.894781	14276
NODE_110_length_14241_cov_7.619811	14241
NODE_111_length_14215_cov_3.637007	14215
NODE_112_length_13966_cov_4.404349	13966
NODE_113_length_13768_cov_4.324374	13768
NODE_114_length_13386_cov_3.489819	13386
NODE_115_length_13343_cov_4.587969	13343
NODE_116_length_13147_cov_4.298546	13147
NODE_117_length_13144_cov_5.772939	13144
NODE_118_length_13099_cov_3.867532	13099
NODE_119_length_12803_cov_4.156216	12803
NODE_120_length_12668_cov_5.452387	12668
NODE_121_length_12634_cov_4.493271	12634
NODE_122_length_12620_cov_3.525472	12620
NODE_123_length_12609_cov_3.353814	12609
NODE_124_length_12573_cov_3.893646	12573
NODE_125_length_12412_cov_3.603972	12412
NODE_126_length_12225_cov_4.669164	12225
NODE_127_length_11953_cov_4.955625	11953
NODE_128_length_11850_cov_2.810584	11850
NODE_129_length_11587_cov_3.158210	11587
NODE_130_length_11512_cov_3.281941	11512
NODE_131_length_11416_cov_5.179469	11416
NODE_132_length_11404_cov_5.230158	11404
NODE_133_length_11288_cov_4.331103	11288
NODE_134_length_11268_cov_5.132964	11268
NODE_135_length_11135_cov_3.538795	11135
NODE_136_length_11078_cov_4.036724	11078
NODE_137_length_11012_cov_3.073891	11012
NODE_138_length_10991_cov_4.635422	10991
NODE_139_length_10921_cov_5.134176	10921
NODE_140_length_10906_cov_3.790839	10906
NODE_141_length_10827_cov_3.459628	10827
NODE_142_length_10620_cov_3.726074	10620
NODE_143_length_10604_cov_4.436497	10604
NODE_144_length_10524_cov_3.443285	10524
NODE_145_length_10443_cov_3.744164	10443
NODE_146_length_10335_cov_5.349288	10335
NODE_147_length_10312_cov_3.040938	10312
NODE_148_length_10285_cov_3.278213	10285
NODE_149_length_9666_cov_4.231202	9666
NODE_150_length_9626_cov_3.451775	9626
NODE_151_length_9546_cov_3.392861	9546
NODE_152_length_9529_cov_3.687156	9529
NODE_153_length_9444_cov_3.246610	9444
NODE_154_length_9009_cov_4.050381	9009
NODE_155_length_8814_cov_3.740643	8814
NODE_156_length_8752_cov_4.377983	8752
NODE_157_length_8672_cov_3.220710	8672
NODE_158_length_8653_cov_3.859375	8653
NODE_159_length_8306_cov_3.216673	8306
NODE_160_length_8261_cov_2.951124	8261
NODE_161_length_8253_cov_5.341120	8253
NODE_162_length_8016_cov_3.723265	8016
NODE_163_length_7975_cov_3.616232	7975
NODE_164_length_7865_cov_3.231895	7865
NODE_165_length_7833_cov_3.383058	7833
NODE_166_length_7806_cov_3.967784	7806
NODE_167_length_7751_cov_4.139432	7751
NODE_168_length_7745_cov_4.328247	7745
NODE_169_length_7718_cov_4.229551	7718
NODE_170_length_7707_cov_3.289646	7707
NODE_171_length_6802_cov_3.500223	6802
NODE_172_length_6783_cov_3.772890	6783
NODE_173_length_6697_cov_3.626888	6697
NODE_174_length_6645_cov_3.272838	6645
NODE_175_length_6615_cov_4.539003	6615
NODE_176_length_6543_cov_3.509589	6543
NODE_177_length_6537_cov_77.477554	6537
NODE_178_length_6512_cov_4.990210	6512
NODE_179_length_6512_cov_4.500855	6512
NODE_180_length_6390_cov_3.472834	6390
NODE_181_length_6250_cov_3.925158	6250
NODE_182_length_6229_cov_3.457250	6229
NODE_183_length_6218_cov_5.533952	6218
NODE_184_length_6191_cov_3.982663	6191
NODE_185_length_6063_cov_3.108420	6063
NODE_186_length_6028_cov_4.575702	6028
NODE_187_length_5934_cov_2.674065	5934
NODE_188_length_5860_cov_3.514439	5860
NODE_189_length_5828_cov_3.630151	5828
NODE_190_length_5771_cov_3.635933	5771
NODE_191_length_5670_cov_3.365457	5670
NODE_192_length_5646_cov_5.830849	5646
NODE_193_length_5561_cov_19.822028	5561
NODE_194_length_5550_cov_3.316097	5550
NODE_195_length_5534_cov_2.966465	5534
NODE_196_length_5501_cov_3.144174	5501
NODE_197_length_5473_cov_4.256672	5473
NODE_198_length_5442_cov_388.513514	5442
NODE_199_length_5368_cov_3.228879	5368
NODE_200_length_5357_cov_4.337311	5357
NODE_201_length_5341_cov_3.328078	5341
NODE_202_length_5303_cov_3.776693	5303
NODE_203_length_5215_cov_3.510315	5215
NODE_204_length_5186_cov_5.029947	5186
NODE_205_length_5154_cov_2.850502	5154
NODE_206_length_5151_cov_5.352385	5151
NODE_207_length_5144_cov_3.693112	5144
NODE_208_length_5126_cov_4.160032	5126
NODE_209_length_5038_cov_3.402943	5038
NODE_210_length_5014_cov_3.720681	5014
NODE_211_length_5007_cov_3.215010	5007
NODE_212_length_4989_cov_3.636604	4989
NODE_213_length_4868_cov_2.782509	4868
NODE_214_length_4834_cov_3.660290	4834
NODE_215_length_4804_cov_5.359636	4804
NODE_216_length_4710_cov_3.199439	4710
NODE_217_length_4701_cov_3.149654	4701
NODE_218_length_4682_cov_3.689034	4682
NODE_219_length_4658_cov_3.355163	4658
NODE_220_length_4617_cov_3.950881	4617
NODE_221_length_4439_cov_3.453920	4439
NODE_222_length_4385_cov_3.332637	4385
NODE_223_length_4357_cov_4.469393	4357
NODE_224_length_4343_cov_3.491092	4343
NODE_225_length_4256_cov_3.957167	4256
NODE_226_length_4216_cov_3.972457	4216
NODE_227_length_4160_cov_4.178055	4160
NODE_228_length_4129_cov_3.959279	4129
NODE_229_length_4095_cov_4.067944	4095
NODE_230_length_3672_cov_67.132128	3672
NODE_231_length_3529_cov_3.194670	3529
NODE_232_length_3494_cov_2.807141	3494
NODE_233_length_3481_cov_4.293478	3481
NODE_234_length_3436_cov_2.998511	3436
NODE_235_length_3366_cov_4.885071	3366
NODE_236_length_3135_cov_3.436887	3135
NODE_237_length_3118_cov_3.155212	3118
NODE_238_length_3114_cov_3.426078	3114
NODE_239_length_3024_cov_3.557855	3024
NODE_240_length_2997_cov_2.985274	2997
NODE_241_length_2988_cov_3.443147	2988
NODE_242_length_2965_cov_3.014197	2965
NODE_243_length_2964_cov_26.710426	2964
NODE_244_length_2888_cov_3.618997	2888
NODE_245_length_2814_cov_3.659847	2814
NODE_246_length_2751_cov_2.859013	2751
NODE_247_length_2554_cov_3.650384	2554
NODE_248_length_2500_cov_4.170037	2500
NODE_249_length_2422_cov_3.400426	2422
NODE_250_length_2383_cov_3.811795	2383
NODE_251_length_2322_cov_3.280624	2322
NODE_252_length_2317_cov_3.148661	2317
NODE_253_length_2317_cov_2.901786	2317
NODE_254_length_2263_cov_3.456999	2263
NODE_255_length_2246_cov_3.292301	2246
NODE_256_length_2233_cov_2.648887	2233
NODE_257_length_2186_cov_3.529161	2186
NODE_258_length_2162_cov_3.502158	2162
NODE_259_length_2094_cov_5.284581	2094
NODE_260_length_2056_cov_3.500253	2056
NODE_261_length_2022_cov_3.633419	2022
NODE_262_length_1969_cov_3.099894	1969
NODE_263_length_1968_cov_4.379164	1968
NODE_264_length_1939_cov_3.657358	1939
NODE_265_length_1927_cov_2.984865	1927
NODE_266_length_1919_cov_4.637894	1919
NODE_267_length_1915_cov_3.181719	1915
NODE_268_length_1899_cov_4.610867	1899
NODE_269_length_1892_cov_3.563636	1892
NODE_270_length_1862_cov_3.566947	1862
NODE_271_length_1833_cov_3.099089	1833
NODE_272_length_1773_cov_3.015330	1773
NODE_273_length_1752_cov_3.029851	1752
NODE_274_length_1743_cov_3.364346	1743
NODE_275_length_1735_cov_3.493969	1735
NODE_276_length_1717_cov_2.486585	1717
NODE_277_length_1686_cov_3.042884	1686
NODE_278_length_1676_cov_5.027517	1676
NODE_279_length_1672_cov_3.157994	1672
NODE_280_length_1661_cov_2.974116	1661
NODE_281_length_1644_cov_3.469687	1644
NODE_282_length_1597_cov_3.582237	1597
NODE_283_length_1591_cov_4.377147	1591
NODE_284_length_1560_cov_2.262306	1560
NODE_285_length_1532_cov_3.254983	1532
NODE_286_length_1430_cov_3.739098	1430
NODE_287_length_1427_cov_2.715556	1427
NODE_288_length_1371_cov_2.123648	1371
NODE_289_length_1360_cov_2.919719	1360
NODE_290_length_1294_cov_3.888250	1294
NODE_291_length_1294_cov_3.425637	1294
NODE_292_length_1229_cov_4.101562	1229
NODE_293_length_1229_cov_2.553819	1229
NODE_294_length_1189_cov_2.625899	1189
NODE_295_length_1179_cov_132.794918	1179
NODE_296_length_1156_cov_3.059314	1156
NODE_297_length_1127_cov_7.449524	1127
NODE_298_length_1109_cov_6.771318	1109
NODE_299_length_1102_cov_1.497561	1102
NODE_300_length_1080_cov_4.841476	1080
NODE_301_length_1051_cov_3.647844	1051
NODE_302_length_1031_cov_1.842767	1031
NODE_303_length_1028_cov_3.352261	1028
```

#### We used plasmid finder online portal to check if our contigs contain any signatures for plasmids
 There were no plasmids detected in the sequences.

#### Next lets calculate the ANI by comparing ours genome sequence with all the genomes that we downloaded at the start from NCBI
We will use fastANI tool for this, as this uses mash map based approach reducing time significantly.

Lets create a fastANI directory under the `data/processed/` directory and put all our genome fasta files inside it.

For this we will first symlink all the genome files located in `data/raw/allgenomes/` into the fastANI directory just created.  

```
$mkdir data/processed/fastANI
```

```
$cd data/raw/allgenomes/
```

Or we can copy all the files into the fastANI directory, like so

```
$cp data/raw/allgenomes/*.fna data/processed/fastANI
```

```
$cd data/processed/fastANI
```  

Run fastANI with our query genome Acinetobacter_NEHU.fna (renamed scaffold.fasta from spades assembly) with all the reflist genomes in a list file  

```
$grep ">" *.fna | cut -d'>' -f2 > matrix_rownames.txt
$sed -i '' 's/ com.*//g' matrix_rownames.txt
$sed -i '' 's/,//g' matrix_rownames.txt
$sed -i '' 's/ chr.*//g' matrix_rownames.txt
$sed -i '' 's/isolate //g' matrix_rownames.txt
$sed -i '' 's/strain //g' matrix_rownames.txt
$fastANI --ql querylist.txt --rl reflist.txt -o fastANI_output.txt --visualize --matrix
```  

#### Lets annotate the genome using prokka annotation tool  

```
$prokka --outdir data/processed/prokka_annotation/ --prefix AcinetoNEHU --addgenes --addmrna --locustag NEHUBIO --compliant --centre NEHU --genus Acinetobacter --strain NEHU1 --gcode 11 --rfam --rnammer data/processed/fastANI/Acinetobacter_NEHU.fna --force
```

Pull out the 16S ribosomal RNA from the genome to check the genus of the organism by blasting in NCBI web

```
$grep "16S" data/processed/prokka_annotation/AcinetoNEHU.ffn
```

```
>NEHUBIO_00257 16S ribosomal RNA
>NEHUBIO_01512 Putative pre-16S rRNA nuclease
```

NCBI blast with the complete 16S sequence classified it as `Acinetobacter pittii`
