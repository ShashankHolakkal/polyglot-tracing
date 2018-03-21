package controller;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class Controller
{
    @RequestMapping("/")
    String sayHello() {
        return "{\"version\" : \"2.0\"}";
    }
}
