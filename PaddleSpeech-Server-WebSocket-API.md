# PaddleSpeech Streaming Server WebSocket API

## 1. 流式语音识别接口
 
### 1.0 创建连接
ws api： ws://{server}:{port}/paddlespeech/asr/streaming
> http api: http://{server}:{port}/paddlespeech/asr/streaming

### 1.1 开始信号
* client 通过开始信号传入流式识别音频信息，以及解码参数

|字段 |必选|类型 |说明 |
|-----|----|----|---|
|name | 是 | string | 传入的音频名称|
|signal | 是 | string | 流式识别中命令类型 |
|nbest | 是 | int | 识别nbest参数，默认是1|

* 请求示例
```
{
"name": "test.wav",
"signal": "start",
"nbest": 1
}
```

* server 信息
server 端返回新连接的情况

|字段 |必选|类型 |说明 |
|-----|----|----|---|
|status | 是 | string | ASR服务端状态|
|signal | 是 | string | 该流式连接必要的准备工作是完成状态 |

```
{
"status": "ok", 
"signal": "server_ready"
}
```

### 1.2 数据

client和server建立连接之后，client端不断地向服务端发送数据

* client 信息
发送 PCM16 数据流到服务端

* server 信息
每发送一个数据，服务端会将该数据包解码的结果返回出来

|字段 |必选|类型 |说明 |
|-----|----|----|---|
|result | 是 | string | ASR解码的结果|


### 1.3 结束
client 发送完最后最后一个数据包之后，需要发送给服务端一个结束的命令，通知服务端销毁该链接的相关资源。

通过开始信号传入流式识别音频信息，以及解码参数

|字段 |必选|类型 |说明 |
|-----|----|----|---|
|name | 是 | string | 传入的音频名称|
|signal | 是 | string | 流式识别中命令类型 |
|nbest | 是 | int | 识别nbest参数，默认是1|

```
{
"name": "test.wav",
"signal": "end",
"nbest": 1
}
```

* server 信息

server 端信息接收到结束信息之后，将最后的结果返回出去。

|字段 |必选|类型 |说明 |
|-----|----|----|---|
|name | 是 | string | 传入的音频名称|
|signal | 是 | string | 流式识别中命令类型 |
|result | 是 | string | 最后的识别结果|

## 2. 流式语音合成接口
### 2.0 创建连接
ws api： ws://{server}:{port}/paddlespeech/tts/streaming
> http api: http://{server}:{port}/paddlespeech/tts/streaming

### 2.1 开始请求
* client 向 server 端发送开始信号，获取本次连接的标识

|字段 |必选|类型 |说明 |
|-----|----|----|---|
|task| 是 | string | tts|
|signal | 是 | string | 请求类型 |

* 请求示例
```
{
    "task": "tts",
    "signal": "start"
}
```

* server 信息
server 端返回新连接的情况

|字段 |必选|类型 |说明 |
|-----|----|----|---|
|status | 是 | int | TTS服务端状态|
|signal | 是 | string | 状态描述 |
|session | 是 | string | 本次连接的标识 |

```
{
    "status": 0, 
    "signal": "server ready"，
    "session": "UloVFXg3xjb2nIP6xH58Ms8G98vnA1thHL6snKOy"
}
```

### 2.2 数据传送
client和server建立连接之后，client端向server端发送请求。
* client 信息
发送待合成文本的base64格式数据到服务端

|字段 |必选|类型 |说明 |
|-----|----|----|---|
|text| 是 | string | 待合成文本内容 |
|spk_id| 否 | int | 发音人id，未使用到，默认：0 |


* 请求示例
```
{
    "text": "你好，欢迎使用百度飞桨语音合成服务。",
    "spk_id": 0
}
```

* server 信息
处理client端发送的请求，每产生一段音频，返回一段音频，直至返回结束。

|字段 |必选|类型 |说明 |
|-----|----|----|---|
|status| 是 | int | 返回数据包是否为最后一个包， 1表示非最后一个包，2表示最后一个包 |
|audio | 是 | string | 返回音频的base64 |

* 返回示例
```
{
    "status": 1,
    "audio": <base64>
}
```

### 2.3 结束请求
收到最后一个数据包后，需要发送给服务端一个结束的命令，通知服务端销毁该链接的相关资源。
* client 信息

|字段 |必选|类型 |说明 |
|-----|----|----|---|
|task | 是 | string | 语音任务 |
|signal | 是 | string | 请求类型 |
|session| 是 | string| 需要结束的本次连接 |

请求示例：
```
{
    "task": "tts",
    "signal": "end",
    "session": "UloVFXg3xjb2nIP6xH58Ms8G98vnA1thHL6snKOy"
}
```

* server 信息

server 端信息接收到结束信息之后，返回响应并结束连接。

|字段 |必选|类型 |说明 |
|-----|----|----|---|
|status| 是 | int | TTS服务端状态 |
|signal | 是 | string | 状态描述 |
|session | 是 | string | 断开连接的标识|

返回示例：
```bash
{
    "status": 0, 
    "signal": "connection will be closed",
    "session": "UloVFXg3xjb2nIP6xH58Ms8G98vnA1thHL6snKOy"
}
```

