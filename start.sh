fileName=multi_server.py
pid=$(ps -ef | grep $fileName| grep -v "grep" | awk '{print $2}')
kill -9 $pid

# 启动项目
nohup python3 $fileName > speech.log &

