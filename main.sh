#!/usr/bin/env bash

fastq=$1
exp=$2
datadir=~/Work/dataset/WGS/$exp
refgen=~/Work/genomes/Homo_sapiens.GRCh37.dna.primary_assembly.fa/GRCh37.fa # full path to reference genome
numbproc=24
quality=30

echo "Processing " $exp 
mkdir -p $datadir
echo "Trimming ..."
/home/garner1/anaconda2/envs/mypython3/bin/cutadapt -j $numbproc -a AGATCGGAAGAGCACACGTCTGAACTCCAGTCAC -o $datadir/$exp.trimmed.fastq.gz $fastq > $datadir/trim.log
echo "Aligning ..."
bwa mem -v 1 -t $numbproc $refgen $datadir/$exp.trimmed.fastq.gz | samtools view -h -Sb -q $quality - > $datadir/$exp.bam 
samtools sort $datadir/$exp.bam  -o $datadir/$exp.sorted.bam
mv $datadir/$exp.sorted.bam $datadir/$exp.bam 
samtools index $datadir/$exp.bam 
echo "Done!"
echo
