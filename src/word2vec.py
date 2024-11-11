import os
from gensim.models import KeyedVectors

# Load pretrained model (since intermediate data is not included, the model cannot be refined with additional data)
vector_file = os.getenv("VECTOR_FILE",
                        "/opt/data/GoogleNews-vectors-negative300.bin")
binary = bool(os.getenv("BINARY_VECTOR_FILE", "true" if ".bin" in vector_file else "false").lower() == "true")

model = KeyedVectors.load_word2vec_format(
    vector_file,
    binary=binary)
