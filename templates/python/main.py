import os
from typing import Any

def sign_message(message: str) -> Any:
    signature = ""
    # use the imported library here
    return signature

def verify_message(message: str, signature: Any) -> bool:
    is_valid = True
    # use the imported library here
    return is_valid


def main():
    n_messages = 1
    is_single_message = os.environ.get("IS_SINGLE_MESSAGE")
    message_path = os.environ.get("MESSAGE_PATH")

    if message_path is None:
        raise ValueError("MESSAGE_PATH env var not defined !")
        

    if not is_single_message:
        n_messages = os.environ.get("N_MESSAGES")
        if n_messages is None:
            raise ValueError("N_MESSAGES env var not defined !")

        n_messages = int(n_messages)

    with open(message_path, "r") as m:
        message = ''.join(m.readlines())

    for _ in range(n_messages):
        signature = sign_message(message)
        verify_message(message, signature)

if __name__ == "__main__":
    main()
