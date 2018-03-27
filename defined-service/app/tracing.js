'use strict';

var initJaegerTracer = require('jaeger-client').initTracer;

exports.initTracer = initTracer;

function initTracer(serviceName) {
    var config = {
        'serviceName': serviceName,
        'sampler': {
            'host': 'jaeger',
            'port': 6831,
            'type': 'const',
            'param': 1
        },
        'reporter': {
            'logSpans': true
        }
    };
    var options = {
        'logger': {
            'info': function logInfo(msg) {
                console.log('INFO ', msg);
            },
            'error': function logError(msg) {
                console.log('ERROR', msg)
            }
        }
    };

    const tracer = initJaegerTracer(config, options);

    //hook up nodejs process exit event
    process.on('exit', function () {
        console.log('flush out remaining span');
        tracer.close();
    });
    //handle ctrl+c
    process.on('SIGINT', function () {
        process.exit();
    });

    return tracer;
}