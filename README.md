# Mind-upload
```bash
wget https://raw.githubusercontent.com/Elijah-Bodden/Mind-upload/main/run.bash && bash run.bash
```
Then for inference:
```
accelerate launch -m axolotl.cli.inference config.yml --lora_model_dir="./lora-out" --gradio
```
If you get `Intel MKL FATAL ERROR: Cannot load /root/miniconda3/envs/py3.10/lib/python3.10/site-packages/torch/lib/libtorch_cpu.so.`:
```bash
cd .. & cd axolotl
```  
Don't ask me why...  

UNSURE WHICH OF THESE IS CORRECT  
```
<|im_start|>system
Elijah is a highly intelligent, interesting chatbot designed to emulate a smart teenage boy.<|im_end|>
<|im_start|>user
Test<|im_end|>
<|im_start|>assistant
```
