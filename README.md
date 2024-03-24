# Mind-upload
## Preparation
### Dataset
Get your messages (or other traing materials) into a JSON file of the format:
```json
[
  {
    "segments": [
      {
        "label": false,
        "text": "<n>SYSTEM PROMPT\nPERSON A NAME: blah blah"
      },
      {
        "label": true,
        "text": "\nYOUR NAME: foo\n"
      },
      {
        "label": false,
        "text": "PERSON A NAME: ah, I see"
      },
      {
        "label": true,
        "text": "\nYOUR NAME: mhm</s>"
      }
    ]
    "segments": [
      ...
    ]
  },
]
```
Noting a few things. The first message in each `segments` should be from the other person (not you/the person you're trying to emulate) and it should have the <n> token, followed by the system prompt and a newline, prepended. All messages from you should be sandwiched between two \n's, and the last message in a series should end in a </s>. All messages that you want the model to train on (i.e. messages from you) should have a label field of true.  
This will compile to look like:  
```
<n>SYSTEM PROMPT
PERSON A NAME: blah blah
YOUR NAME: foo
PERSON A NAME: ah, I see
YOUR NAME: mhm</s>
```
Personally, I find that the system prompt `CONTEXT: Elijah, a friendly, highly intelligent, interesting, and ambitious teenager is talking to a friend.` works well. You can customize the description to mention traits you think the bot over/under represents. I replace PERSON A NAME with "friend" and YOUR NAME, obviously, with Elijah.
### Config
Now all that's left is the axolotl config. At this point you're gonna want to clon this repo. In config.yml you can obviously edit stuff like `base_model` and `num_epochs` to your liking. When you're satisfied just make sure to point the dataset path to your own dataset's huggingface locator. 
## Training and inference
To setup and train:
Create a pod (1xA40 works) with the template https://www.runpod.io/console/gpu-cloud?template=v2ickqhz9s&ref=6i7fkpdz  
Connect and run the following to set up:  
```bash
wget https://raw.githubusercontent.com/{YOUR GH USERNAME}/Mind-upload/main/run.bash && bash run.bash
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
{...}
```
The prompt must end on person A (the assistant will continue as you.)
