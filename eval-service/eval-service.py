from flask import Flask,jsonify,request

app = Flask(__name__)


evalresults = [
    {
        'item': u'Item1',
        'reason': u'Reason1',
        'isCompliant': False
    },
    {
        'item': u'Item2',
        'reason': u'Reason2',
        'isCompliant': False
    }
]

@app.route('/')
def ping_api():
    return 'evaluate is up!'


@app.route('/api/evalresults', methods=['GET'])
def get_evalresults():
    return jsonify({'evalresults': evalresults})


@app.route('/api/evalresults', methods=['POST'])
def eval_results():

    defined = request.json['defined']
    actual = request.json['actual']
    return jsonify({'evalresults': evalresults}), 200

if __name__ == '__main__':
    app.run()
