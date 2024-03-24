# Mind-upload
## Preparation
### Dataset
2-person chats work best as training data if a chat-like assistant is what you're going for, but things like essays or journals could probably also be adapted if you used in-text-signifiers like "[ESSAY]" before an essay prompt. Ultimately, you should get your data into a multi-turn JSON format like the following. I won't tell you how to do it as it will depend on the source format. Make sure that the sum of all "text" fields in a "segments" doesn't go over your context length or that example will be ignored. I find that randomly splitting runs of data (conversations) into many smaller 2-10-message-long "segments" sections helps with this and makes the model more robust to conversation length.  
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
- All messages from you should be sandwiched between two \n's, and the last message in a series should end in a \</s\>.
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
Personally, I find that the system prompt `CONTEXT: Elijah, a friendly, highly intelligent, interesting, and ambitious teenager is talking to a friend.` works well. You can customize the description to mention traits you think the bot over/under represents. I replace PERSON A NAME with "friend" and YOUR NAME, obviously, with Elijah.
Upload the dataset to huggingface and you're good to go.
### Config
Now all that's left is the axolotl config. At this point you should to clone this repo. In config.yml you can obviously edit stuff like `base_model` and `num_epochs` to your liking. When you're satisfied just make sure to point the dataset path to your own dataset's huggingface locator.  
## Training and inference
To setup and train:
Create a pod (1xA40 works) with [this template](https://www.runpod.io/console/gpu-cloud?template=v2ickqhz9s&ref=6i7fkpdz)  
Connect and run the following to set up, replacing YOUR WANDB KEY and both YOUR GH USERNAME's with the appropriate values:  
```bash
wget https://raw.githubusercontent.com/{YOUR GH USERNAME}/Mind-upload/main/run.bash {YOUR WANDB KEY} {YOUR GH USERNAME} && bash run.bash
```
If you don't want to log on Weights and Biases, delete the value `wandb_project` in config.yml and type some random bullshit for YOUR WANDB KEY  

To make sure your examples are being formatted right (after running setup script) run:  
```
wget https://raw.githubusercontent.com/{YOUR GH USERNAME}/Mind-upload/main/testformat.py
python3 testformat.py
```
To train your model, run 
```
accelerate launch -m axolotl.cli.train config.yml
```
Then for inference:
```
cd .. && cd axolotl && accelerate launch -m axolotl.cli.inference config.yml --lora_model_dir="./lora-out" --gradio
```
Then prompt in the gradio according to your template. In the case of the data formatting I mentioned above, it should look like this(no need for a \<s\> token, it gets auto-added):
```
SYSTEM PROMPT
PERSON A NAME: Blahblah
YOUR NAME: Blahblah
PERSON A NAME: Blahblah
{...}
```
The prompt must end on person A (the assistant will continue as you.)
