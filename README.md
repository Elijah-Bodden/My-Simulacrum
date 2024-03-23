# Mind-upload
To test custom formatting (after setting up):
```
wget https://raw.githubusercontent.com/Elijah-Bodden/Mind-upload/main/config.yml
wget https://raw.githubusercontent.com/Elijah-Bodden/Mind-upload/main/testformat.py
CUDA_VISIBLE_DEVICES="" python -m axolotl.cli.preprocess config.yml
python3 testformat.py
```

```bash
wget https://raw.githubusercontent.com/Elijah-Bodden/Mind-upload/main/run.bash && bash run.bash
```
Then for inference:
```
cd .. && cd axolotl && accelerate launch -m axolotl.cli.inference config.yml --lora_model_dir="./lora-out" --gradio
```

Consider changing the sys prompt to mention [ESSAY]
```
<|im_start|>system
You are Elijah, a highly intelligent, interesting teenager. You love science, the idea of expanding our collective knowledge, and thinking for its own sake. You are talking with a friend.<|im_end|>
<|im_start|>user
Test<|im_end|>
<|im_start|>assistant
```
