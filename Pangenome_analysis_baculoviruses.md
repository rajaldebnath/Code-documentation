---
title: "NPV pangenome analysis"  
author: "Rajal Debnath"  
date: 2022-03-22  
---
Genomes of NPV downloaded from ncbi, gbk, fna, faa and gff files are provided

```
$pwd
```

```
/Documents/SBRL/Research_Projects/Baculovirus_research
```
```
$mkdir NPV_gbk NPV_GFF NPV_fna NPV_faa
```

```
$ls -1 NPV_gbk
```

```
AY_Anya-JP_LC375537.gbk
Aper_Anpe-CN_LC375540.gbk
Aper_AnpeMNPV-L2_EF207986.gbk
Apro_Anpr-IN_LC375539.gbk
Apro_AnprNPV-TS_KY979487.gbk
Apro_TkhulenIBD_MH797002.gbk
Bmori_NPV_NC001962.gbk
Boma_NPV_NC012672.gbk
Bombyx1.gbk
SC_LC375538.gbk
SR_LC375543.gbk
SRg_LC375541.gbk
SRm_LC375542.gbk
```

```
$ls -1 NPV_fna
```

```
Apro_TkhulenIBD_MH797002.fasta
Aper_AnpeMNPV-L2_EF207986.fasta
Apro_AnprNPV-TS_KY979487.fasta
Boma_NPV_NC012672.fasta
Bmori_NPV_NC001962.fasta
SC_LC375538.fasta
SRg_LC375541.fasta
SRm_LC375542.fasta
SR_LC375543.fasta
Aper_Anpe-CN_LC375540.fasta
Apro_Anpr-IN_LC375539.fasta
AY_Anya-JP_LC375537.fasta
```

```
$ls -1 NPV_faa
```

```
AY_Anya-JP.faa
Aper_Anpe-CN.faa
Aper_AnpeMNPV-L2.faa
Apro_Anpr-IN.faa
Apro_AnprNPV-TS.faa
Apro_TkhulenIBD.faa
Bmori_NPV_NC001962.faa
Boma_NPV_NC012672.faa
SC_LC375538.faa
SR_LC375543.faa
SRg_LC375541.faa
SRm_LC375542.faa
```

```
$ls -1 NPV_GFF
```

```
AY_Anya-JP_LC375537.gff3
Aper_Anpe-CN_LC375540.gff3
Aper_AnpeMNPV-L2_EF207986.gff3
Apro_Anpr-IN_LC375539.gff3
Apro_AnprNPV-TS_KY979487.gff3
Apro_TkhulenIBD_MH797002.gff3
Bmori_NPV_NC001962.gff3
Boma_NPV_NC012672.gff3
SC_LC375538.gff3
SR_LC375543.gff3
SRg_LC375541.gff3
SRm_LC375542.gff3
```

Lets check the genome sequence sizes at a glance.  

```
$seqkit stat NPV_fna/*.fasta
```

```
file                                     format  type  num_seqs  sum_len  min_len  avg_len  max_len
NPV_fna/AY_Anya-JP_LC375537.fasta        FASTA   DNA          1  126,270  126,270  126,270  126,270
NPV_fna/Aper_Anpe-CN_LC375540.fasta      FASTA   DNA          1  126,646  126,646  126,646  126,646
NPV_fna/Aper_AnpeMNPV-L2_EF207986.fasta  FASTA   DNA          1  126,246  126,246  126,246  126,246
NPV_fna/Apro_Anpr-IN_LC375539.fasta      FASTA   DNA          1  126,324  126,324  126,324  126,324
NPV_fna/Apro_AnprNPV-TS_KY979487.fasta   FASTA   DNA          1  126,930  126,930  126,930  126,930
NPV_fna/Apro_TkhulenIBD_MH797002.fasta   FASTA   DNA          1  126,930  126,930  126,930  126,930
NPV_fna/Bmori_NPV_NC001962.fasta         FASTA   DNA          1  128,413  128,413  128,413  128,413
NPV_fna/Boma_NPV_NC012672.fasta          FASTA   DNA          1  126,770  126,770  126,770  126,770
NPV_fna/SC_LC375538.fasta                FASTA   DNA          1  126,094  126,094  126,094  126,094
NPV_fna/SR_LC375543.fasta                FASTA   DNA          1  128,602  128,602  128,602  128,602
NPV_fna/SRg_LC375541.fasta               FASTA   DNA          1  125,921  125,921  125,921  125,921
NPV_fna/SRm_LC375542.fasta               FASTA   DNA          1  128,240  128,240  128,240  128,240
```

#### FastANI calculation.
To better visualize closeness of the npv genomes relative to each other, all the available nucleopolyhedrosis virus available in NCBI genome database were download `https://www.ncbi.nlm.nih.gov/datasets/genomes/?taxon=alphabaculovirus` and fastANI was calculated to generate a heatmap of average nucleotide identity.

```
$datasets download genome taxon alphabaculovirus --dehydrated --include-gbff --exclude-rna --filename ncbi_alphabaculovirus_genomes_26032022.zip


Collecting 142 genome accessions [================================================] 100% 142/142
Downloading: ncbi_alphabaculovirus_genomes_26032022.zip    37.5kB done
New version of client (13.6.0) available at https://ftp.ncbi.nlm.nih.gov/pub/datasets/command-line/LATEST/linux-amd64/datasets
```

```
$unzip ncbi_alphabaculovirus_genomes_26032022.zip -d ncbi_alphabaculovirus_genomes_26032022  


Archive:  ncbi_alphabaculovirus_genomes_26032022.zip
  inflating: ncbi_alphabaculovirus_genomes_26032022/README.md  
  inflating: ncbi_alphabaculovirus_genomes_26032022/ncbi_dataset/data/assembly_data_report.jsonl  
  inflating: ncbi_alphabaculovirus_genomes_26032022/ncbi_dataset/fetch.txt  
  inflating: ncbi_alphabaculovirus_genomes_26032022/ncbi_dataset/data/dataset_catalog.json
```

```
$datasets rehydrate --directory ncbi_alphabaculovirus_genomes_26032022


Found 700 files for rehydration
Completed 700 of 700 [================================================] 100%
Downloading: ncbi_alphabaculovirus_genomes_26032022/ncbi_dataset/data/GCF_013087155.1/sequence_report.jsonl    238B done
Downloading: ncbi_alphabaculovirus_genomes_26032022/ncbi_dataset/data/GCF_004130555.1/sequence_report.jsonl    238B done
Downloading: ncbi_alphabaculovirus_genomes_26032022/ncbi_dataset/data/GCF_004788315.1/sequence_report.jsonl    238B done
Downloading: ncbi_alphabaculovirus_genomes_26032022/ncbi_dataset/data/GCF_004131725.1/sequence_report.jsonl    238B done
Downloading: ncbi_alphabaculovirus_genomes_26032022/ncbi_dataset/data/GCF_013087385.1/sequence_report.jsonl    238B done
Downloading: ncbi_alphabaculovirus_genomes_26032022/ncbi_dataset/data/GCF_004788455.1/sequence_report.jsonl    238B done
Downloading: ncbi_alphabaculovirus_genomes_26032022/ncbi_dataset/data/GCF_013088185.1/sequence_report.jsonl    238B done
Downloading: ncbi_alphabaculovirus_genomes_26032022/ncbi_dataset/data/GCF_013087105.1/sequence_report.jsonl    238B done
Downloading: ncbi_alphabaculovirus_genomes_26032022/ncbi_dataset/data/GCF_013088165.1/sequence_report.jsonl    238B done
Downloading: ncbi_alphabaculovirus_genomes_26032022/ncbi_dataset/data/GCF_004787415.1/sequence_report.jsonl    238B done
```

Total 143 complete genomes were download from both GenBank and Refseq database. We will remove duplicates and retain only the Refseq genomes for further study  


```
ls -d GC* | wc -l

143

```
Remove all the genomes from the Genbank repository
```
rm -r GCA*
```

```
ls -d GC* | wc -l

68

```
Together with all the NPV from silkworm

AY_LC375537.fasta  
Aper_AnpeMNPV-L2_EF207986.fasta  
Aper_LC375540.fasta  
Apro_AnprNPV-TS_KY979487.fasta  
Apro_LC375539.fasta  
Bmori_NC_001962.fasta  
Boma_NC_012672.fasta  
SC_LC375538.fasta  
SR_LC375543.fasta  
SRg_LC375541.fasta  
SRm_LC375542.fasta  

fastANI was calculated and the matrix was plotted in R :

<img src="/Users/rajaldebnath/Documents/SBRL/Research_Projects/Baculovirus_research/ANI/fastANI_NPV.png" alt="fastANI" width="800"/>

#### Genome alignment visualization of all silkworm NPV  

All the genomes of NPV, saturniids and Bombyx mori were aligned and visualized to determine structural changes. Compared to Bombyx mori all Saturniids retained genomic rearrangement.  


<img src="/Users/rajaldebnath/Documents/SBRL/Research_Projects/Baculovirus_research/Mauve_alignment/Full_NPV/Full_NPV_mauve_genoplotR.png" alt="Mauve_alignment" width="800"/>  


#### We will use the `get_homologues` pipeline to perform pangenome analysis, we used three different methods BDBH, OMCL and COG triangles with stingency for Pfam domain search, output is generated in a directory NPV_gbk_homologues, we have also excluded B mandarina from the study

```
$get_homologues.pl -d NPV_gbk -D -c &> log.get_homologues_npv_BDBHDt0c
```  
```
$get_homologues.pl -d NPV_gbk -G -D -t 0 -c &> log.get_homologues_npv_GDt0c
```  
```
$get_homologues.pl -d NPV_gbk -M -D -t 0 -c &> log.get_homologues_npv_MDt0c
```

Lets find the sample interaction from the clusters generated by each of the three algorithms COG, OMCL, which will give us clusters with more confidence  
** Note since, BBDH cannot be run with -t 0, we will not include in the compare clusters command  

```
$compare_clusters.pl -d NPV_gbk_homologues/BmoriNPVNC001962_f0_0taxa_algCOG_e0_,NPV_gbk_homologues/BmoriNPVNC001962_f0_0taxa_algOMCL_e0_ -t 0 -m -o NPV_gbk_homologues/intersect_COG_OMCL_t0m
```

```
$cd NPV_gbk_homologues/intersect_COG_OMCL_t0m
```
#### Get homologues has a script to plot the heatmap from the matrix generated by the above run but we will create a customized plot in R below, however the code to generate the heatmap using get_homologues script is :  

```
$plot_matrix_heatmap.sh -i pangenome_matrix_t0.tab -o pdf -r -H 7 -W 10 -m 20 -t "OMCL and COG cluster (211)"
```



#### Lets calculate the core, cloud, soft core and shell genes for the pangenome_matrix_t0.tab

Defining the pangenome compartments :-

Table 5: Definitions of pangenome compartments/occupancy classes used by GET_HOMOLOGUES, taken from PubMed=23241446. Accessory genes include both shell and cloud genes.  

| class	    | alternative name | definition |
|:------    |:----------------:|-----------:|
| core      |                   | Genes contained in all considered genomes/taxa |
| soft core |              | Genes contained in 95% of the considered genomes/taxa, as in the work of Kaas and collaborators (PubMed=23114024)|
| cloud     | strain-specific (PubMed=25483351) | Rare genes present only in a few genomes/taxa. The cutoff is defined as the class next to the most populated non-core cluster class.|
| shell     | dispensable (PubMed=25483351) | Remaining moderately conserved genes, present in several genomes/taxa |

```
$parse_pangenome_matrix.pl -m pangenome_matrix_t0.tab -s
```

```
# /Users/rajaldebnath/Software/get_homologues/parse_pangenome_matrix.pl -m genomefiles_npv_homologues/intersect_COG_OMCL_Dt0m/pangenome_matrix_t0.tab -I  -A  -B  -a 0 -g 0 -e 0 -p  -s 1 -l 0 -x 0 -P 100 -S 0

# matrix contains 211 clusters and 11 taxa

# cloud size: 53 list: genomefiles_npv_homologues/intersect_COG_OMCL_Dt0m/pangenome_matrix_t0__cloud_list.txt
# shell size: 29 list: genomefiles_npv_homologues/intersect_COG_OMCL_Dt0m/pangenome_matrix_t0__shell_list.txt
# soft core size: 129 list: genomefiles_npv_homologues/intersect_COG_OMCL_Dt0m/pangenome_matrix_t0__softcore_list.txt
# core size: 99 (included in soft core) list: genomefiles_npv_homologues/intersect_COG_OMCL_Dt0m/pangenome_matrix_t0__core_list.txt

# using default colors, defined in %COLORS

# globals controlling R plots: $YLIMRATIO=1.2
Fontconfig warning: ignoring UTF-8: not a valid region tag

# shell bar plots: genomefiles_npv_homologues/intersect_COG_OMCL_Dt0m/pangenome_matrix_t0__shell.png , genomefiles_npv_homologues/intersect_COG_OMCL_Dt0m/pangenome_matrix_t0__shell.pdf , genomefiles_npv_homologues/intersect_COG_OMCL_Dt0m/pangenome_matrix_t0__shell.svg
# shell circle plots: genomefiles_npv_homologues/intersect_COG_OMCL_Dt0m/pangenome_matrix_t0__shell_circle.png , genomefiles_npv_homologues/intersect_COG_OMCL_Dt0m/pangenome_matrix_t0__shell_circle.pdf , genomefiles_npv_homologues/intersect_COG_OMCL_Dt0m/pangenome_matrix_t0__shell_circle.svg

# pan-genome size estimates (Snipen mixture model PMID:19691844): genomefiles_npv_homologues/intersect_COG_OMCL_Dt0m/pangenome_matrix_t0__shell_estimates.tab
Core.size Pan.size BIC LogLikelihood
2 components 99 211 1251.55752967662 -617.750977638096
3 components 89 242 750.285692198528 -361.763200765574
4 components 0 252 729.995006123901 -346.265999594784
5 components 0 301 737.348633639702 -344.590955219208
6 components 0 337 747.498802338776 -344.31418143527
7 components 0 322 758.428950620317 -344.427397442564
8 components 0 313 769.231784797705 -344.476956397782
9 components 0 329 780.016157332533 -344.51728453172
10 components 0 338 790.403401756627 -344.359048610291
Sample 99 211 NA NA


# occupancy stats:
	cloud	shell	soft_core	core
AY_Anya-JP_LC375537.gbk	1	20	129	99
Aper_Anpe-CN_LC375540.gbk	4	19	129	99
Aper_AnpeMNPV-L2_EF207986.gbk	2	12	129	99
Apro_Anpr-IN_LC375539.gbk	3	19	129	99
Apro_AnprNPV-TS_KY979487.gbk	3	12	129	99
Apro_TkhulenIBD_MH797002.gbk	4	12	129	99
Bmori_NPV_NC001962.gbk	37	2	101	99
SC_LC375538.gbk	1	20	129	99
SR_LC375543.gbk	3	18	129	99
SRg_LC375541.gbk	2	18	127	99
SRm_LC375542.gbk	3	18	129	99
```

#### Lets summarize the above results graphically
For this the `pangenome_matrix_t0.tr.tab` and the newick tree `pangenome_matrix_t0.phylip.ph` file generated in the above `compare_clusters` step will be imported into R and analyzed.

Summarizing the above result of core, shell, cloud and soft core genes in the pangenome of NPV

<img src="/Users/rajaldebnath/Documents/SBRL/Research_Projects/Baculovirus_research/NPV_gbk_homologues/get_homologues_gene_set.png" alt="Summary pangenome" width="800"/>  

The tree generated by the pangenome matrix (presence absence of clusters only)

<img src="/Users/rajaldebnath/Documents/SBRL/Research_Projects/Baculovirus_research/NPV_gbk_homologues/pangenome_tree.png" alt="NPV pangenome tree" width="400"/>  


Similarly, plotting the pangenome_matrix in the form of a heatmap  

<img src="/Users/rajaldebnath/Documents/SBRL/Research_Projects/Baculovirus_research/NPV_gbk_homologues/pangenome_heatmap_p-a.png" alt="NPV pangenome heatmap" width="800"/>  

#### Listing of ortholog clusters present in sets of genomes under study

1. PanGenes clusters present in Bombyx mori NPV but not in any of the saturniids

```
# /Users/rajaldebnath/Software/get_homologues/parse_pangenome_matrix.pl -m pangenome_matrix_t0.tab -A B.txt -B A.txt -g 1 -e 0 -p  -P 100 -S 0
# genes present in set A (B.txt-Bombyx) and absent in B (A.txt-all saturniids) (36):
899_orf1629.faa
905_Orf_7a.faa
910_arif-1.faa
921_Orf_22a.faa
924_Orf_25.faa
929_p43.faa
935_Orf_36.faa
940_Orf_41.faa
945_Orf_45.faa
948_Orf_48.faa
951_Orf_51.faa
954_Orf_54.faa
956_Orf_56.faa
960_Orf_59.faa
961_Orf_60.faa
970_p95.faa
971_p15.faa
975_Orf_74.faa
981_bro-b.faa
985_DNA_Binding.faa
987_Orf_86.faa
989_vp80.faa
990_he65.faa
998_Orf_95a.faa
1002_Orf_98a.faa
1003_Orf_99.faa
1004_gcn2.faa
1013_Orf_109.faa
1015_Orf_110a.faa
1016_Orf_111.faa
1017_p35.faa
1030_Orf_125.faa
1031_Orf_126.faa
1034_Orf_129.faa
1036_bro-d.faa
1039_Orf_134.faa
```

2. PanGenes clusters present in all Saturniids npv but not in Bombyx mori NPV

```
# /Users/rajaldebnath/Software/get_homologues/parse_pangenome_matrix.pl -m pangenome_matrix_t0.tab -A A.txt -B B.txt -g 1 -e 0 -p  -P 100 -S 0
# genes present in set A (A.txt-allsaturnids) and absent in B (B.txt-Bombyx) (28):
2_1629capsid.faa
4_orf4.faa
7_orf7.faa
19_orf19.faa
24_p22.2.faa
26_orf26.faa
36_orf36.faa
39_orf39.faa
47_chtB2.faa
51_pnk-pnl.faa
55_p12.faa
58_p6.9.faa
71_orf71.faa
73_vp91.faa
82_orf82.faa
83_orf83.faa
87_pif-6.faa
89_desmo.faa
94_chaB_fp.faa
107_etm.faa
122_orf122.faa
124_orf124.faa
126_ctl-2.faa
128_orf128.faa
135_arif-1.faa
146_ctl-1.faa
147_ptp-2.faa
152_orf152.faa
```

3. PanGenes clusters present in all Proyeli npv but not in all other NPV (unique to Proyeli)

```
# /Users/rajaldebnath/Software/get_homologues/parse_pangenome_matrix.pl -m pangenome_matrix_t0.tab -A B.txt -B A.txt -g 1 -e 0 -p  -P 100 -S 0
# genes present in set A (proyeli) and absent in B (all others) (0):
```

4. PanGenes clusters present in all Pernyi npv but not in all other NPV (unique to Pernyi)

```
# /Users/rajaldebnath/Software/get_homologues/parse_pangenome_matrix.pl -m pangenome_matrix_t0.tab -A A.txt -B B.txt -g 1 -e 0 -p  -P 100 -S 0
# genes present in set A (all pernyi) and absent in B (all others) (1):
297_orf145.faa
```  

5. PanGenes clusters present in all Samia npv but not in all other NPV (unique ot Samia)

```
# /Users/rajaldebnath/Software/get_homologues/parse_pangenome_matrix.pl -m pangenome_matrix_t0.tab -A A.txt -B B.txt -g 1 -e 0 -p  -P 100 -S 0
# genes present in set A (all Samia) and absent in B (all others) (0):
```  

6. PanGenes clusters present in all Pernyi npv but not in all Antheraea NPV

```
# /Users/rajaldebnath/Software/get_homologues/parse_pangenome_matrix.pl -m pangenome_matrix_t0.tab -A A.txt -B B.txt -g 1 -e 0 -p  -P 100 -S 0
# genes present in set A (all pernyi) and absent in B (all Antheraea) (1):
297_orf145.faa
```

7. Genes unique to Apro_Anpr-IN_LC375539.gbk

```
# /Users/rajaldebnath/Software/get_homologues/parse_pangenome_matrix.pl -m pangenome_matrix_t0.tab -A A.txt -B B.txt -g 1 -e 0 -p  -P 100 -S 0
# genes present in set A and absent in B (1):
592_egt.faa
```

8. Genes unique to Apro_AnprNPV-TS_KY979487.gbk

```
# /Users/rajaldebnath/Software/get_homologues/parse_pangenome_matrix.pl -m pangenome_matrix_t0.tab -A A.txt -B B.txt -g 1 -e 0 -p  -P 100 -S 0
# genes present in set A and absent in B (0):
```

9. Genes unique to Apro_TkhulenIBD_MH797002.gbk

```
# /Users/rajaldebnath/Software/get_homologues/parse_pangenome_matrix.pl -m pangenome_matrix_t0.tab -A A.txt -B B.txt -g 1 -e 0 -p  -P 100 -S 0
# genes present in set A and absent in B (1):
803_he65-like.faa
```

10. Genes unique to Aper_AnpeMNPV-L2_EF207986.gbk

```
# /Users/rajaldebnath/Software/get_homologues/parse_pangenome_matrix.pl -m pangenome_matrix_t0.tab -A A.txt -B B.txt -g 1 -e 0 -p  -P 100 -S 0
# genes present in set A and absent in B (1):
441_egt.faa
```

11. Genes unique to Aper_Anpe-CN_LC375540.gbk

```
# /Users/rajaldebnath/Software/get_homologues/parse_pangenome_matrix.pl -m pangenome_matrix_t0.tab -A A.txt -B B.txt -g 1 -e 0 -p  -P 100 -S 0
# genes present in set A and absent in B (1):
176_94k-C.faa
```

12. Genes unique to AY_Anya-JP_LC375537.gbk

```
# /Users/rajaldebnath/Software/get_homologues/parse_pangenome_matrix.pl -m pangenome_matrix_t0.tab -A A.txt -B B.txt -g 1 -e 0 -p  -P 100 -S 0
# genes present in set A and absent in B (0):
```

#### Analysis for Selective pressure on coding sequences by Ka/Ks ratio.

All the clusters generated were subjected to KaKs calculation by MA method and a comprehensive list of kaks for all the clusters were generated by merging the kaks calculation of each coding sequence. significant gene showing positive selection were filterd from the comprehensive list.   

```
for i in $(ls *.kaks); do echo $i >> comprehensive_kaks.txt; cut -f1,5,6 $i | grep -v "NA" >> comprehensive_kaks.txt; done  


for i in $(ls *.aln); do echo $i >> comprehensive_kaks_alignment.txt; cat $i >> comprehensive_kaks_alignment.txt; done
```
Lets filter the dataset to search for coding sequences which has a ka/ks value > 1 with p-value < 0.05  

```
awk '/^ID/ && $3+0 <= 0.05 && $2+0 >= 1 {print $1, $2, $3}' comprehensive_kaks.txt
```

```
ID:NP_047422.1&ID:BBD50745.1 1.16869 0.0322969
ID:NP_047422.1&ID:BBD51504.1 1.21183 0.0105251
ID:NP_047422.1&ID:BBD51200.1 1.21183 0.0105251
ID:NP_047422.1&ID:BBD51352.1 1.21183 0.0105251

Searching for this particular ID hints about the ortholog cluster "906_bv-odv-e26".
Information on this particular gene can be found here 'https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3302242/'  
```

Peeking into the multiple alignment of coding sequence of this cluster

```
906_bv-odv-e26.fna.aln
CLUSTAL O(1.2.4) multiple sequence alignment


ID:BBD50593.1       -----------------------ATGGAAATGTTGCCGCCCGCGTACTTAAAACGTGCAG
ID:BBD51052.1       -----------------------ATGGAAATGTTGCCGCCCGCGTACTTAAAACGTGCAG
ID:ABQ12362.1       -----------------------ATGGAAATGTTGCCGCCCGCGTACTTAAAACGTGCAG
ID:BBD50898.1       -----------------------ATGGAAATGTTGCCGCCCGCGTACTTAAAACGTGCAG
ID:AWD33654.1       -----------------------ATGGAAATGTTGCCGCCCGCGTACTTAAAACGTGCAG
ID:AYW35481.1       -----------------------ATGGAAATGTTGCCGCCCGCGTACTTAAAACGTGCAG
ID:NP_047422.1      ATGAATTCTGTTCACACGCGCTTATGTGCCAGTAGCAACC----AATTTGCTCCGTTCAA
ID:BBD50745.1       -----------------------ATGGAAATGTTGCCGCCCGCGTACTTAAAACGTGCAG
ID:BBD51504.1       -----------------------ATGGAAATGTTGCCGCCCGCGTACTTAAAACGTGCAG
ID:BBD51200.1       -----------------------ATGGAAATGTTGCCGCCCGCGTACTTAAAACGTGCAG
ID:BBD51352.1       -----------------------ATGGAAATGTTGCCGCCCGCGTACTTAAAACGTGCAG
                                           ***     ** **  **     * **    *** **

ID:BBD50593.1       CATCCGCCGGCGCGGT--GCGCGCCACTTTTGTAAAAACTGTTGTCACCACCA-------
ID:BBD51052.1       CATCCGCCGGCGCGGT--GCGCGCCACTTTTGTAAAAACTGTTGTCACCACCA-------
ID:ABQ12362.1       CATCCGCCGGCGCGGT--GCGCGCCACTTTTGTAAAAACTGTTGTCACCACCA-------
ID:BBD50898.1       CATCCGCCGGCGCGGT--GCGCGCCACTTTTGTAAAAACTGTTGTCACCACCA-------
ID:AWD33654.1       CATCCGCCGGCGCGGT--GCGCGCCACTTTTGTAAAAACTGTTGTCACCACCA-------
ID:AYW35481.1       CATCCGCCGGCGCGGT--GCGCGCCACTTTTGTAAAAACTGTTGTCACCACCA-------
ID:NP_047422.1      AAAGCGCCAGCTTGCCGTGCCGGTCGGTTCTGTGAACAGTTTGACGCACACCATCACTTC
ID:BBD50745.1       CATCCGCCGGCGCGGT--GCGCGCCACTTTTGTAAAAACTGTTGTCACCACCA-------
ID:BBD51504.1       CATCCGCCGGCGCGGT--GCGCGCCACTTTTGTAAAAACTGTTGTCACCACCA-------
ID:BBD51200.1       CATCCGCCGGCGCGGT--GCGCGCCACTTTTGTAAAAACTGTTGTCACCACCA-------
ID:BBD51352.1       CATCCGCCGGCGCGGT--GCGCGCCACTTTTGTAAAAACTGTTGTCACCACCA-------
                     *  **** **  *    **  * *  ** *** ** * * *      *****       

ID:BBD50593.1       --CGACG---------------GTCGAAAACCGCAGCGAAGAGCAAGATTTAATAGCGCA
ID:BBD51052.1       --CGACG---------------GTCGAAAACCGCAGCGAAGAGCAAGATTTAATAGCGCA
ID:ABQ12362.1       --CGACG---------------GTCGAAAACCGCAGCGAAGAGCAAGATTTAATAGCGCA
ID:BBD50898.1       --CGACG---------------GTCGAAAACCGCAGCGAAGAGCAAGATTTAATAGCGCA
ID:AWD33654.1       --CGACG---------------GTCGAAAACCGCAGCGAAGAGCAAGATTTAATAGCGCA
ID:AYW35481.1       --CGACG---------------GTCGAAAACCGCAGCGAAGAGCAAGATTTAATAGCGCA
ID:NP_047422.1      GACCACTGTTGCCAGTGTGATTCCAAAAAATTATCAAGAAAAACGCCAAAAAATATGCCA
ID:BBD50745.1       --CGACG---------------GTCGAAAACCGCAGCGAAGAGCAAGATTTAATAGCGCA
ID:BBD51504.1       --CGACG---------------GTCGAGAACCGCAGCGAAGAGCAAGATTTAATAGCGCA
ID:BBD51200.1       --CGACG---------------GTCGAGAACCGCAGCGAAGAGCAAGATTTAATAGCGCA
ID:BBD51352.1       --CGACG---------------GTCGAGAACCGCAGCGAAGAGCAAGATTTAATAGCGCA
                      * **                    * **       *** * *   *   ****   **

ID:BBD50593.1       AGTAATTGCGCAGCTGCAAAAGACGCGCATATGCTTCAATAAATTGTCTCGCCTGCAAAG
ID:BBD51052.1       AGTAATTGCGCAGCTGCAAAAGACGCGCATATGCTTCAATAAATTGTCTCGCCTGCAAAG
ID:ABQ12362.1       AGTAATTGCGCAGCTGCAAAAGACGCGCATATGCTTCAATAAATTGTCTCGCCTGCAAAG
ID:BBD50898.1       AGTAATTGCGCAGCTGCAAAAGACGCGCATATGCTTCAATAAATTGTCTCGCCTGCAAAG
ID:AWD33654.1       AGTAATTGCGCAGCTGCAAAAGACGCGCATATGCTTCAATAAATTGTCTCGCCTGCAAAG
ID:AYW35481.1       AGTAATTGCGCAGCTGCAAAAGACGCGCATATGCTTCAATAAATTGTCTCGCCTGCAAAG
ID:NP_047422.1      CATAATATCTTCGTTGCGTAACACGCACTTGAATTTCAATAAGATACAGTCTGTACATAA
ID:BBD50745.1       AGTAATTGCGCAGCTGCAAAAGACGCGCATATGCTTCAATAAATTGTCTCGCCTGCAAAG
ID:BBD51504.1       AGTAATTGCGCAGCTGCAAAAGACGCGCATATGTTTCAATAAATTGTCTCGCCTGCAAAG
ID:BBD51200.1       AGTAATTGCGCAGCTGCAAAAGACGCGCATATGTTTCAATAAATTGTCTCGCCTGCAAAG
ID:BBD51352.1       AGTAATTGCGCAGCTGCAAAAGACGCGCATATGTTTCAATAAATTGTCTCGCCTGCAAAG
                      ****  *   * ***  ** **** * *    ********  *        * ** *

ID:BBD50593.1       AAAGCGCGTGCGCAATATGCAAAAGCTGTTACGTAAAAAGAACACGATCATTGCCAATTT
ID:BBD51052.1       AAAGCGCGTGCGCAATATGCAAAAGCTGTTACGTAAAAAGAACACGATCATTGCCAATTT
ID:ABQ12362.1       AAAGCGCGTGCGCAATATGCAAAAGCTGTTACGTAAAAAGAACACGATCATTGCCAATTT
ID:BBD50898.1       AAAGCGCGTGCGCAATATGCAAAAGCTGTTACGTAAAAAGAACACGATCATTGCCAATTT
ID:AWD33654.1       AAAGCGCGTGCGCAATATGCAAAAGCTGTTACGTAAAAAGAACACGATCATTGCCAATTT
ID:AYW35481.1       AAAGCGCGTGCGCAATATGCAAAAGCTGTTACGTAAAAAGAACACGATCATTGCCAATTT
ID:NP_047422.1      AAAGAAACTGCTGCATTTGCAAAATTTGCTAAGGAAAAAGAACGAAATTATTGCCGAGTT
ID:BBD50745.1       AAAGCGCGTGCGCAATATGCAAAAGCTGTTACGTAAAAAGAACACGATCATTGCCAATTT
ID:BBD51504.1       AAAGCGCGTGCGCAACATGCAAAAGTTGTTACGTAAAAAGAACACGATCATTGCCAATTT
ID:BBD51200.1       AAAGCGCGTGCGCAACATGCAAAAGTTGTTACGTAAAAAGAACACGATCATTGCCAATTT
ID:BBD51352.1       AAAGCGCGTGCGCAACATGCAAAAGTTGTTACGTAAAAAGAACACGATCATTGCCAATTT
                    ****    ***   *  *******  ** ** * *********   ** ****** * **

ID:BBD50593.1       GACGGCGCAGCTAAATAATCAACAGCGGGTCAAGC-------------------------
ID:BBD51052.1       GACGGCGCAGCTAAATAACCAACAGCGGGTCAAGC-------------------------
ID:ABQ12362.1       GACGGCGCAGATAAATAACCAACAGCGGGTCAAGC-------------------------
ID:BBD50898.1       GACGGCGCAGCTAAATAACCAACAGCGGGTCAAGC-------------------------
ID:AWD33654.1       GACGGCGCAGCTAAATAACCAACAGCGGGTCAAGC-------------------------
ID:AYW35481.1       GACGGCGCAGCTAAATAACCAACAGCGGGTCAAGC-------------------------
ID:NP_047422.1      GGTTAGAAAACTCGAAAGTGCACAGAAGAAGACGACGACAACGCACAGAAATATTAGTAG
ID:BBD50745.1       GACGGCGCAGCTAAATAATCAACAGCGGGTCAAGC-------------------------
ID:BBD51504.1       GACGGCGCAGCTAGATAACCAACAGCGGGCCAAGC-------------------------
ID:BBD51200.1       GACGGCGCAGCTAGATAACCAACAGCGGGCCAAGC-------------------------
ID:BBD51352.1       GACGGCGCAGCTAGATAACCAACAGCGGGCCAAGC-------------------------
                    *       *  *  * *    ****  *   * *                          

ID:BBD50593.1       -----------------------ATTTCGCCGCGGTGCTGTGCAAAAACGTCGTGTGCAC
ID:BBD51052.1       -----------------------ATTTCGCCGCGGTGCTGTGCAAAAACGTCGTGTGCAC
ID:ABQ12362.1       -----------------------ATTTCGCCGCGGTGCTGTGCAAAAACGTCGTGTGCAC
ID:BBD50898.1       -----------------------ATTTCGCCGCGGTGCTGTGCAAAAACGTCGTGTGCAC
ID:AWD33654.1       -----------------------ATTTCGCCGCGGTGCTGTGCAAAAACGTCGTGTGCAC
ID:AYW35481.1       -----------------------ATTTCGCCGCGGTGCTGTGCAAAAACGTCGTGTGCAC
ID:NP_047422.1      TAAACCGGCTGCTCATTGGAAATACTTTGGAGTGGTCAGATGTGACAACACAATTCGCAC
ID:BBD50745.1       -----------------------ATTTCGCCGCGGTGCTGTGCAAAAACGTCGTGTGCAC
ID:BBD51504.1       -----------------------ATTTTGCCGCGGTGCTGTGCAAAAACGTCGTGTGCAC
ID:BBD51200.1       -----------------------ATTTTGCCGCGGTGCTGTGCAAAAACGTCGTGTGCAC
ID:BBD51352.1       -----------------------ATTTTGCCGCGGTGCTGTGCAAAAACGTCGTGTGCAC
                                           * ** *  * ***    **  * ***    *  ****

ID:BBD50593.1       GGTAAGCGGTTCTGAGAAATTTGTGGACAGGCGCGTCGCGGATCTGTGCGCGGCCG---G
ID:BBD51052.1       GGTAAGCGGTTCTGAGAAATTTGTGGACAGGCGCGTCGCGGATCTGTGCGCGGCCG---G
ID:ABQ12362.1       GGTAAGCGGTTCTGAGAAATTTGTGGACAGGCGCGTCGCGGATCTGTGCGCGGCCG---G
ID:BBD50898.1       GGTAAGCGGTTCTGAGAAATTTGTGGACAGGCGCGTCGCGGATCTGTGCGCGGCCG---G
ID:AWD33654.1       GGTAAGCGGTTCTGAGAAATTTGTGGACAGGCGCGTCGCGGATCTGTGCGCGGCCG---G
ID:AYW35481.1       GGTAAGCGGTTCTGAGAAATTTGTGGACAGGCGCGTCGCGGATCTGTGCGCGGCCG---G
ID:NP_047422.1      AATTATTGGCAACGAAAAGTTTGTAAGGAGACGTTTGGCCGAGCTGTGCACATTGTACAA
ID:BBD50745.1       GGTAAGCGGTTCTGAGAAATTTGTGGACAGGCGCGTCGCGGATCTGTGCGCGGCCG---G
ID:BBD51504.1       GGTGAGCGGTTCTGAGAAATTTGTGGACAGGCGCGTCGCGGATCTGTGCGCGGCCG---G
ID:BBD51200.1       GGTGAGCGGTTCTGAGAAATTTGTGGACAGGCGCGTCGCGGATCTGTGCGCGGCCG---G
ID:BBD51352.1       GGTGAGCGGTTCTGAGAAATTTGTGGACAGGCGCGTCGCGGATCTGTGCGCGGCCG---G
                      * *  **    ** ** *****    ** **  * ** ** ****** *         

ID:BBD50593.1       CGGGGAGCGGGTGTTTTGCGGCCGCCGGACGGACTGTGCGCGCGACCGTCAGCGTCTTGC
ID:BBD51052.1       CGGGGAGCGGGTGTTTTGCGGCCGCCGGACGGACTGTGCGCGCGACCGTCAGCGTCTTGC
ID:ABQ12362.1       CGGGGAGCGGGTGTTTTGCGGCCGCCGGACGGACTGTGCGCGCGACCGTCAGCGTCTTGC
ID:BBD50898.1       CGGGGAGCGGGTGTTTTGCGGCCGCCGGACGGACTGTGCGCGCGACCGTCAGCGTCTTGC
ID:AWD33654.1       CGGGGAGCGGGTGTTTTGCGGCCGCCGGACGGACTGTGCGCGCGACCGTCAGCGTCTTGC
ID:AYW35481.1       CGGGGAGCGGGTGTTTTGCGGCCGCCGGACGGACTGTGCGCGCGACCGTCAGCGTCTTGC
ID:NP_047422.1      CGCCGAGTACGTGTTTTGCCAGGCACGCGCCGATGGAGACAAAGATCGACAGGCACTAGC
ID:BBD50745.1       CGGGGAGCGGGTGTTTTGCGGCCGCCGGACGGACTGTGCGCGCGACCGTCAGCGTCTTGC
ID:BBD51504.1       CGGGGAGCGGGTGTTTTGCGGCCGCCGGACGGATTGTGCGCGCGACCGTCAGCGTCTTGC
ID:BBD51200.1       CGGGGAGCGGGTGTTTTGCGGCCGCCGGACGGATTGTGCGCGCGACCGTCAGCGTCTTGC
ID:BBD51352.1       CGGGGAGCGGGTGTTTTGCGGCCGCCGGACGGATTGTGCGCGCGACCGTCAGCGTCTTGC
                    **  ***   *********      **  * **  * *     ** ** ***   ** **

ID:BBD50593.1       AGAAGCGCTTGCGGCCTCTTTAAGGGCGGGCGTGGTGGCGCGCGCCAGCAATAAGCGGTT
ID:BBD51052.1       AGAAGCGCTTGCGGCCTCTTTAAGGGCGGGCGTGGTGGCGCGCGCCAGCAATAAGCGGTT
ID:ABQ12362.1       AGAAGCGCTTGCGGCCTCTTTAAGGGCGGGCGTGGTGGCGCGCGCCAGCAATAAGCGGTT
ID:BBD50898.1       AGAAGCGCTTGCGGCCTCTTTAAGGGCGGGCGTGGTGGCGCGCGCCAGCAATAAGCGGTT
ID:AWD33654.1       AGAAGCGCTTGCGGCCTCTTTAAGGGCGGGCGTGGTGGCGCGCGCCAGCAATAAGCGGTT
ID:AYW35481.1       AGAAGCGCTTGCGGCCTCTTTAAGGGCGGGCGTGGTGGCGCGCGCCAGCAATAAGCGGTT
ID:NP_047422.1      GAGTCTGCTGACGGCAGCGTTTGGTCCGCGAGTCATAGTTTATGAAAATAGTCGCCGGTT
ID:BBD50745.1       AGAAGCGCTTGCGGCCTCTTTAAGGGCGGGCGTGGTGGCGCGCGCCAGCAATAAGCGGTT
ID:BBD51504.1       AGAAGCGCTTGCGGCCTCTTTAAGGGCGGGCGTGGTGGCGCGCGCCAGCAATAAGCTGTT
ID:BBD51200.1       AGAAGCGCTTGCGGCCTCTTTAAGGGCGGGCGTGGTGGCGCGCGCCAGCAATAAGCTGTT
ID:BBD51352.1       AGAAGCGCTTGCGGCCTCTTTAAGGGCGGGCGTGGTGGCGCGCGCCAGCAATAAGCTGTT
                          ***  ****  * **  *  ** * **  * *     *  *  * *   * ***

ID:BBD50593.1       CAAAATCCTGGAGGCGGACAAAGTGGCGAGCGCAAAGCTGATAGTGCAGCAGGTGCTTTA
ID:BBD51052.1       CAAAATCCTGGAGGCGGACAAAGTGGCGAGCGCAAAGCTGATAGTGCAGCAGGTGCTTTA
ID:ABQ12362.1       CAAAATCCTGGAGGCGGACAAAGTGGCGAGCGCAAAGCTGATAGTGCAGCAGGTGCTTTA
ID:BBD50898.1       CAAAATCCTGGAGGCGGACAAAGTGGCGAGCGCAAAGCTGATAGTGCAGCAGGTGCTTTA
ID:AWD33654.1       CAAAATCCTGGAGGCGGACAAAGTGGCGAGCGCAAAGCTGATAGTGCAGCAGGTGCTTTA
ID:AYW35481.1       CAAAATCCTGGAGGCGGACAAAGTGGCGAGCGCAAAGCTGATAGTGCAGCAGGTGCTTTA
ID:NP_047422.1      CGAGTTTATAAATCCGGACGAGATTGCTAGCGGCAAACGTTTAATAATTAAACATTTGCA
ID:BBD50745.1       CAAAATCCTGGAGGCGGACAAAGTGGCGAGCGCAAAGCTGATAGTGCAGCAGGTGCTTTA
ID:BBD51504.1       CAAAATCTTGGAGGCGGACAAAGTGGCGAGCGCAAAGCTGATAGTGCAGCAGGTGCTTTA
ID:BBD51200.1       CAAAATCTTGGAGGCGGACAAAGTGGCGAGCGCAAAGCTGATAGTGCAGCAGGTGCTTTA
ID:BBD51352.1       CAAAATCTTGGAGGCGGACAAAGTGGCGAGCGCAAAGCTGATAGTGCAGCAGGTGCTTTA
                    * *  *  *  *  ***** *  * ** ****  ** *   ** *     *     *  *

ID:BBD50593.1       CGATGGACTTGACGGTGACGCTTGTGCCCATTAA
ID:BBD51052.1       CGATGGACTTGACGGTGACGCTTGTGCCCATTAA
ID:ABQ12362.1       CGATGGACTTGACGGTGACGCTTGTGCCCATTAA
ID:BBD50898.1       CGATGGACTTGACGGTGACGCTTGTGCCCATTAA
ID:AWD33654.1       CGATGGACTTGACGGTGACGCTTGTGCCCATTAA
ID:AYW35481.1       CGATGGACTTGACGGTGACGCTTGTGCCCATTAA
ID:NP_047422.1      AGATGAATCTCAAAGTGATATTAACGCCTATTAA
ID:BBD50745.1       CGATGGACTTGACGGTGACGCTTGTGCCCATTAA
ID:BBD51504.1       CGATGGACCTGACGGTGACGCTTGTGCCCATTAA
ID:BBD51200.1       CGATGGACCTGACGGTGACGCTTGTGCCCATTAA
ID:BBD51352.1       CGATGGACCTGACGGTGACGCTTGTGCCCATTAA
                     **** *  * *  ****   *   *** *****
```  

#### SNP analysis of NPV genomes amongst Saturniid hosts.

We are using NPV of Antheraea pernyi from China as the reference and all the other Saturniid npv genomes to align using muscle and 
```
$parsnp -g Aper_Anpe-CN_LC375540.gbk -d dir/*.fasta -p 6
```
