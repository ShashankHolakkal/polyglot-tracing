package util;

import com.uber.jaeger.Configuration;
import com.uber.jaeger.Configuration.ReporterConfiguration;
import com.uber.jaeger.Configuration.SamplerConfiguration;
import io.opentracing.Scope;
import io.opentracing.SpanContext;
import io.opentracing.Tracer;
import io.opentracing.propagation.Format;
import io.opentracing.propagation.TextMapExtractAdapter;
import io.opentracing.tag.Tags;

import org.springframework.http.HttpHeaders;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public final class Tracing
{
    private Tracing() {
    }

    public static com.uber.jaeger.Tracer init(String service) {
        SamplerConfiguration samplerConfig = new SamplerConfiguration("const", 1);
        ReporterConfiguration reporterConfig = new ReporterConfiguration(true, null, null, null, null);
        Configuration config = new Configuration(service, samplerConfig, reporterConfig);
        return (com.uber.jaeger.Tracer) config.getTracer();
    }

    public static Scope startServerSpan(Tracer tracer, HttpHeaders httpHeaders, String operationName) {
        // format the headers for extraction
        final HashMap<String, String> headers = new HashMap<String, String>();
        for (Map.Entry<String, List<String>> entry : httpHeaders.entrySet()) {
            headers.put(entry.getKey(), entry.getValue().get(0));
        }

        Tracer.SpanBuilder spanBuilder;
        try {
            SpanContext parentSpanCtx = tracer.extract(Format.Builtin.HTTP_HEADERS, new TextMapExtractAdapter(headers));
            if (parentSpanCtx == null) {
                spanBuilder = tracer.buildSpan(operationName);
            } else {
                spanBuilder = tracer.buildSpan(operationName).asChildOf(parentSpanCtx);
            }
        } catch (IllegalArgumentException e) {
            spanBuilder = tracer.buildSpan(operationName);
        }
        // TODO could add more tags like http.url
        return spanBuilder.withTag(Tags.SPAN_KIND.getKey(), Tags.SPAN_KIND_SERVER).startActive(true);
    }
}
