package com.drp.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.drp.service.GoodsStockLogService;

/**
 * 
 * @author gcg
 * @date 2018-03-24 24:53:09
 */
@Controller
@RequestMapping("/goodsStockLog")
public class GoodsStockLogController extends BaseController {

	@Autowired
	private GoodsStockLogService goodsStockLogService;
	
	@RequestMapping("/index.do")
	public ModelAndView index() {
		ModelAndView mv = new ModelAndView();
		
		mv.setViewName("/goodsStockLog/index");
		return mv;
	}
	
}