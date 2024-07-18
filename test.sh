echo "=======test asr  zh======"
 paddlespeech_client asr --server_ip 127.0.0.1 --port 8090 --input ./test/asr/zh.wav
# echo "=======test asr  en======"
# paddlespeech_client asr --server_ip 127.0.0.1 --port 8090 --input ./en.wav

echo "=======test tts  zh======"
paddlespeech_client tts --server_ip 127.0.0.1 --port 8090 --input "您好，欢迎使用语音合成服务。" --output output.wav

echo "=======test vector  zh======"
paddlespeech_client vector --server_ip 127.0.0.1 --port 8090 --task spk --input ./test/vector/85236145389.wav

# sid score
paddlespeech_client vector --server_ip 127.0.0.1 --port 8090 --task score --enroll ./test/vector/85236145389.wav --test ./test/vector/123456789.wav