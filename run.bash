cd /workspace
rm -rf /workspace/axolotl
git clone https://github.com/OpenAccess-AI-Collective/axolotl.git
cd axolotl
pip install --no-deps -e .
export WANDB_API_KEY=$1
wget https://raw.githubusercontent.com/$2/Mind-upload/main/config.yml
CUDA_VISIBLE_DEVICES="" python -m axolotl.cli.preprocess config.yml
