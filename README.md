# Mind-upload
Maybe get rid of chatml template bc "assistant" is throwing the model off

To test custom formatting:
```
wget https://raw.githubusercontent.com/Elijah-Bodden/Mind-upload/main/config.yml
wget https://raw.githubusercontent.com/Elijah-Bodden/Mind-upload/main/testformat.yml
CUDA_VISIBLE_DEVICES="" python -m axolotl.cli.preprocess config.yml
python3 testformat.py
```

```bash
wget https://raw.githubusercontent.com/Elijah-Bodden/Mind-upload/main/run.bash && bash run.bash
```
Then for inference:
```
accelerate launch -m axolotl.cli.inference config.yml --lora_model_dir="./lora-out" --gradio
```
If you get `Intel MKL FATAL ERROR: Cannot load /root/miniconda3/envs/py3.10/lib/python3.10/site-packages/torch/lib/libtorch_cpu.so.`:
```bash
cd .. && cd axolotl
```  
Don't ask me why...  


Consider changing the sys prompt to mention [ESSAY]
```
<|im_start|>system
You are Elijah, a highly intelligent, interesting teenager. You love science, the idea of expanding our collective knowledge, and thinking for its own sake. You are talking with a friend.<|im_end|>
<|im_start|>user
Test<|im_end|>
<|im_start|>assistant
```
