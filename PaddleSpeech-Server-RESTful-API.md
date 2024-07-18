
# PaddleSpeech语音服务接口定义
 
## 1. 服务使用说明
下述定义了几种语音任务的服务接口，包括语音识别服务，语音合成服务等。
### 1.1 请求方式
如无特殊声明，统一使用`HTTP POST方法`和 `application/json`格式；除附带请求字段说明，所有的请求字段均必有。

### 1.2 返回格式

正常情况下都会返回`HTTP 200`状态码，结果同样是`application/json`格式。

|字段 | 必选 | 类型 | 说明 |  
|---|---|---|---|  
|success | 是 | bool | 表示请求成功与否 |  
|code | 是 | int | 错误码。success=true 的时候，code 必然为 0。success=false 的时候，code 为具体的错误码。 |  
|message | 是 | json | 用来描述错误信息 |  
|requestId | 是 | string | 一次请求的唯一标识，作trace用 |  
|result | 是 | json | 具体的返回内容，在每个接口会详细阐述 |

```json
{
    "success": true,
    "code": 0,
    "message": {"description": "everything is ok"},
    "requestId": "0543d7a8-87f2-451f-91b1-2b8d240170d6",
    "result": XXX // 具体返回内容，在每个接口会详细阐述。
}
```


## 2. ASR（语音识别）

### 2.1 获取ASR服务使用方式
- url:`GET /paddlespeech/asr/help`

-  返回固定 result 描述 (TODO)

```
{
    "success": true,
    "code": 0,
    "message": {"global": "success" },
    "result": {
	"description"："",
	"input": <wavfile>,
        "output": <results>
    }
}
```


### 2.2 语音识别
- url:`POST /paddlespeech/asr`
- 请求body参数  

|字段 | 必选 | 类型 | 说明 |  
|---|---|---|---|  
|audio | 是 | string | 将音频文件进行 base64编码后得到的 string |  
|audio_format | 是 | string | 合成音频文件格式，可选：pcm、wav，默认值：wav |  
|sample_rate | 是 | int | 音频的采样率，值选择 [8000, 16000]，默认与模型采样率一致 |  
|lang | 是 | string | 语种 zh_cn：中文; zh_tw: 台湾普通话； en_us：英文 |  
|punc | 否 | bool | 是否开启标点符号添加 true：开启 false：关闭（默认值）|  



- 请求示例
```
{
    "audio": "exSI6ICJlbiIsCgkgICAgInBvc2l0aW9uIjogImZhbHNlIgoJf...",
    "audio_format": "wav",
    "sample_rate": 16000,
    "lang": "zh_cn",
    "punc": 0
}
``` 


-  返回result描述

|字段 | 必选 | 类型 | 说明 | 
|---|---|---|---|
|transcription | 是 | string | asr识别结果 |


- 返回示例
```
{
    "success": true,
    "code": 0,
    "message": {"description": "success" }
    "result": {
	"transcription": "你好，飞桨"
    }
}
```




## 3. TTS（语音合成）

### 3.1 获取TTS服务使用方式
- url:`GET /paddlespeech/tts/help`

-  返回固定 result 描述

```
{
    "success": true,
    "code": 0,
    "message": {"global": "success" },
    "result": {
        "description"："",
        "input": <sentence to be synthesized>,
	"output": <wavfile>
    }
}
```

### 3.2 合成语音
- url:`POST /paddlespeech/tts`

- 请求body参数

|字段 | 必选 | 类型 | 说明 | 
|---|---|---|---|
|text | 是 | string | 待合成文本 |
|spk_id| 否 | int | 发音人id，未使用到，默认：0 |
|speed | 否 | float | 合成音频的语速，值范围：(0，3]，默认：1.0，windows 平台不支持变语速|
|volume | 否 | float | 合成音频的音量，值范围：(0，3]，默认：1.0，值过大可能会存在截幅现象 |
|sample_rate | 否 | int | 合成音频的采样率，只支持下采样，值选择 [0, 8000, 16000]，默认:0，表示与模型采样率一致 |
|save_path| 否 | string | 通过此参数，可以在合成完成后在本地保存一个音频文件，默认值：None，表示不保存音频，保存音频格式支持wav和pcm|


- 请求示例
```
{
    "text": "你好，欢迎使用百度飞桨深度学习框架！",
    "spk_id": 0,
    "speed": 1.0,
    "volume": 1.0,
    "sample_rate": 0,
    "save_path": "./tts.wav"
}
``` 



-  返回result描述

|字段 | 必选 | 类型 | 说明 | 
|---|---|---|---|
|lang | 是 | string | 待合成文本语言（zh or en） |
|spk_id| 是 | int | 发音人id |
|speed | 是 | float | 合成音频的语速，值范围：[0，3] |
|volume | 是 | float | 合成音频的音量，值范围：[0，3] |
|sample_rate | 是 | int | 合成音频的采样率 |
|duration| 是 | float| 合成音频的时长，单位为秒 |
|save_path| 是 | string | 保存的合成音频路径 |
|audio | 是 | string | 合成音频的base64 |




- 返回示例
```
{
    "success": true,
    "code": 0,
    "message": {"global": "success" }
    "result": {
	"lang": "zh",
	"spk_id": 0,
	"speed": 1.0,
	"volume": 1.0,
	"sample_rate": 24000,
        "duration": 3.6125,
	"save_path": "./tts.wav",
	"audio": "LTI1OTIuNjI1OTUwMzQsOTk2OS41NDk4..."
    }
}
```

### 3.3 使用http协议的流式语音合成
- url:`POST /paddlespeech/tts/streaming`

- 请求body参数

|字段 | 必选 | 类型 | 说明 | 
|---|---|---|---|
|text | 是 | string | 待合成文本 |
|spk_id| 否 | int | 发音人id，目前是单发音人模型，因此该参数未生效，默认：0 |


- 请求示例
```
{
    "text": "你好，欢迎使用百度飞桨深度学习框架！",
    "spk_id": 0
}
```

- 返回result描述

返回为音频经过 base64 编码的 string.


- 返回示例
```
LTI1OTIuNjI1OTUwMzQsOTk2OS41NDk4...
```



## 4. CLS（声音分类）
### 4.1 获取CLS服务使用方式
- url:`GET /paddlespeech/cls/help`

-  返回固定 result 描述 

```
{
    "success": true,
    "code": 0,
    "message": {"global": "success" },
    "result": {
        "description": "cls server",
	"input": "base64 string of wavfile",
	"output": "classification result"
    }
}
```


### 4.2 语音分类

- url:`POST /paddlespeech/cls`
- 请求body参数

|字段 | 必选 | 类型 | 说明 | 
|---|---|---|---|
|audio | 是 | string | 将音频文件进行 base64编码后得到的 string |
|topk | 否 | int | 返回top k 个分类结果，默认为1 |



- 请求示例
```
{
    "audio": "exSI6ICJlbiIsCgkgICAgInBvc2l0aW9uIjogImZhbHNlIgoJf...",
    "topk ": 2
}
``` 


-  返回result描述

|字段 | 必选 | 类型 | 说明 | 
|---|---|---|---|
|topk | 是 | int | top k 的数量 |
|results | 是 | List| 分类结果数组，从高到低排序 |

results 字段说明
|字段 | 必选 | 类型 | 说明 | 
|---|---|---|---|
|class_name| 是 | string | 类别 |
|prob | 是 | float | 为该类别的概率 |



- 返回示例
```
{
    "success": true,
    "code": 200,
    "message": {"description": "success" }
    "result": {
        topk: 2,
	results: [
	{
            "class_name":"Speech",
            "prob": 0.9027184844017029
        },
        {
            "class_name":"Narration, monologue",
            "prob": 0.17632535099983215
        }]
    }
}
```

## 5. ST（语音翻译（英-中））
TODO
## 6. Text（文本后处理）

### 6.1 获取Text服务使用方式
- url:`GET /paddlespeech/text/help`

-  返回固定 result 描述

```
{
    "success": true,
    "code": 0,
    "message": {"global": "success" },
    "result":{
            "punc_text":"The punctuation text content"
    }
}
```

### 6.2 文本后处理
- url:`POST /paddlespeech/text`

- 请求body参数

|字段 | 必选 | 类型 | 说明 | 
|---|---|---|---|
|text | 是 | string | 需要进行处理的文本内容 |


- 请求示例
```
{
    "text": "我认为跑步最重要的就是给我带来了身体健康",
}
``` 


-  返回result描述

|字段 | 必选 | 类型 | 说明 | 
|---|---|---|---|
|punc_text | 是 | string | 经过处理之后的文本|


- 返回示例
```
{
    "success": true,
    "code": 200,
    "message": {"description": "success" }
    "result": {
        "punc_text": "我认为跑步最重要的就是给我带来了身体健康。"
    }
}
```


# 错误码

**待更新完善**

|code | 类型类型 | 说明 | 
|---|---|---|
|200 | int | 服务正常 |
|400| int | 请求参数设置不正确 |
|404| int | 网址不正确 |
|500 | int | 内部错误 |
|502| int | 内部网络IO异常 |
|509 | int | 未知错误 |