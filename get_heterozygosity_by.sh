#!/bin/bash

if [ -z $1 ]; then
  echo "Usage: ./get_heterozygosity_by.sh <nucmer.snp> <assemblytics_structural_variants.bed> <interval>"
  echo -e "\t<interval>: ex. 50k, 500k, 1M, 5M ..."
  exit -1
fi

nucmer_snps=$1      # generated with MUMmer3.23/dnadiff
assemblytics_bed=$2 # assemblytics Assemblytics_structural_variants.bed file
interval=$3         # ex. 500k

# Transfer nucmer .snp output to bed format
echo "\
java -jar -Xmx1g nucmerSnpsToBed.jar $nucmer_snps > $nucmer_snps.bed"
java -jar -Xmx1g nucmerSnpsToBed.jar $nucmer_snps > $nucmer_snps.bed

# Add assemblytics .bed file
echo "\
cat $nucmer_snps.bed $assemblytics_bed > out.assemblytics.sv.snps"
cat $nucmer_snps.bed $assemblytics_bed > out.assemblytics.sv.snps

# Sort by coordinates. This can be replaced with bedtools sort -i out.assemblytics.sv.snps
echo "\
java -jar -Xmx4g bedSort.jar out.assemblytics.sv.snps out.assemblytics.sv.snps.bed"
java -jar -Xmx4g bedSort.jar out.assemblytics.sv.snps out.assemblytics.sv.snps.bed

echo "\
cut -f1-5 out.assemblytics.sv.snps.bed > out.assemblytics.sv.snps.simple"
cut -f1-5 out.assemblytics.sv.snps.bed > out.assemblytics.sv.snps.simple

module load bedtools/2.27.1
echo "\
bedtools merge -i out.assemblytics.sv.snps.simple -c 4,5 -o collapse,max -delim  ;  > out.assemblytics.sv.snps.simple.mrg"
bedtools merge -i out.assemblytics.sv.snps.simple -c 4,5 -o collapse,max -delim ";" > out.assemblytics.sv.snps.simple.mrg

echo "\
java -jar -Xmx1g bedSummaryByInterval.jar out.assemblytics.sv.snps.simple.mrg $interval > out.assemblytics.sv.snps.simple.mrg.interval.$interval"
java -jar -Xmx1g bedSummaryByInterval.jar out.assemblytics.sv.snps.simple.mrg $interval > out.assemblytics.sv.snps.simple.mrg.interval.$interval
