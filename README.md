# My-Simulacrum
## Preparation
### Dataset
2-person chats work best as training data if you're going for a chat-like assistant, but you could probably also adapt things like essays or journals. You'll want a LOT of data, the more you can get the better. Ideally aim for a few hundred thousand tokens or more.  
You should get your data into a multi-turn JSON format like the following. I won't tell you how to do it as that will depend on the source format.  
Make sure that the sum of all "text" fields in a "segments" doesn't go over your context length or that example will be ignored. I find that randomly splitting runs of data (conversations) into many smaller 2-10-message-long "segments" sections helps with this and makes the model more robust to conversation length.  
```json
[
  {
    "segments": [
      {
        "label": false,
        "text": "<s>SYSTEM PROMPT\nPERSON A NAME: blah blah"
      },
      {
        "label": true,
        "text": "\nYOUR NAME: foo\n"
      },
      {
        "label": false,
        "text": "PERSON A NAME: ah, I see\nthis is a second line"
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
A few notes:
- The first message in each `segments` should be from the other person (not you/the person you're trying to emulate) and it should have the \<s\> token, followed by the system prompt and a newline, prepended.
- All messages from you should be sandwiched between two \n's. Add an \</s\> before the last one.
- If one person sends multiple messages in a row, I keep them in one "text" block with newlines between them.
- All messages that you want the model to train on (i.e. messages from you) should have a label field value of true.

This will compile to look like:  
```
<n>SYSTEM PROMPT
PERSON A NAME: blah blah
YOUR NAME: foo
PERSON A NAME: ah, I see
YOUR NAME: mhm</s>
```
### Format and system prompt
As you may have noticed, all the templating/structure is given in the data, and the consecutive "text" fields just get concatenated together - we're going template free. This is because all axolotl templates refer to the llm as "assistant" or similar, which throws it off. See [here](https://openaccess-ai-collective.github.io/axolotl/docs/input_output.html) for more info on template-free formatting with axolotl.  
I've found two kinds of system prompt work well. You can either summarize attributes that you want the model to emphasize (e.g. `CONTEXT: Elijah, a friendly, highly intelligent, interesting, and ambitious teenager is talking to a friend.`) or you can give a longer summary with some factual data and lots of pointers to help it identify the "type of person" you are (e.g `CONTEXT: Elijah is a friendly, highly intelligent, interesting, and ambitious 16 year old. His family are fundamentalist evangelicals but he is a militant atheist/non-theistic naturalist. He is a post-rationalist, skeptic, and transhumanist and loves ideas. He started homeschooling last year and is very interested in AI, cosmology, physics, philosophy, and biotech, and enjoys deep conversations and debates. He loves knowledge and deep questions. He is talking with a friend.`) - basically just make a brief intro to yourself. The first way works well enough for personality, but the model will make lots of annoying factual hallucinations. The second mostly fixes this (and sometimes gives better loss) if you have a good enough prompt, but you risk making the model constantly lean on stereotypes that don't perfectly reflect you.  
Now upload the dataset to huggingface and you're good to go.
### Config
Now all that's left is the axolotl config. At this point you should to clone this repo. In config.yml you can obviously edit stuff like `base_model` and `num_epochs` to your liking. When you're satisfied just make sure to point the dataset path to your own dataset ([hf username]/[dataset name]).  
## Training and inference
To set up and train:
Create a pod (1xA40 works) with [this template](https://www.runpod.io/console/gpu-cloud?template=v2ickqhz9s&ref=6i7fkpdz)  
Connect and run the following to set up, replacing both {YOUR GH USERNAME}'s with the appropriate value:  
```bash
wget https://raw.githubusercontent.com/{YOUR GH USERNAME}/My-Simulacrum/main/run.bash && bash run.bash {YOUR GH USERNAME}
```
To make sure your examples are being formatted right (after running setup script) run:  
```
cd .. && cd axolotl
wget https://raw.githubusercontent.com/{YOUR GH USERNAME}/My-Simulacrum/main/testformat.py
python3 testformat.py
```
Note: in general if you get unexplained errors, try cd-ing out of and back into the axolotl directory. No idea why this happens but it does.  
and check the output.  
To train your model, run 
```
accelerate launch -m axolotl.cli.train config.yml
```
You may want to monitor your loss curve to stop before overfitting occurs. You can ctrl-C to stop early.  
Then for inference:
```
cd .. && cd axolotl && accelerate launch -m axolotl.cli.inference config.yml --lora_model_dir="./lora-out" --gradio
```
Then prompt in the gradio according to your template. In the case of the data formatting I mentioned above, it should look like this (no need for a \<s\> token, it gets auto-added):
```
SYSTEM PROMPT
PERSON A NAME: Blahblah
YOUR NAME: Blahblah
PERSON A NAME: Blahblah
YOUR NAME:
```
## Merging and uploading to huggingface
You can merge the lora into the base and upload to huggingface with the following. Now you should be able to use your model with transformers anywhere.
```
python3 -m axolotl.cli.merge_lora your_config.yml --lora_model_dir="./lora-out"
huggingface-cli login
huggingface-cli upload ./lora-out/merged
```

