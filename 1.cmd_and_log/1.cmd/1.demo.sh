#创建并进入docker
docker run --gpus all -v /home:/home   --network host  -itd --privileged  --ipc=host  --name my_cuda-12.2.2  nvidia/cuda:12.2.2-cudnn8-devel-ubuntu22.04
docker exec -it my_cuda-12.2.2 /bin/bash
 
# 查看cuda版本
nvcc --version
 
#下载代码
git clone https://github.com/ggerganov/llama.cpp.git
cd llama.cpp
 
#切换到 release b2755 版本。
git checkout b2775
 
# 编译cuda版本
make LLAMA_CUDA=1
 
# 从huggingface下载模型文件,并放到 models/chinese-llama-2-7b/ 文件夹内
# 需要的模型文件如下所示：
cd ./models/chinese-llama-2-7b/
ll 
total 13534712
drwxr-xr-x 2 1011 1012        4096 Apr 30 11:29 ./
drwxrwxr-x 4 1011 1012        4096 Apr 30 11:28 ../
-rw-r--r-- 1 1011 1012         577 Apr 30 11:28 config.json
-rw-r--r-- 1 1011 1012         131 Apr 30 11:28 generation_config.json
-rw-r--r-- 1 1011 1012 10167475414 Apr 30 11:29 pytorch_model-00001-of-00002.bin
-rw-r--r-- 1 1011 1012  3691156371 Apr 30 11:29 pytorch_model-00002-of-00002.bin
-rw-r--r-- 1 1011 1012       26787 Apr 30 11:29 pytorch_model.bin.index.json
-rw-r--r-- 1 1011 1012         435 Apr 30 11:29 special_tokens_map.json
-rw-r--r-- 1 1011 1012      844403 Apr 30 11:29 tokenizer.model
-rw-r--r-- 1 1011 1012         766 Apr 30 11:29 tokenizer_config.json
 
# 将模型转为GGUF的FP16格式
python3 convert.py models/chinese-llama-2-7b/  --outfile ./models/chinese-llama-2-7b/ggml-model-f16.gguf
 
# 使用fp16格式在cpu上进行推理
./main -m ./models/chinese-llama-2-7b/ggml-model-f16.gguf -n 64 --prompt "很久很久以前，有一个"
 
 
# 使用fp16格式在gpu上进行推理
./main -m ./models/chinese-llama-2-7b/ggml-model-f16.gguf -n 64 --n_gpu_layers 100 --prompt "很久很久以前，有一个"
 
 
