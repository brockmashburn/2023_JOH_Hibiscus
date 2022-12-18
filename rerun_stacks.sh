#!/bin/bash

# to run this script
#CONDA_ENVS_DIRS="/storage1/fs1/christine.e.edwards/Active/projects/conda/envs/" CONDA_PKGS_DIRS="/storage1/fs1/christine.e.edwards/Active/projects/conda/pkgs/" LSF_DOCKER_VOLUMES="/storage1/fs1/christine.e.edwards/Active:/storage1/fs1/christine.e.edwards/Active" PATH=/opt/conda/bin:$PATH bsub -G compute-christine.e.edwards -q general -M 64GB -R "rusage[mem=64GB]" -a "docker(condaforge/mambaforge)" bash /home/b.mashburn/Hibiscus/3_Hlil/stacks_scripts/rerun_stacks.sh

source .bashrc
conda activate stacks

# set directories to simplify commands
HOME_DIR=/home/b.mashburn/Hibiscus/3_Hlil/stacks_scripts
SAMPLES_DIR=/storage1/fs1/christine.e.edwards/Active/mashburn/Hibiscus/3_Hlil/lil_samples
OUT_DIR=/storage1/fs1/christine.e.edwards/Active/mashburn/Hibiscus/3_Hlil/stacks/rerun
FILES="Hlil130 Hlil132 Hlil135 Hlil137 Hlil143 Hlil145 Hlil146 Hlil147 Hlil148 Hlil150 Hlil152 Hlil153 Hlil154 Hlil155 Hlil156 Hlil157 Hlil158 Hlil159 Hlil160 Hlil161 Hlil162 Hlil163 Hlil164 Hlil165 Hlil166 Hlil167 Hlil168 Hlil169 Hlil170 Hlil171 Hlil172 Hlil173 Hlil174 Hlil175 Hlil176 Hlil177 Hlil178 Hlil179 Hlil180 Hlil181 Hlil182 Hlil183 Hlil184 Hlil185 Hlil186 Hlil188 Hlil189 Hlil190 Hlil191 Hlil193 Hlil195 Hlil196 Hlil197 Hlil198 Hlil199 Hlil200 Hlil201 Hlil202 Hlil203 Hlil204 Hlil205 Hlil206 Hlil207 Hlil208 Hlil209 Hlil210 Hlil211 Hlil212 Hlil213 Hlil214 Hlil215 Hlil216 Hlil217 Hlil218 Hlil219 Hlil220 Hlil221 Hlil224 Hlil225 Hlil226 Hlil227 Hlil228 Hlil229 Hlil230 Hlil231 Hlil232 Hlil233 Hlil235 Hlil236 Hlil237 Hlil238 Hlil239 Hlil240 Hlil241 Hlil242 Hlil243 Hlil244 Hlil245 Hlil246 Hlil247 Hlil248 HlilNBG351 HlilNTBG260 HlilW222 HlilW223 HlilWBG226"

# run ustacks with m=3, M=1
#id=1
#for sample in $FILES
#do
#	ustacks -f $SAMPLES_DIR/${sample}.fastq.gz -o $OUT_DIR/ -i $id -m 3 -M 1 -p 16
#	let "id+=1"
#done

## Now run cstacks to compile stacks between samples. Make sure the popmap has been created and updated.
cstacks -n 2 -P $OUT_DIR -M $HOME_DIR/popmap_all -p 16
## Run sstacks
sstacks -P $OUT_DIR -M $HOME_DIR/popmap_all -p 16
## Run tsv2bam to transpose data so it is stored by locus instead of by samples
tsv2bam -P $OUT_DIR -M $HOME_DIR/popmap_all -t 16
## Run gstacks
gstacks -P $OUT_DIR -M $HOME_DIR/popmap_all -t 16
## Run populations completely unfiltered, output unfiltered VCF to use in RADstackshelpR
populations -P $OUT_DIR -M $HOME_DIR/popmap_all --vcf -t 16
