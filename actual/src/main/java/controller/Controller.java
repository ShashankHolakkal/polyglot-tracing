package controller;

import com.google.common.collect.ImmutableMap;
import io.opentracing.Scope;
import io.opentracing.Tracer;
import org.springframework.http.HttpHeaders;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import util.Tracing;

@RestController
public class Controller
{
    @RequestMapping("/")
    String currentVersion(@RequestHeader HttpHeaders headers) {

        Tracer tracer = Tracing.init("current version");
        try (Scope scope = Tracing.startServerSpan(tracer, headers, "fetch current version")) {
            String returnValue = "{\"version\" : \"2.0\"}";
            scope.span().log(ImmutableMap.of("event", "println", "value", returnValue));
            return returnValue;
        }

    }
}
