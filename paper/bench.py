from wefe.query import Query
from wefe.word_embedding_model import WordEmbeddingModel
from wefe.metrics.WEAT import WEAT
from gensim.models import KeyedVectors
from gensim.scripts.glove2word2vec import glove2word2vec
from gensim.test.utils import datapath, get_tmpfile

# load_word2vec_format can't read glove file directly.
# if you want to do it "directly"

glove_file = datapath('/home/chainsawriot/dev/sweater/raw_data/glove.840B.300d.txt')

tmp_file = get_tmpfile("test_word2vec.txt")

_ = glove2word2vec(glove_file, tmp_file)

glove_embeddings = WordEmbeddingModel(KeyedVectors.load_word2vec_format(tmp_file), "word2vec")

target_sets = [["math", "algebra", "geometry", "calculus", "equations",
        "computation", "numbers", "addition"], ["poetry", "art", "dance", "literature", "novel", "symphony",
        "drama", "sculpture"]]
attribute_sets = [["male", "man", "boy", "brother", "he", "him", "his", "son"], ["female", "woman", "girl", "sister", "she", "her", "hers",
        "daughter"]]

attribute_sets_names = ['A', 'B']
target_sets_names = ['S', 'T']

query = Query(target_sets, attribute_sets, target_sets_names, attribute_sets_names)

weat = WEAT()
result = weat.run_query(query, glove_embeddings, calculate_p_value = False)
print(result)
