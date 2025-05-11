import os
import time
from typing import Any, Tuple

def sign_message_entrypoint(message: str) -> Any:
    signature = ""
    # implement the foreign code here
    return signature

def verify_message_entrypoint(message: str, signature: Any) -> bool:
    is_valid = True
    # implement the foreign code here
    return is_valid


def read_env_vars() -> Tuple[str, int, str]:
    n_messages_str = os.environ.get("N_MESSAGES", "1")
    message_path = os.environ.get("MESSAGE_PATH")
    profilingType = os.environ.get("PROFILING_TYPE")

    if message_path is None:
        raise ValueError("MESSAGE_PATH env var not defined !")

    if profilingType != "mem" and profilingType != "cpu":
        raise ValueError("PROFILING_TYPE env var validation error! options available: [mem|cpu]")

    try:
        n_messages = int(n_messages_str)
    except ValueError:
        raise ValueError("N_MESSAGES must be an integer if defined!")

    return message_path, n_messages, profilingType

def get_output_file_name_csv(message_path: str, n_messages: int, profilingType: str) -> str:
    base_name = os.path.basename(message_path).split('.')[0]
    output_file_name = "bench-{}-{}-{}.csv".format(profilingType, base_name, n_messages)
    return output_file_name

def main():
    message_path, n_messages, profilingType = read_env_vars()
    csv_file_name = get_output_file_name_csv(message_path, n_messages, profilingType)

    with open(message_path, "r") as m:
        message = ''.join(m.readlines())


    if profilingType == "cpu":
        time_sign_message = 0
        time_verify_message = 0
        start = 0
        for _ in range(n_messages):
            start = time.perf_counter()
            signature = sign_message_entrypoint(message)
            time_sign_message += time.perf_counter() - start

            start = time.perf_counter()
            verify_message_entrypoint(message, signature)
            time_verify_message += time.perf_counter() - start
        with open(csv_file_name, 'w') as f:
            f.write(f"sign_message, {time_sign_message:.2f}\n")
            f.write(f"verify_message, {time_verify_message:.2f}\n")
    else:
        import tracemalloc
        tracemalloc.start()
        max_memory_sign = 0
        max_memory_verify = 0

        for _ in range(n_messages):
            snapshot_before_sign = tracemalloc.take_snapshot()
            signature = sign_message_entrypoint(message)
            snapshot_after_sign = tracemalloc.take_snapshot()

            stats_sign = snapshot_after_sign.compare_to(snapshot_before_sign, 'filename')
            memory_used_sign = sum(stat.size_diff for stat in stats_sign)
            max_memory_sign = max([max_memory_sign, memory_used_sign])

            snapshot_before_verify = tracemalloc.take_snapshot()
            verify_message_entrypoint(message, signature)
            snapshot_after_verify = tracemalloc.take_snapshot()

            stats_verify = snapshot_after_verify.compare_to(snapshot_before_verify, 'filename')
            memory_diff_verify = sum(stat.size_diff for stat in stats_verify)
            max_memory_verify = max([max_memory_verify, memory_diff_verify])

            with open(csv_file_name, 'w') as f:
                f.write(f"sign_message, {max_memory_sign}\n")
                f.write(f"verify_message, {max_memory_verify}\n")

if __name__ == "__main__":
    main()
