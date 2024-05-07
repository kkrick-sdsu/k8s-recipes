import sys
import itertools as it
import nltk
from nltk.corpus import stopwords

def pre_process_text(file_path):
    text = []

    # Load file contents line by line
    with open(file_path, 'r') as file:
        for line in file:
            text.append(line.strip())
    
    # Split each line into an array of words
    text = [line.split(" ") for line in text]
    text = list(it.chain.from_iterable(text))

    # Remove stopwords and newlines
    nltk.download('stopwords')
    stop_words = set(stopwords.words('english'))
    text = [word for word in text if word not in stop_words and word not in '']
    text = ' '.join(text)

    # Pre-processing complete, write out the processed file
    with open(f'processed/{file_path}.txt', 'w') as file:
        file.write(text)

def main():
    completion_index = sys.argv[1]

    # File names are in the format wiki_00 - wiki_99
    file_path_prefix = '1of2/wiki_'

    # Transform the completion_index to match file names
    if int(completion_index) < 10:
        completion_index = '0' + completion_index

    pre_process_text(file_path_prefix + completion_index)
    
if __name__ == "__main__":
    main()