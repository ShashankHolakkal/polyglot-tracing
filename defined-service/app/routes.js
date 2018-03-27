
// Importing the tracer libraries and constants
const initTracer = require('./tracing').initTracer;
const openTracing = require('opentracing');
const Tags = openTracing.Tags;
const FORMAT_HTTP_HEADERS = openTracing.FORMAT_HTTP_HEADERS;

// Initializing the tracer
const tracer = initTracer('defined-service');

module.exports = function (app) {

    // server routes ===========================================================
    // handle things like api calls
    // authentication routes

    // sample api route
    app.get('/api/definition', function (req, res) {

        const parentSpanContext = tracer.extract(FORMAT_HTTP_HEADERS, req.headers);
        var tags = {};
        tags[Tags.SPAN_KIND] = Tags.SPAN_KIND_RPC_SERVER;

        const span = tracer.startSpan('definition-fetch', {
            childOf: parentSpanContext,
            tags: tags
        });

        var result = {"version": "2.5"};

        span.log({
            'event': 'definition_obtained',
            'value': result
        });

        console.log(result);
        span.finish();
        res.json(result);

    });

};