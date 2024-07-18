apt update -y
apt install -y  sox libsndfile1 bzip2   build-essential
pip install  --use-pep517 pytest-runner paddlepaddle==2.5.1 paddlespeech numpy==1.23.5 onnxruntime==v1.14.0 #-i https://pypi.tuna.tsinghua.edu.cn/simple 


wget -nc https://paddlespeech.bj.bcebos.com/Parakeet/tools/nltk_data.tar.gz
tar -xzf nltk_data.tar.gz -C ${HOME}