from flask import Flask,jsonify,request

from tracing import init_tracer
from opentracing.ext import tags
from opentracing.propagation import Format

app = Flask(__name__)

tracer = init_tracer('eval-service')

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

    span_ctx = tracer.extract(Format.HTTP_HEADERS, request.headers)
    span_tags = {tags.SPAN_KIND: tags.SPAN_KIND_RPC_SERVER}

    with tracer.start_span('eval-results', child_of=span_ctx, tags=span_tags) as span:
        defined = request.json['defined']
        actual = request.json['actual']
        span.log_kv({'event': 'defined', 'value': defined})
        span.log_kv({'event': 'actual', 'value': actual})

    return jsonify({'evalresults': evalresults}), 200

if __name__ == '__main__':
    app.run(host="0.0.0.0", debug=True)
