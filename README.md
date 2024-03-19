# Mind-upload
```bash
wget https://raw.githubusercontent.com/Elijah-Bodden/Mind-upload/main/run.bash && bash run.bash
```
If you get `Intel MKL FATAL ERROR: Cannot load /root/miniconda3/envs/py3.10/lib/python3.10/site-packages/torch/lib/libtorch_cpu.so.`:
```bash
conda install nomkl numpy scipy scikit-learn numexpr
```
