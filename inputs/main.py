from lipsum import generate_paragraphs

def generate_lorem_and_save(filename="lorem-1k.txt", num_paragraphs=1, file_size_kb=1):
    """
    Generates Lorem Ipsum text and saves it to a file with a specified size.

    Args:
        filename (str, optional): The name of the file to save the text to.
        num_paragraphs (int, optional): The number of paragraphs to generate initially.
        file_size_kb (int, optional): The target file size in kilobytes (KB).
    """
    try:
        target_bytes = file_size_kb * 1024  # Calculate target file size in bytes
        lorem_text = generate_paragraphs(count=num_paragraphs)
        text_bytes = len(lorem_text.encode('utf-8'))

        while text_bytes < target_bytes:
            lorem_text += generate_paragraphs(count=100)
            text_bytes = len(lorem_text.encode('utf-8'))

        # Truncate the text to the target size
        lorem_text = lorem_text.encode('utf-8')[:target_bytes].decode('utf-8', errors='ignore')

        with open(filename, "w", encoding="utf-8") as f:
            f.write(lorem_text)

        print(f"Successfully generated and saved {file_size_kb}KB of Lorem Ipsum text to {filename}")

    except Exception as e:
        print(f"An error occurred: {e}")
        return False

    return True


if __name__ == "__main__":
    file_sizes_kb = [1, 10, 100, 1024, 10240, 102400]  # in KB (1MB = 1024KB, 10MB = 10240KB, 100MB=102400KB)
    filenames = ["lorem-1k.txt", "lorem-10k.txt", "lorem-100k.txt", "lorem-1M.txt", "lorem-10M.txt", "lorem-100M.txt"]

    for filename, size_kb in zip(filenames, file_sizes_kb):
        generate_lorem_and_save(filename, file_size_kb=size_kb)
