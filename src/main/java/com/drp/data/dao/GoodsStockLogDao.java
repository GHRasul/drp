package com.drp.data.dao;

import com.drp.data.entity.GoodsStockLog;
import com.drp.util.Page;
import com.drp.util.PageParam;

import java.util.HashMap;
import java.util.List;

/**
 * 
 * @author gcg
 * @date 2018-03-24 24:53:08
 */
public interface GoodsStockLogDao extends BaseDao<GoodsStockLog> {

    /**
     * 查找列表
     * @param pageParam
     * @return
     */
    Page<GoodsStockLog> find(PageParam pageParam);

    List<GoodsStockLog> getListAndPrice(HashMap<String,Object> map);
}