# Word2Vec as a service [![Build Status](https://travis-ci.org/vampolo/word2vec-service.svg?branch=master)](https://travis-ci.org/vampolo/word2vec-service)

# Why this project ?

Word2Vec is a popular model family used in datascience. To be meaningful, it requires a model of millions of words. Loading those models in a normal laptop can take a hit on ram usage.
Why not providing a word2vec implementation trained on the [ GoogleNews-vectors-negative300 ](https://code.google.com/archive/p/word2vec/) dataset as a service ?
Just hit the `/word2vec?word=something` of this service ad you will get your word vector

# Build and run it

```
sudo docker compose up -d --build
```

# Just run it

```
sudo docker compose up 
sudo docker compose stop <id of container>
```

You can send GET requests to  http://localhost:<PORT>/word2vec?word=something and you will get the array of the word you selected.

You can also send POST requests to http://localhost:<PORT>/words2vec

For example:
```
import requests

import requests, json 
vec_l = None
try:
    r = requests.post('http://triads-dl.dbmi.pitt.edu:18000/words2vec', json={'words':words})
    if r.status_code == 200:
        print('Vectors retrieved. Loading...')
        vec_l = json.loads(r.text)
except KeyError:
    print(f'ERROR - could not retrieve vectors - status code: {r.status_code}')

word2Ind = {}
M = []
i = 0
for w in words:
    if i == len(vec_l["data"]):
        break 
    M.append(vec_l["data"][i][1])
    word2Ind[w] = i
    i += 1
```
