cd /workspace
rm -rf /workspace/axolotl
git clone https://github.com/OpenAccess-AI-Collective/axolotl.git
cd axolotl
pip install --no-deps -e .
wget https://raw.githubusercontent.com/$1/My-Simulacrum/main/config.yml
CUDA_VISIBLE_DEVICES="" python -m axolotl.cli.preprocess config.yml
