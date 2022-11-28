package com.kpk.exam.demo.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class UsrAPITestController {
	
	@RequestMapping("usr/home/APITest")
	String showTestPage() {
		return "usr/home/APITest";
	}
	
	@RequestMapping("usr/home/APITest2")
	String showTest2Page() {
		return "usr/home/APITest2";
	}
}
