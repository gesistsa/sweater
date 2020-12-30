## Download the embedding file from
## https://github.com/mmihaltz/word2vec-GoogleNews-vectors

from gensim.models.word2vec import Word2Vec
from gensim.models import KeyedVectors
model = KeyedVectors.load_word2vec_format('GoogleNews-vectors-negative300.bin', binary=True)
model.wv.save_word2vec_format('googlenews.txt')
