<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@ include file="../base.jsp" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <link href="<%=root %>/resources/css/plugins/bootstrap-table/bootstrap-table.min.css" rel="stylesheet">
    <title>书本基本信息管理</title>
</head>
<body class="gray-bg">
    <div class="wrapper wrapper-content animated fadeInRight">
        <div class="ibox float-e-margins">
            <div class="ibox-title">
                <h5>书本基本信息</h5>
            </div>
            <div class="ibox-content">
                <div class="row">
                    <div class="col-sm-6 m-b-xs">
                        <div class="input-group">
                            <input type="text" id="nameLike" placeholder="名称" class="input-sm form-control"> <span class="input-group-btn">
                            <button type="button" onclick="search();" class="btn btn-sm btn-primary"> 搜索</button> </span>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div id="toolbar">
                        <button type="button" onclick="openModel();" class="btn btn-primary btn-sm">添加</button>
                    </div>
                    <div class="col-sm-12">
                        <table class="table table-striped table-bordered table-hover" id="goodsTable">
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" style="display: none;" data-keyboard="false" data-backdrop="static" id="modal" aria-hidden="true" role="dialog" aria-labelledby="modalHeader">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-body">
                    <form id="myForm" class="form-horizontal">
                        <div class="row">
                            <div class="col-sm-6">
                                <div class="form-group">
                                    <label class="col-sm-4 control-label" for="name"><span style="color:red;">*</span>名称：</label>
                                    <div class="col-sm-8">
                                        <input class="form-control" id="name" name="name" type="text" />
                                    </div>
                                </div>
                            </div>
                            <div class="col-sm-6">
                                <label class="col-sm-4 control-label" for="cate"><span style="color:red;">*</span>类别：</label>
                                <div class="col-sm-8">
                                    <select class="form-control m-b" name="cate" id="cate">
                                        <option value="0">请选择</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-sm-6">
                                <div class="form-group">
                                    <label class="col-sm-4 control-label" for="originalPrice"><span style="color:red;">*</span>成本价：</label>
                                    <div class="col-sm-8">
                                        <input class="form-control" id="originalPrice" name="originalPrice" type="text" />
                                    </div>
                                </div>
                            </div>
                            <div class="col-sm-6">
                                <div class="form-group">
                                    <label class="col-sm-4 control-label" for="salePrice"><span style="color:red;">*</span>售卖价：</label>
                                    <div class="col-sm-8">
                                        <input class="form-control" id="salePrice" name="salePrice" type="text" />
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-sm-6">
                                <div class="form-group">
                                    <label class="col-sm-4 control-label" for="originalAmount">原始库存：</label>
                                    <div class="col-sm-8">
                                        <input class="form-control" id="originalAmount" name="originalAmount" type="text" />
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-sm-12">
                                <label class="col-sm-2 control-label" for="desc">描述：</label>
                                <div class="col-sm-10">
                                    <textarea class="form-control" id="desc"></textarea>
                                </div>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-info" onclick="saveOrUpdate();">保存</button>
                    <button type="button" class="btn btn-default" data-dismiss="modal" id="closeModal">关闭</button>
                </div>
            </div>
        </div>
    </div>

    <input type="hidden" id="hideValue" />
</body>
<script src="<%=root %>/resources/js/plugins/bootstrap-table/bootstrap-table.min.js"></script>
<script src="<%=root %>/resources/js/plugins/bootstrap-table/locale/bootstrap-table-zh-CN.min.js"></script>
<script src="<%=root %>/resources/js/jquery.extends.js"></script>
<script type="text/javascript">
    var _goodsTable;
    $(document).ready(function() {
        _goodsTable = $('#goodsTable').bootstrapTable({
            sidePagination:'server',//设置为服务器端分页
            url: '<%=root%>/goods/list.do',
            method: 'post',
            contentType: 'application/x-www-form-urlencoded;charset=utf-8',
            striped: true,
            pagination: true,
            pageList: [10,30,50],
            showToggle: true,
            showRefresh: true,
            showColumns: true,
            queryParams: queryParams,
            sortable: true,
            idField: 'id',
            columns: [
                {field: 'name',width: '15%', title: '名称', align: 'center'},
                {field: 'cateName', width: '10%', title: '类别', align: 'center'},
                {field: 'salePrice', width: '10%', title: '售卖价格（元）', align: 'center'},
                {field: 'originalPrice', width: '10%', title: '成本价格（元）', align: 'center'},
                {field: 'status',width: '10%', title: '状态', align: 'center',
                    formatter : function(value) {
                        if (value == 'ON') return "上架";
                        else return "下架";
                    }},
                {field: 'remark',width: '20%', title: '描述', align: 'center'},
                {field: 'createTime',width: '10%', title: '创建时间', align: 'center',
                    formatter : function(value) {
                        return $(this).dateFormat(value, 'yyyy-MM-dd HH:mm:ss');
                    }},
                {field: 'opt',width: '10%', title: '操作', align: 'center',
                    formatter: function(value, row){
                        return '<button type="button" class="btn btn-info btn-xs" onclick="openModel(\''+row.id+'\')">编辑</button>&nbsp;&nbsp;'
                            + '<button type="button" class="btn btn-danger btn-xs" onclick="deleteData(\''+row.id+'\')">删除</button>&nbsp;&nbsp;'
                            + '<button type="button" class="btn btn-primary btn-xs" onclick="updateStatus(\''+row.id+'\', \''+row.status+'\')">状态</button>';
                    }}
            ],
            toolbar: '#toolbar'
        });
    });

    function queryParams(params) {
        params.nameLike = $('#nameLike').val();
        return params;
    }

    function search() {
        _goodsTable.bootstrapTable("refresh");
    }

    function openModel(id) {
        $("#cate").empty();
        $("#cate").append("<option value='0'>请选择</option>");
        $.ajax({
            url: "<%=root%>category/getList.do",
            type: "post",
            async: false,
            dataType: "json",
            success:function(data) {
                for (var i = 0; i < data.list.length; i++) {
                    $("#cate").append("<option value="+data.list[i].id+">"+data.list[i].name+"</option>");
                }
            }
        });
        if (id) {
            $("#hideValue").val(id);
            $.ajax({
                url: "<%=root%>goods/getData.do",
                type: "post",
                data: {
                    id:id
                },
                dataType: "json",
                success:function(result) {
                    if (result.msg) {
                        toastr.error(result.msg);
                        return;
                    } else {
                        $("#name").val(result.goods.name);
                        $("#originalPrice").val(result.goods.originalPrice);
                        $("#salePrice").val(result.goods.salePrice);
                        $("#desc").val(result.goods.remark);
                        $("#cate").find("option[value = '"+result.goods.cateId+"']").attr("selected","selected");
                        $("#originalAmount").val(result.amount);
                    }
                }
            });
        } else {
            $("#hideValue").val("");
            $("#name").val("");
            $("#cate option:first").prop("selected", 'selected');
            $("#originalPrice").val("");
            $("#salePrice").val("");
            $("#desc").val("");
            $("#originalAmount").val("");
        }
        $("#modal").modal("show");
    }
    
    function saveOrUpdate() {
        var name = $("#name").val();
        var cateId = $("#cate").val();
        var originalPrice = $("#originalPrice").val();
        var salePrice = $("#salePrice").val();
        var remark = $("#desc").val();
        var id = $("#hideValue").val();
        var originalAmount = $("#originalAmount").val();
        if (isNaN(originalPrice)) {
            toastr.error("成本价请输入数字");
            return;
        }
        if (isNaN(salePrice)) {
            toastr.error("售卖价请输入数字");
            return;
        }
        if (originalAmount && isNaN(originalAmount)) {
            toastr.error("原始库存请输入数字");
            return;
        }
        $.ajax({
            url: "<%=root%>goods/addOrUpdate.do",
            type: "post",
            data: {
                name:name,
                cateId:cateId,
                originalPrice:originalPrice,
                salePrice:salePrice,
                remark:remark,
                id:id,
                originalAmount:originalAmount
            },
            dataType: "json",
            success:function(result) {
                if (result.msg) {
                    toastr.error(result.msg);
                } else {
                    toastr.info("操作成功");
                    _goodsTable.bootstrapTable("refresh");
                    $('#modal').modal('hide');
                }
            }
        });
    }

    function deleteData(id) {
        swal({
            title: "确认删除么？",
            text: "要慎重啊！这个操作可是不能反悔的",
            type: "warning",
            showCancelButton: true,
            confirmButtonColor: "#DD6B55",
            confirmButtonText: "删除",
            cancelButtonText: "取消",
            closeOnConfirm: false,
            closeOnCancel: false,
            showLoaderOnConfirm: true
        },
        function(isConfirm){
            if (isConfirm) {
                $.ajax({
                    url: "<%=root%>goods/delete.do",
                    type: "post",
                    data: {id:id},
                    success:function(result){
                        if (result.msg) {
                            swal("取消", result.msg, "error");
                        } else {
                            swal("成功!", "您删除了这个书本", "success");
                            _goodsTable.bootstrapTable("refresh");
                        }
                    }
                })
            } else {
                swal("取消", "谢谢您的考虑:)", "error");
            }
        });
    }

    function updateStatus(id, status) {
        swal({
            title: "确认修改状态么？",
            text: "要慎重啊！这个操作可是不能反悔的",
            type: "warning",
            showCancelButton: true,
            confirmButtonColor: "#DD6B55",
            confirmButtonText: "修改",
            cancelButtonText: "取消",
            closeOnConfirm: false,
            closeOnCancel: false,
            showLoaderOnConfirm: true
        },
        function(isConfirm){
            if (isConfirm) {
                $.ajax({
                    url: "<%=root%>goods/updateStatus.do",
                    type: "post",
                    data: {
                        id:id,
                        status:status
                    },
                    success:function(result){
                        if (result.msg) {
                            swal("取消", result.msg, "error");
                        } else {
                            swal("成功!", "您修改了状态", "success");
                            _goodsTable.bootstrapTable("refresh");
                        }
                    }
                })
            } else {
                swal("取消", "谢谢您的考虑:)", "error");
            }
        });
    }
</script>
</html>