#/bin/bash

# to run this script
#CONDA_ENVS_DIRS="/storage1/fs1/christine.e.edwards/Active/projects/conda/envs/" CONDA_PKGS_DIRS="/storage1/fs1/christine.e.edwards/Active/projects/conda/pkgs/" LSF_DOCKER_VOLUMES="/storage1/fs1/christine.e.edwards/Active:/storage1/fs1/christine.e.edwards/Active" PATH=/opt/conda/bin:$PATH bsub -G compute-christine.e.edwards -q general -M 128GB -R "rusage[mem=128GB]" -a "docker(continuumio/miniconda3:latest)" bash /home/b.mashburn/Hibiscus/3_Hlil/stacks_scripts/stacks_Rtest.sh

source .bashrc
conda activate stacks

# set directories to simplify commands
HOME_DIR=/home/b.mashburn/Hibiscus/3_Hlil/stacks_scripts
SAMPLES_DIR=/storage1/fs1/christine.e.edwards/Active/mashburn/Hibiscus/3_Hlil/lil_samples
OUT_DIR=/storage1/fs1/christine.e.edwards/Active/mashburn/Hibiscus/3_Hlil/stacks/Rtest
FILES="Hlil_130 Hlil_132 Hlil_135 Hlil_137 Hlil_143 Hlil_145 Hlil_146 Hlil_147 Hlil_148 Hlil_150 Hlil_152 Hlil_153 Hlil_154 Hlil_155 Hlil_156 Hlil_157 Hlil_158 Hlil_159 Hlil_160 Hlil_161 Hlil_162 Hlil_163 Hlil_164 Hlil_165 Hlil_166 Hlil_168 Hlil_169 Hlil_173 Hlil_174 Hlil_175 Hlil_176 Hlil_177 Hlil_178 Hlil_179 Hlil_180 Hlil_181 Hlil_182 Hlil_183 Hlil_184 Hlil_185 Hlil_186 Hlil_188 Hlil_189 Hlil_190 Hlil_191 Hlil_193 Hlil_195 Hlil_196 Hlil_197 Hlil_198 Hlil_199 Hlil_200 Hlil_201 Hlil_202 Hlil_203 Hlil_204 Hlil_205 Hlil_206 Hlil_207 Hlil_208 Hlil_209 Hlil_210 Hlil_211 Hlil_212 Hlil_213 Hlil_214 Hlil_215 Hlil_216 Hlil_217 Hlil_218 Hlil_219 Hlil_220 Hlil_221 Hlil_224 Hlil_225 Hlil_226 Hlil_227 Hlil_228 Hlil_229 Hlil_230 Hlil_231 Hlil_232 Hlil_233 Hlil_235 Hlil_236 Hlil_237 Hlil_238 Hlil_239 Hlil_240 Hlil_241 Hlil_242 Hlil_243 Hlil_244 Hlil_245 Hlil_246 Hlil_247 Hlil_248 Hlil_NBG_351 Hlil_NC_167 Hlil_NC_170 Hlil_NC_171 Hlil_NC_172 Hlil_NTBG_260 Hlil_W_222 Hlil_W_223 Hlil_WBG_226"

# Build loci de novo in each sample for the single-end reads.

id=1
for sample in $FILES
do
	ustacks -f $SAMPLES_DIR/${sample}.fastq.gz -o $OUT_DIR/files -i $id -m 3 -M 1 -p 16
	let "id+=1"
done

## Now run cstacks to compile stacks between samples. Make sure the popmap has been created and updated.
cstacks -n 2 -P $OUT_DIR/files -M $HOME_DIR/popmap_all -p 16
## Run sstacks
sstacks -P $OUT_DIR/files -M $HOME_DIR/popmap_all -p 16
## Run tsv2bam to transpose data so it is stored by locus instead of by samples
tsv2bam -P $OUT_DIR/files -M $HOME_DIR/popmap_all -t 16
## Run gstacks
gstacks -P $OUT_DIR/files -M $HOME_DIR/popmap_all -t 16

Rvalues="0.5 0.6 0.7"

for i in $Rvalues
do
	mkdir $OUT_DIR/storage1/fs1/christine.e.edwards/Active/mashburn/Hibiscus/3_Hlil/stacks/Rtest/stacks_R$i
	populations -P $OUT_DIR/files -O $OUT_DIR/stacks_R$i -M $HOME_DIR/popmap_all -R $i --min-mac 2 --max-obs-het 0.8 --write_single-snp --hwe --fstats --smooth --structure --vcf -t 16 
done
