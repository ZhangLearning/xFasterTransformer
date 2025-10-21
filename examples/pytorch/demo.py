# Copyright (c) 2023-2024 Intel Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ============================================================================
import os
import sys
from typing import Tuple, List

# Ignore Tensor-RT warning from huggingface
os.environ["TF_CPP_MIN_LOG_LEVEL"] = "2"

import torch
import time
import json
import traceback
import transformers
from transformers import AutoTokenizer, TextStreamer
from transformers import PreTrainedTokenizer

import argparse


def boolean_string(string):
    low_string = string.lower()
    if low_string not in {"false", "true"}:
        raise ValueError("Not a valid boolean string")
    return low_string == "true"


DTYPE_LIST = [
    "fp16",
    "bf16",
    "int8",
    "w8a8",
    "int4",
    "nf4",
    "bf16_fp16",
    "bf16_int8",
    "bf16_w8a8",
    "bf16_int4",
    "bf16_nf4",
    "w8a8_int8",
    "w8a8_int4",
    "w8a8_nf4",
    "fp8_e4m3",
]

KVCACHE_DTYPE_LIST = ["fp16", "bf16", "int8"]

parser = argparse.ArgumentParser()
parser.add_argument("-t", "--token_path", type=str, 
                    # default="/data/Qwen3-30B-A3B", 
                    default="/home/harvey/dev_workspace/models/DeepSeek-R1-Distill-Qwen-1.5B", 
                    # default="/home/harvey/dev_workspace/models/Qwen1.5-0.5B-Chat-autogptq-4bit", 
                    help="Path to token file")
parser.add_argument("-m", "--model_path", type=str, 
                    # default="/data/Qwen3-30B-A3B-xft", 
                    default="/home/harvey/dev_workspace/models/DeepSeek-R1-Distill-Qwen-1.5B-fp16-xft", 
                    # default="/home/harvey/dev_workspace/models/Qwen1.5-0.5B-Chat-autogptq-fp16-4bit-xft", 
                    help="Path to model file")
parser.add_argument("-d", "--dtype", type=str, choices=DTYPE_LIST, default="int4", help="Data type")
parser.add_argument("--kv_cache_dtype", type=str, choices=KVCACHE_DTYPE_LIST, default="fp16", help="KV cache dtype")
parser.add_argument("--padding", help="Enable padding, Default to True.", type=boolean_string, default=True)
parser.add_argument("--streaming", help="Streaming output, Default to True.", type=boolean_string, default=False)
parser.add_argument("--num_beams", help="Num of beams, default to 1 which is greedy search.", type=int, default=1)
parser.add_argument("-o", "--output_len", help="max tokens can generate excluded input.", type=int, default=100)
parser.add_argument("--chat", help="Enable chat mode, Default to True.", type=boolean_string, default=True)
parser.add_argument("--do_sample", help="Enable sampling search, Default to False.", type=boolean_string, default=False)
parser.add_argument("--temperature", help="value used to modulate next token probabilities.", type=float, default=1.0)
parser.add_argument("--top_p", help="retain minimal tokens above topP threshold.", type=float, default=1.0)
parser.add_argument("--top_k", help="num of highest probability tokens to keep for generation", type=int, default=50)
parser.add_argument("--rep_penalty", help="param for repetition penalty. 1.0 means no penalty", type=float, default=1.0)


def check_transformers_version_compatibility(token_path):
    config_path = os.path.join(token_path, "config.json")
    try:
        with open(config_path, "r") as file:
            config_data = json.load(file)

        transformers_version = config_data.get("transformers_version")
    except Exception as e:
        pass
    else:
        if transformers_version:
            if transformers.__version__ != transformers_version:
                print(
                    f"[Warning] The version of `transformers` in model configuration is {transformers_version}, and version installed is {transformers.__version__}. "
                    + "This tokenizer loading error may be caused by transformers version compatibility. "
                    + f"You can downgrade or reinstall transformers by `pip install transformers=={transformers_version} --force-reinstall` and try again."
                )

print(f"Python executable: {sys.executable}")
print(f"env LD_LIBRARY_PATH: {os.environ.get('LD_LIBRARY_PATH')}")

import importlib.util

xft_spec = importlib.util.find_spec("xfastertransformer")

if xft_spec is None:
    sys.path.append("../../src")
    print("[INFO] xfastertransformer is not installed in pip, using source code.")
else:
    print("[INFO] xfastertransformer is installed, using pip installed package.")

import xfastertransformer

DEFAULT_PROMPT = "who are you?"

if __name__ == "__main__":
    args = parser.parse_args()

    try:
        tokenizer = AutoTokenizer.from_pretrained(
            args.token_path, padding_side="left", trust_remote_code=True
        )
    except Exception as e:
        traceback.print_exc()
        print("[ERROR] An exception occurred during the tokenizer loading process.")
        # print(f"{type(e).__name__}: {str(e)}")
        check_transformers_version_compatibility(args.token_path)
        sys.exit(-1)

    model = xfastertransformer.AutoModel.from_pretrained(
        args.model_path, dtype=args.dtype, kv_cache_dtype=args.kv_cache_dtype
    )
    streamer = None
    stop_words_ids = None
    if model.rank == 0 and args.num_beams == 1:
        streamer = TextStreamer(tokenizer, skip_special_tokens=True, skip_prompt=args.chat)

    if model.rank == 0:
        # Master
    
        input_prompt = "who are you?"
        print("[Use default prompt]:" + input_prompt)

        if args.chat:
            input_prompt = tokenizer.apply_chat_template(
                [{"role": "user", "content": input_prompt}], add_generation_prompt=True, tokenize=False
            )
            input_ids = tokenizer.encode(input_prompt, return_tensors="pt", padding=args.padding)
            # stop_words_ids = [[151643]]
            print(f"this is chat")
            print("input_ids", input_ids)
        elif "deepseek" in args.model_path.lower():
            print(f"this is deepseek")
            input_ids = tokenizer(input_prompt, return_tensors="pt", padding=args.padding).input_ids
            stop_words_ids = [[151643]]
        else:
            input_ids = tokenizer(input_prompt, return_tensors="pt", padding=args.padding).input_ids
        print("=" * 50)
        

        start_time = time.perf_counter()
        generated_ids = model.generate(
            input_ids,
            max_length=input_ids.shape[-1] + args.output_len,
            streamer=streamer,
            num_beams=args.num_beams,
            stop_words_ids=stop_words_ids,
            do_sample=args.do_sample,
            temperature=args.temperature,
            top_k=args.top_k,
            top_p=args.top_p,
            repetition_penalty=args.rep_penalty,
            use_cache=True,
        )
        end_time = time.perf_counter()

        if streamer is None:
            ret = tokenizer.batch_decode(generated_ids, skip_special_tokens=True)
            for snt in ret:
                print(snt)
        print("=" * 20 + "Performance" + "=" * 20)
        execution_time = end_time - start_time
        print(f"Execution time:\t{execution_time:.2f} s")
        input_token_nums = torch.numel(input_ids)
        output_token_nums = torch.numel(generated_ids) - input_token_nums
        latency = execution_time * 1000 / output_token_nums
        througput = output_token_nums / execution_time
        print(f"Latency:\t{latency:.2f} ms/token")
        print(f"Througput:\t{througput:.2f} tokens/s")
    else:
        # Slave
        while True:
            model.generate()
