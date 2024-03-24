# Mind-upload
## Training and inference
To setup and train:
Create a pod (1xA40 works) with the template https://www.runpod.io/console/gpu-cloud?template=v2ickqhz9s&ref=6i7fkpdz  
Connect and run the following to set up:  
```bash
wget https://raw.githubusercontent.com/Elijah-Bodden/Mind-upload/main/run.bash && bash run.bash
```
To inspect the formatting of examples used in training (after running setup script):  
```
wget https://raw.githubusercontent.com/Elijah-Bodden/Mind-upload/main/testformat.py
python3 testformat.py
```
To train run `accelerate launch -m axolotl.cli.train config.yml`  
Then for inference:
```
cd .. && cd axolotl && accelerate launch -m axolotl.cli.inference config.yml --lora_model_dir="./lora-out" --gradio
```
The standard prompt form for inference is:
```
SYSTEM PROMPT
PERSON A NAME: Blahblah
YOUR NAME: Blahblah
PERSON A NAME: Blahblah
...
```

