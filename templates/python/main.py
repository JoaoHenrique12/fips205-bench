import os
from typing import Any
import tracemalloc #HACK: bench_mem

def sign_message(message: str) -> Any:
    signature = ""
    # use the imported library here
    return signature

def verify_message(message: str, signature: Any) -> bool:
    is_valid = True
    # use the imported library here
    return is_valid


def main():
    n_messages_str = os.environ.get("N_MESSAGES", "1")
    message_path = os.environ.get("MESSAGE_PATH")

    if message_path is None:
        raise ValueError("MESSAGE_PATH env var not defined !")

    try:
        n_messages = int(n_messages_str)
    except ValueError:
        raise ValueError("N_MESSAGES must be an integer if defined!")

    tracemalloc.start() #HACK: bench_mem

    with open(message_path, "r") as m:
        message = ''.join(m.readlines())

    total_memory_sign = 0 #HACK: bench_mem
    total_memory_verify = 0 #HACK: bench_mem

    for _ in range(n_messages):
        snapshot_before_sign = tracemalloc.take_snapshot() #HACK: bench_mem
        signature = sign_message(message)
        snapshot_after_sign = tracemalloc.take_snapshot() #HACK: bench_mem

        stats_sign = snapshot_after_sign.compare_to(snapshot_before_sign, 'filename') #HACK: bench_mem
        memory_diff_sign = sum(stat.size_diff for stat in stats_sign) #HACK: bench_mem
        total_memory_sign += memory_diff_sign #HACK: bench_mem

        snapshot_before_verify = tracemalloc.take_snapshot() #HACK: bench_mem
        verify_message(message, signature)
        snapshot_after_verify = tracemalloc.take_snapshot() #HACK: bench_mem

        stats_verify = snapshot_after_verify.compare_to(snapshot_before_verify, 'filename') #HACK: bench_mem
        memory_diff_verify = sum(stat.size_diff for stat in stats_verify) #HACK: bench_mem
        total_memory_verify += memory_diff_verify #HACK: bench_mem

    input_name = os.path.basename(message_path).split('.')[0] #HACK: bench_mem
    with open(f"bench-mem-{input_name}-{n_messages}.csv", "w") as f: #HACK: bench_mem
        f.write(f"sign_message, {total_memory_sign}\n") #HACK: bench_mem
        f.write(f"verify_message, {total_memory_verify}\n") #HACK: bench_mem

if __name__ == "__main__":
    main()
