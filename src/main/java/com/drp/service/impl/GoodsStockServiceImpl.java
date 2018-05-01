package com.drp.service.impl;

import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.drp.data.dao.*;
import com.drp.data.entity.*;
import com.drp.util.Page;
import com.drp.util.PageParam;
import com.drp.util.UserUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.drp.service.GoodsStockService;


/**
 * 
 * @author gcg
 * @date 2018-03-24 24:53:08
 */
@Service("goodsStockService")
public class GoodsStockServiceImpl implements GoodsStockService {

	@Autowired
	private GoodsStockDao goodsStockDao;
	@Autowired
	private OrderDao orderDao;
	@Autowired
	private OrderGoodsDao orderGoodsDao;
	@Autowired
	private GoodsDao goodsDao;
	@Autowired
	private GoodsStockLogDao goodsStockLogDao;

	@Override
	public Object save(GoodsStock goodsStock) {
		return this.goodsStockDao.insert(goodsStock);
	}

	@Override
	public int delete(GoodsStock goodsStock) {
		return this.goodsStockDao.delete(goodsStock);
	}

	@Override
	public int update(GoodsStock goodsStock) {
		return this.goodsStockDao.update(goodsStock);
	}

	@Override
	public GoodsStock get(GoodsStock goodsStock) {
		return this.goodsStockDao.get(goodsStock);
	}

	@Override
	public Page<GoodsStock> find(PageParam pageParam) {
		return this.goodsStockDao.find(pageParam);
	}

	@Override
	public JSONObject stock(String orderId,String type) {
		JSONObject result = new JSONObject();
		Order order = orderDao.findOrder(orderId);
		if (order == null) {
			result.put("msg", "该采购订单不存在");
			return result;
		}
		List<OrderGoods> orderGoodsList = orderGoodsDao.findOrderGoods(order.getId());
		if (orderGoodsList == null || orderGoodsList.size() == 0) {
			result.put("msg", "该采购订单商品不存在");
			return result;
		}
		for (OrderGoods orderGoods : orderGoodsList) {
			Goods goods = goodsDao.findGoods(orderGoods.getGoodsId());
			if (goods == null) {
				result.put("msg", "该商品不存在");
				return result;
			}
			GoodsStock goodsStock = goodsStockDao.findGoodsStock(orderGoods.getGoodsId());
			if (goodsStock == null) {
				goodsStock.setId(UUID.randomUUID().toString());
				goodsStock.setShopId(order.getShopId());
				goodsStock.setGoodsId(orderGoods.getGoodsId().toString());
				goodsStock.setOriginalStock(0);
				goodsStock.setOutQuentity(0);
				goodsStock.setCurrentStock(0);
				if (type.indexOf("in") != -1) {
					goodsStock.setInQuantity(orderGoods.getNum());
					goodsStock.setCurrentStock(orderGoods.getNum());
				} else {
					result.put("msg", "该商品库存不足，无法出库！");
					return result;
				}
				goodsStock.setStatus(1);
				goodsStock.setCreateBy(UserUtil.getCurUserId());
				goodsStock.setCreateTime(new Date());
				goodsStock.setUpdateBy(UserUtil.getCurUserId());
				goodsStock.setUpdateTime(new Date());

				goodsStockDao.insert(goodsStock);

				this.createStockLog( goodsStock, orderGoods, order, type);

			} else {
				goodsStock.setShopId(order.getShopId());
				goodsStock.setGoodsId(orderGoods.getGoodsId().toString());
				if (type.indexOf("in") != -1) {
					goodsStock.setInQuantity(goodsStock.getInQuantity() + orderGoods.getNum());
					goodsStock.setCurrentStock(orderGoods.getNum());
				} else {
					if (goodsStock.getCurrentStock() == 0) {
						result.put("msg", "该商品库存不足，无法出库！");
						return result;
					} else {
						goodsStock.setOutQuentity(orderGoods.getNum());
						goodsStock.setCurrentStock(goodsStock.getCurrentStock() - orderGoods.getNum());
					}
				}
				goodsStock.setUpdateBy(UserUtil.getCurUserId());
				goodsStock.setUpdateTime(new Date());

				goodsStockDao.update(goodsStock);

				this.createStockLog( goodsStock, orderGoods, order, type);

			}
		}
		return result;
	}

	private void createStockLog(GoodsStock goodsStock,OrderGoods orderGoods,Order order,String type){

		GoodsStockLog stockLog = new GoodsStockLog();

		if (type.indexOf("in") != -1) {
			stockLog.setPreviousStock(goodsStock.getCurrentStock()-orderGoods.getNum());

		} else {
			stockLog.setPreviousStock(goodsStock.getCurrentStock()+orderGoods.getNum());

		}
		stockLog.setShopId(goodsStock.getShopId());
		stockLog.setGoodsId(goodsStock.getGoodsId());
		stockLog.setQuantity(orderGoods.getNum());
		stockLog.setCurrentStock(goodsStock.getCurrentStock());
		stockLog.setType(type);
		stockLog.setNumber(order.getNumber());
		stockLog.setCreateBy(UserUtil.getCurUserId());
		stockLog.setCreateTime(new Date());
		stockLog.setUpdateBy(UserUtil.getCurUserId());
		stockLog.setUpdateTime(new Date());

		goodsStockLogDao.insert(stockLog);
	}

}