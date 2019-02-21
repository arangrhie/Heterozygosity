#!/bin/bash

if [[ -z $1 ]] || [[ -z $2 ]]; then
  echo "Usage: ./nucmer.sh <ref.fasta> <qry.fasta>"
  exit -1
fi

mummer_path=/path/to/MUMmer3.23/nucmer

ref=$1    # ref.fasta
qry=$2    # qry.fasta

ref_prefix=`basename $ref`
ref_prefix=${ref_prefix/.fasta/}
qry_prefix=`basename $qry`
qry_prefix=${qry_prefix/.fasta/}

prefix=${qry_prefix}_to_${ref_prefix}
mkdir $prefix
out=$prefix/$prefix

echo "
$mummer_path/nucmer -p=$out $ref $qry"
$mummer_path/MUMmer3.23/nucmer -p=$out $ref $qry

echo "
$mummer_path/MUMmer3.23/dnadiff -p $out.dnadiff -d $out.delta"
$mummer_path/MUMmer3.23/dnadiff -p $out.dnadiff -d $out.delta

echo "
$mummer_path/MUMmer3.23/mummerplot -p $out.dnadiff.plot.1 -layout --fat -t png $out.dnadiff.1delta"
$mummer_path/MUMmer3.23/mummerplot -p $out.dnadiff.plot.1 -layout --fat -t png $out.dnadiff.1delta
