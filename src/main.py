#from sanic import Sanic, response
#from encoder import json
from sanic import Sanic
from sanic.response import json

from word2vec import model

app = Sanic(__name__)

# model = {
#     'dog': 'cat',
#     'bacon': 'prosciutto'
# }

@app.route("/")
async def test(request):
    return json({"hello": "world"})

@app.route("/word2vec")
async def word2vec(request):
    word = request.args['word'][0]

    if word in model:
        return json({ 'data': [x.astype(float) for x in model[word]] })

    return response.json(
        {'message': '404 Not Found'},
        status=404
    )

@app.route('/words2vec', methods=['POST'])
async def words2vec(request):
    if 'words' not in request.json:
        return response.json({
            'message': 'Please provide array of words as body assigned to the key words'
        }, status=400)

    words = request.json['words']
    print(f'Received request with {len(words)} words')

    data = ((x, [y.astype(float) for y in model[x]]) if x in model else None for x in words)
    print(f'Returning  word2vec vectors')

    data_l = [x for x in data]
    return json({'data':data_l})



if __name__ == "__main__":
    app.run(host="0.0.0.0", port=18000)
