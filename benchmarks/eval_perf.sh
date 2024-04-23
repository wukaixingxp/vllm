#export MODEL_REPO=meta-llama/Meta-Llama-3-70B
#export MODEL_REPO=meta-llama/Meta-Llama-3-8B

#export MODEL_REPO=meta-llama/Llama-2-7b-hf
#export MODEL_REPO=meta-llama/Llama-2-70b-hf

#Download data to benchmark folder
#wget https://huggingface.co/datasets/anon8231489123/ShareGPT_Vicuna_unfiltered/resolve/main/ShareGPT_V3_unfiltered_cleaned_split.json

# Make a folder to save logs
mkdir meta-llama
for MODEL_REPO in meta-llama/Meta-Llama-3-8B meta-llama/Llama-2-7b-hf meta-llama/Meta-Llama-3-70B meta-llama/Llama-2-70b-hf
do
  python benchmark_throughput.py \
      --backend vllm \
      --dataset ./ShareGPT_V3_unfiltered_cleaned_split.json \
      --model $MODEL_REPO \
      --trust-remote-code \
      --seed 1100 --num-prompts 1000 | tee -a "${MODEL_REPO}_1_base.log"
  for num in 2 4 8
  do
    python benchmark_throughput.py \
      --backend vllm \
      -tp $num \
      --dataset ./ShareGPT_V3_unfiltered_cleaned_split.json \
      --model $MODEL_REPO \
      --trust-remote-code \
      --seed 1100 --num-prompts 1000 | tee -a "${MODEL_REPO}_${num}_base.log"
  done
done

