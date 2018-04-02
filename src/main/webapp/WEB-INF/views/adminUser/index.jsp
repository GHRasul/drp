<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@ include file="../base.jsp" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <link href="<%=root %>/resources/css/plugins/bootstrap-table/bootstrap-table.min.css" rel="stylesheet">
    <title>员工管理</title>
</head>
<body class="gray-bg">
    <div class="wrapper wrapper-content animated fadeInRight">
        <div class="ibox float-e-margins">
            <div class="ibox-title">
                <h5>员工管理</h5>
            </div>
            <div class="ibox-content">
                <div class="row">
                    <div id="toolbar">
                        <button type="button" onclick="openModel();" class="btn btn-primary btn-sm">添加</button>
                    </div>
                    <div class="col-sm-12">
                        <table class="table table-striped table-bordered table-hover" id="userTable">
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
                                    <label class="col-sm-4 control-label" for="account">账号名：</label>
                                    <div class="col-sm-8">
                                        <input class="form-control" id="account" name="account" type="text" />
                                    </div>
                                </div>
                            </div>
                            <div class="col-sm-6">
                                <div class="form-group">
                                    <label class="col-sm-4 control-label" for="name">姓名：</label>
                                    <div class="col-sm-8">
                                        <input class="form-control" id="name" name="name" type="text"/>
                                    </div>
                                </div>
                            </div>
                            <div class="col-sm-6">
                                <div class="form-group">
                                    <label class="col-sm-4 control-label" for="mobile">电话：</label>
                                    <div class="col-sm-8">
                                        <input class="form-control" id="mobile" name="mobile" type="text"/>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-sm-6">
                                <div class="form-group">
                                    <label class="col-sm-4 control-label" for="password">密码：</label>
                                    <div class="col-sm-8">
                                        <input class="form-control" id="password" name="password" type="password"/>
                                    </div>
                                </div>
                            </div>
                            <div class="col-sm-6">
                                <div class="form-group">
                                    <label class="col-sm-4 control-label" for="pasTure">确认密码：</label>
                                    <div class="col-sm-8">
                                        <input class="form-control" id="pasTure" name="pasTure" type="password"/>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-info" id="save();">保存</button>
                    <button type="button" class="btn btn-default" data-dismiss="modal" id="closeModal">关闭</button>
                </div>
            </div>
        </div>
    </div>
</body>
<script src="<%=root %>/resources/js/plugins/bootstrap-table/bootstrap-table.min.js"></script>
<script src="<%=root %>/resources/js/plugins/bootstrap-table/locale/bootstrap-table-zh-CN.min.js"></script>
<script type="text/javascript">
    var _userTable;
    $(document).ready(function() {
        _userTable = $('#userTable').bootstrapTable({
            sidePagination:'server',//设置为服务器端分页
            url: '<%=root%>/adminUser/list.do',
            method: 'post',
            contentType: 'application/x-www-form-urlencoded;charset=utf-8',
            striped: true,
            pagination: true,
            pageList: [10,30,50],
            showToggle: true,
            showRefresh: true,
            showColumns: true,
            sortable: true,
            idField: 'id',
            columns: [
                {field: 'account',width: '10%', title: '账号', align: 'center'},
                {field: 'name',width: '15%', title: '姓名', align: 'center'},
                {field: 'mobile', width: '5%', title: '电话', align: 'center'},
                {field: 'roleId',width: '15%', title: '角色', align: 'center'},
                {field: 'status',width: '10%', title: '状态', align: 'center'},
                {field: 'createTime',width: '10%', title: '创建时间', align: 'center'}
            ],
            toolbar: '#toolbar'
        });
    });

    function openModel(id) {
        $("#account").val("");
        $("#name").val("");
        $("#mobile").val("");
        $("#password").val("");
        $("#pasTure").val("");
        $("#modal").modal("show");
    }
    
    function save() {
        var account = $("#account").val();
        var name = $("#name").val();
        var mobile = $("#mobile").val();
        var password = $("#password").val();
        var pasTure = $("#pasTure").val();
        $.ajax({

        });
    }
</script>
</html>